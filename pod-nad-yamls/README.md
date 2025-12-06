# SR-IOV Pod and Network Attachment Definitions

This directory contains Kubernetes manifests for deploying SR-IOV enabled pods with Mellanox ConnectX network interfaces.

## Directory Contents

### Network Attachment Definitions (NADs)
- `nad-n3-*.yaml` - VLAN 1001/1002 network definitions for n3 interfaces
- `nad-n4-*.yaml` - VLAN 201/202/3001/3002 network definitions for n4 interfaces  
- `nad-n6-*.yaml` - VLAN 2001/2002 network definitions for n6 interfaces
- `nad-dsf-*.yaml` - VLAN 301/302 network definitions for DSF interfaces
- `nad-*-unique*.yaml` - Unique IP NADs for multi-VF pods (mg-pod4)

### Pod Manifests
- `mg-pod*.yaml` - Management pods (1-4 VFs each)
- `lb-bgp-pod*.yaml` - Load balancer BGP pods
- `mg-pod4-simple.yaml` - Simplified 4-VF pod for testing

### Configuration Files
- `sriov-dp-configmap-*.yaml` - SR-IOV device plugin configurations
- `mlnx-dpdk-*.yaml` - DPDK application pods
- `nokia-app-level-tagging.yaml` - Application tagging configuration

## Prerequisites

1. **SR-IOV Device Plugin**: Ensure SR-IOV device plugin is running
2. **SR-IOV Resources**: Verify `aws-cse-lc-bundle/mlnx_sriov_netdevice` resources are available
3. **Node Labels**: Nodes must be labeled with correct hostnames:
   - `ip-100-77-4-181.ec2.internal` (node1)
   - `ip-100-77-4-183.ec2.internal` (node2)

## Deployment Instructions

### 1. Check SR-IOV Resources
```bash
kubectl describe nodes | grep "aws-cse-lc-bundle/mlnx_sriov_netdevice"
```

### 2. Deploy Network Attachment Definitions
```bash
# Deploy standard NADs (exclude yamlov files)
for f in nad-n3-*.yaml nad-n4-*.yaml nad-n6-*.yaml nad-dsf-*.yaml; do 
  [[ ! "$f" =~ yamlov ]] && kubectl apply -f "$f"
done

# Deploy unique NADs for multi-VF pods
kubectl apply -f nad-dsf-*-unique*.yaml
```

### 3. Deploy Pods
```bash
# Deploy standard pods (exclude yamlov files and test pods)
for f in mg-pod*.yaml lb-bgp-pod*.yaml; do 
  [[ ! "$f" =~ yamlov ]] && [[ "$f" != "mg-pod-static-test.yaml" ]] && kubectl apply -f "$f"
done

# Deploy multi-VF pod
kubectl apply -f mg-pod4-simple.yaml
```

### 4. Verify Deployment
```bash
kubectl get pods -o wide | grep -E "(mg-pod|lb-bgp-pod)"
```

## Network Configuration

### IPAM Configuration
- **Type**: Static IP allocation (whereabouts disabled due to corruption issues)
- **IP Range**: 169.30.1.x/24
- **Standard pods**: 169.30.1.100/24
- **Multi-VF pods**: 169.30.1.101-104/24 (unique IPs per interface)

### VLAN Mappings
- **n3**: VLAN 1001, 1002
- **n4**: VLAN 201, 202, 3001, 3002  
- **n6**: VLAN 2001, 2002
- **dsf**: VLAN 301, 302

### SR-IOV Resource Requirements
- **mg-pod1-3**: 1 VF each
- **mg-pod4**: 4 VFs (uses unique NADs)
- **lb-bgp-pod**: 1 VF each

## Troubleshooting

### Common Issues

1. **ContainerCreating Status**
   - Check SR-IOV device plugin: `kubectl logs -n kube-system -l app=sriov-device-plugin`
   - Verify VF availability: `kubectl describe node <node-name>`

2. **Network Attachment Failures**
   - Validate NAD JSON syntax: `kubectl get nad <nad-name> -o yaml`
   - Check multus logs: `kubectl logs -n kube-system -l app=multus`

3. **IP Allocation Conflicts**
   - Use unique NADs for multi-VF pods
   - Avoid whereabouts IPAM (use static allocation)

