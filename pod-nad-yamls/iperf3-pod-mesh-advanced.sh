#!/bin/bash

# Advanced Pod-based 24/7 continuous iperf3 full mesh traffic
# Runs performance testing directly inside pods with proper service discovery

# Get all running pods dynamically
PODS=($(kubectl get pods --no-headers | grep Running | grep -E "(mg-pod|lb-bgp-pod)" | awk '{print $1}' | sort))

echo "Starting advanced pod-based iperf3 FULL MESH traffic with ${#PODS[@]} pods..."
echo "Total potential connections: $((${#PODS[@]} * (${#PODS[@]} - 1)))"
echo "Started at: $(date)"

# Install required packages on all pods
echo "Installing required packages on all pods..."
for pod in "${PODS[@]}"; do
    kubectl exec $pod -- bash -c "which iperf3 || (apt-get update -qq && apt-get install -y -qq iperf3 iproute2 curl dnsutils)" &
done
wait
sleep 10

# Get pod IPs for service discovery
echo "Collecting pod IP addresses..."
declare -A POD_IPS
for pod in "${PODS[@]}"; do
    ip=$(kubectl get pod $pod -o jsonpath='{.status.podIP}')
    POD_IPS[$pod]=$ip
    echo "$pod: $ip"
done

# Create the advanced pod-internal testing script
cat > /tmp/advanced-pod-mesh-test.sh << 'EOF'
#!/bin/bash
POD_NAME=$(hostname)
LOG_DIR="/tmp/iperf3-mesh-logs"
mkdir -p $LOG_DIR

# Get pod IP
POD_IP=$(ip route get 1.1.1.1 | awk '{print $7; exit}')
echo "Pod $POD_NAME starting with IP: $POD_IP"

# Start iperf3 server on multiple ports for load balancing
pkill iperf3 2>/dev/null
for port in 5201 5202 5203; do
    iperf3 -s -D -p $port
done

# Function to discover other pod IPs via Kubernetes API
discover_pod_ips() {
    # Use kubectl from within pod (if available) or service discovery
    # For this demo, we'll use the pre-populated list
    cat /tmp/target_ips.txt 2>/dev/null || echo ""
}

# Function to test connectivity to target IP with multiple ports
test_connection() {
    local target_ip=$1
    local logfile="$LOG_DIR/${POD_NAME}_to_${target_ip}.log"
    local port_base=5201
    
    while true; do
        if [ "$target_ip" != "$POD_IP" ]; then
            # Try different ports for load balancing
            for port_offset in 0 1 2; do
                port=$((port_base + port_offset))
                echo "$(date): Testing $POD_NAME:$POD_IP -> $target_ip:$port" >> $logfile
                
                # Run iperf3 test with specific parameters for high performance
                timeout 25 iperf3 -c $target_ip -t 20 -i 5 -p $port -P 4 --get-server-output >> $logfile 2>&1
                
                if [ $? -eq 0 ]; then
                    echo "$(date): Test to $target_ip:$port completed successfully" >> $logfile
                    break
                else
                    echo "$(date): Test to $target_ip:$port failed, trying next port" >> $logfile
                fi
            done
            
            # Wait between test cycles to prevent overwhelming
            sleep $((30 + RANDOM % 30))
        fi
    done
}

# Function to monitor and report statistics
monitor_stats() {
    while true; do
        echo "$(date): Pod $POD_NAME status report" >> $LOG_DIR/status.log
        echo "Active connections: $(ss -tn | grep :520 | wc -l)" >> $LOG_DIR/status.log
        echo "Active tests: $(jobs -r | wc -l)" >> $LOG_DIR/status.log
        echo "Log files: $(ls $LOG_DIR/*.log 2>/dev/null | wc -l)" >> $LOG_DIR/status.log
        echo "Memory usage: $(free -m | grep Mem | awk '{print $3"/"$2" MB"}')" >> $LOG_DIR/status.log
        echo "CPU load: $(uptime | awk -F'load average:' '{print $2}')" >> $LOG_DIR/status.log
        echo "---" >> $LOG_DIR/status.log
        sleep 120
    done
}

# Start monitoring in background
monitor_stats &

