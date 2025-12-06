#!/bin/bash

# Pod-based 24/7 continuous iperf3 full mesh traffic
# Runs performance testing directly inside pods, not on host

# Get all running pods dynamically
PODS=($(kubectl get pods --no-headers | grep Running | grep -E "(mg-pod|lb-bgp-pod)" | awk '{print $1}' | sort))

echo "Starting pod-based iperf3 FULL MESH traffic with ${#PODS[@]} pods..."
echo "Total connections: $((${#PODS[@]} * (${#PODS[@]} - 1)))"
echo "Started at: $(date)"

# Install iperf3 on all pods
echo "Installing iperf3 on all pods..."
for pod in "${PODS[@]}"; do
    kubectl exec $pod -- bash -c "which iperf3 || (apt-get update -qq && apt-get install -y -qq iperf3 iproute2 curl)" &
done
wait
sleep 10

# Create the pod-internal testing script
cat > /tmp/pod-mesh-test.sh << 'EOF'
#!/bin/bash
POD_NAME=$(hostname)
LOG_DIR="/tmp/iperf3-logs"
mkdir -p $LOG_DIR

# Get pod IP
POD_IP=$(ip route get 1.1.1.1 | awk '{print $7; exit}')
echo "Pod $POD_NAME IP: $POD_IP"

# Start iperf3 server
pkill iperf3 2>/dev/null
iperf3 -s -D -p 5201

# Get all pod IPs from kubernetes service discovery
get_pod_ips() {
    # Use nslookup to discover other pods via headless service
    # This is a simplified version - in production you'd use proper service discovery
    echo "169.30.1.100 169.30.1.101 169.30.1.102 169.30.1.103 169.30.1.104 169.30.1.105"
}

# Function to test connectivity to target IP
test_connection() {
    local target_ip=$1
    local logfile="$LOG_DIR/${POD_NAME}_to_${target_ip}.log"
    
    while true; do
        if [ "$target_ip" != "$POD_IP" ]; then
            echo "$(date): Testing $POD_NAME -> $target_ip" >> $logfile
            timeout 30 iperf3 -c $target_ip -t 25 -i 5 -p 5201 >> $logfile 2>&1
            if [ $? -ne 0 ]; then
                echo "$(date): Connection to $target_ip failed, retrying in 30s" >> $logfile
                sleep 30
            else
                echo "$(date): Test completed successfully" >> $logfile
                sleep 60  # Wait before next test
            fi
        fi
        sleep 5
    done
}

# Start testing to all target IPs
TARGET_IPS=($(get_pod_ips))
echo "Starting tests from $POD_NAME to ${#TARGET_IPS[@]} targets..."

for target_ip in "${TARGET_IPS[@]}"; do
    if [ "$target_ip" != "$POD_IP" ]; then
        test_connection "$target_ip" &
    fi
done

# Monitor status
while true; do
    echo "$(date): Pod $POD_NAME - Active tests: $(jobs -r | wc -l)"
    echo "Log files: $(ls $LOG_DIR/*.log 2>/dev/null | wc -l)"
    sleep 300
done
EOF

# Deploy the testing script to all pods
echo "Deploying testing script to all pods..."
for pod in "${PODS[@]}"; do
    kubectl cp /tmp/pod-mesh-test.sh $pod:/tmp/pod-mesh-test.sh
    kubectl exec $pod -- chmod +x /tmp/pod-mesh-test.sh
done

# Start the testing on all pods
echo "Starting performance testing on all pods..."
for pod in "${PODS[@]}"; do
    echo "Starting test on $pod..."
    kubectl exec $pod -- bash -c "nohup /tmp/pod-mesh-test.sh > /tmp/mesh-test.log 2>&1 &" &
done

echo "Pod-based performance testing started!"
echo "To monitor a specific pod: kubectl exec <pod-name> -- tail -f /tmp/mesh-test.log"
echo "To stop testing on a pod: kubectl exec <pod-name> -- pkill -f pod-mesh-test.sh"
echo "To stop all testing: kubectl get pods --no-headers | grep Running | grep -E '(mg-pod|lb-bgp-pod)' | awk '{print \$1}' | xargs -I {} kubectl exec {} -- pkill -f pod-mesh-test.sh"

# Monitor overall status
while true; do
    echo "$(date): Monitoring pod-based performance testing..."
    running_tests=0
    for pod in "${PODS[@]}"; do
        if kubectl exec $pod -- pgrep -f pod-mesh-test.sh >/dev/null 2>&1; then
            ((running_tests++))
        fi
    done
    echo "Pods running tests: $running_tests/${#PODS[@]}"
    
    # Show sample log from first pod
    if [ ${#PODS[@]} -gt 0 ]; then
        echo "Sample from ${PODS[0]}:"
        kubectl exec ${PODS[0]} -- tail -3 /tmp/mesh-test.log 2>/dev/null || echo "No logs yet"
    fi
    
    sleep 300  # Report every 5 minutes
done