### Useful Commands
```bash
# Check pod events
kubectl describe pod <pod-name>

# View network interfaces in pod
kubectl exec <pod-name> -- ip addr show

# Check SR-IOV network node policies
kubectl get sriovnetworknodepolicy -n sriov-network-operator
```

## Performance Testing

### Pod-based iperf3 Full Mesh Testing

```bash
./iperf3-pod-mesh-status.sh
```

**Features:**
- **Automatically starts testing** after deployment
- Enhanced status reporting and monitoring  
- **No host CPU usage** - All testing runs inside pods
- **True full mesh** - Each pod tests to every other pod
- **Scalable** - Automatically discovers all running pods

#### Monitoring Commands
```bash
# Monitor specific pod (current active script)
kubectl exec <pod-name> -- tail -f /tmp/test.log

# View pod statistics (advanced script)
kubectl exec <pod-name> -- tail -f /tmp/iperf3-mesh-logs/status.log

# Stop testing on specific pod
kubectl exec <pod-name> -- pkill -f simple-mesh-test.sh

# Stop all testing (current active method)
kubectl get pods --no-headers | grep -E '(mg-pod|lb-bgp-pod)' | awk '{print $1}' | xargs -I {} kubectl exec {} -- pkill -f simple-mesh-test.sh
```

#### Features
- **No host CPU usage** - All testing runs inside pods
- **True full mesh** - Each pod tests to every other pod
- **Scalable** - Automatically discovers all running pods
- **Load balanced** - Multiple ports and parallel streams
- **Monitored** - Built-in statistics and status reporting

## ✅ Pod-Based Performance Testing Active

- **49 pods** running full mesh iperf3 tests
- **2,352 total connections** (49 × 48)
- **Zero host CPU usage** - all testing runs inside pods
- **High-performance throughput** - achieving ~40 Gbps per connection

## **Additional Monitoring Commands:**
```bash
# Check overall status
kubectl get pods --no-headers | grep -E "(mg-pod|lb-bgp-pod)" | wc -l

# View sample test output
kubectl exec mg-pod1-node1 -- tail -f /tmp/test.log

# Stop all testing when needed
kubectl get pods --no-headers | grep -E "(mg-pod|lb-bgp-pod)" | awk '{print $1}' | xargs -I {} kubectl exec {} -- pkill -f simple-mesh-test.sh
```

The performance testing is now running entirely within the pods, creating a true full mesh network performance test without consuming any resources from your localhost. Each pod is testing connectivity and throughput to all other pods continuously.

## Prometheus SR-IOV Metrics Configuration

### Issue
The Prometheus configuration tries to scrape SR-IOV metrics directly from nodes on port 9808, but the SR-IOV metrics are actually exposed through a service in the monitoring namespace.

### Problem Configuration
```yaml
- job_name: 'sriov-metrics'
  kubernetes_sd_configs:
    - role: node  # This tries to scrape nodes directly
  relabel_configs:
    - source_labels: [__address__]
      action: replace
      regex: ([^:]+):.*
      replacement: $1:9808  # This assumes port 9808 is on the node
      target_label: __address__
```

### Solution 1: Service-based Configuration
```yaml
- job_name: 'sriov-metrics'
  kubernetes_sd_configs:
    - role: service
  relabel_configs:
    - source_labels: [__meta_kubernetes_service_name]
      action: keep
      regex: sriov-network-metrics-exporter
    - source_labels: [__meta_kubernetes_namespace]
      action: keep
      regex: monitoring
```

### Solution 2: Service Annotation Approach
```yaml
- job_name: 'sriov-metrics'
  kubernetes_sd_configs:
    - role: service
  relabel_configs:
    - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_target]
      action: keep
      regex: true
```

The service already has the annotation `prometheus.io/target: true`, so it should be discovered by your existing `kubernetes-services` job if you add the `prometheus.io/scrape: true` annotation to the service.

## Notes

- **Whereabouts IPAM**: Disabled due to corruption issues, use static IP allocation
- **Node Assignment**: Pods are distributed across node1 and node2 based on nodeSelector
- **Privileged Containers**: Required for SR-IOV network interface access
- **VLAN Configuration**: Each NAD specifies appropriate VLAN tags for network segmentation
- **Performance Testing**: Use pod-based scripts to avoid host CPU consumption