# Read target IPs and start testing
TARGET_IPS=($(discover_pod_ips))
if [ ${#TARGET_IPS[@]} -eq 0 ]; then
    echo "No target IPs found, waiting for discovery..."
    sleep 60
    TARGET_IPS=($(discover_pod_ips))
fi

echo "Starting tests from $POD_NAME to ${#TARGET_IPS[@]} targets..."

# Start tests to all targets with staggered startup
for i in "${!TARGET_IPS[@]}"; do
    target_ip="${TARGET_IPS[$i]}"
    if [ "$target_ip" != "$POD_IP" ]; then
        # Stagger startup to prevent overwhelming
        sleep $((i * 2))
        test_connection "$target_ip" &
    fi
done

# Keep the script running
while true; do
    echo "$(date): Pod $POD_NAME - Active tests: $(jobs -r | wc -l)"
    
    # Restart failed tests
    if [ $(jobs -r | wc -l) -lt $((${#TARGET_IPS[@]} - 1)) ]; then
        echo "$(date): Some tests may have failed, checking..."
        # Could implement restart logic here
    fi
    
    sleep 300
done
EOF

# Create target IP list for each pod
for pod in "${PODS[@]}"; do
    target_list=""
    for target_pod in "${PODS[@]}"; do
        if [ "$pod" != "$target_pod" ]; then
            target_list="$target_list ${POD_IPS[$target_pod]}"
        fi
    done
    echo $target_list > /tmp/target_ips_${pod}.txt
done

# Deploy the testing script and target lists to all pods
echo "Deploying advanced testing script to all pods..."
for pod in "${PODS[@]}"; do
    kubectl cp /tmp/advanced-pod-mesh-test.sh $pod:/tmp/advanced-pod-mesh-test.sh
    kubectl cp /tmp/target_ips_${pod}.txt $pod:/tmp/target_ips.txt
    kubectl exec $pod -- chmod +x /tmp/advanced-pod-mesh-test.sh
done

# Start the testing on all pods with staggered startup
echo "Starting advanced performance testing on all pods..."
for i in "${!PODS[@]}"; do
    pod="${PODS[$i]}"
    echo "Starting advanced test on $pod (${i}/${#PODS[@]})..."
    kubectl exec $pod -- bash -c "nohup /tmp/advanced-pod-mesh-test.sh > /tmp/advanced-mesh-test.log 2>&1 &" &
    sleep 5  # Stagger startup
done

echo ""
echo "Advanced pod-based performance testing started!"
echo "Features:"
echo "  - Multi-port load balancing (ports 5201-5203)"
echo "  - Parallel streams (-P 4)"
echo "  - Staggered startup to prevent overwhelming"
echo "  - Built-in monitoring and statistics"
echo "  - Automatic failure detection"
echo ""
echo "Monitoring commands:"
echo "  Monitor specific pod: kubectl exec <pod-name> -- tail -f /tmp/advanced-mesh-test.log"
echo "  View pod statistics: kubectl exec <pod-name> -- tail -f /tmp/iperf3-mesh-logs/status.log"
echo "  Stop testing on pod: kubectl exec <pod-name> -- pkill -f advanced-pod-mesh-test.sh"
echo ""
echo "Stop all testing:"
echo "  kubectl get pods --no-headers | grep Running | grep -E '(mg-pod|lb-bgp-pod)' | awk '{print \$1}' | xargs -I {} kubectl exec {} -- pkill -f advanced-pod-mesh-test.sh"

# Enhanced monitoring
while true; do
    echo ""
    echo "$(date): Advanced Pod-based Performance Testing Status"
    echo "======================================================="
    
    running_tests=0
    total_connections=0
    
    for pod in "${PODS[@]}"; do
        if kubectl exec $pod -- pgrep -f advanced-pod-mesh-test.sh >/dev/null 2>&1; then
            ((running_tests++))
            connections=$(kubectl exec $pod -- ss -tn 2>/dev/null | grep :520 | wc -l)
            total_connections=$((total_connections + connections))
        fi
    done
    
    echo "Pods running tests: $running_tests/${#PODS[@]}"
    echo "Total active connections: $total_connections"
    echo "Expected connections: $((${#PODS[@]} * (${#PODS[@]} - 1)))"
    
    # Show sample statistics from first few pods
    echo ""
    echo "Sample pod statistics:"
    for i in {0..2}; do
        if [ $i -lt ${#PODS[@]} ]; then
            pod="${PODS[$i]}"
            echo "  $pod:"
            kubectl exec $pod -- tail -2 /tmp/iperf3-mesh-logs/status.log 2>/dev/null | head -1 || echo "    No stats yet"
        fi
    done
    
    sleep 300  # Report every 5 minutes
done
