# TX, Optimized - saturation achieved
./build/app/dpdk-testpmd -l 49-64,144-160 -n 6 -a 0001:16:00.4,mprq_en=1,rxqs_min_mprq=1,mprq_log_stride_num=9,txq_inline_mpw=128,rxq_pkt_pad_en=1 --file-prefix sigitp-dpdk-test --socket-mem=4096,4096 --proc-type=auto -- --mbcache=512 --burst=64 --nb-cores=32 --rxq=24 --txq=24 -i --rxd=8192 --txd=8192 --forward-mode=txonly --txonly-multi-flow --tx-ip=169.10.1.4,169.10.1.5 --eth-peer=0,46:2c:0b:44:84:8e

testpmd> show port stats 0

  ######################## NIC statistics for port 0  ########################
  RX-packets: 0          RX-missed: 0          RX-bytes:  0
  RX-errors: 0
  RX-nombuf:  0         
  TX-packets: 272966271670 TX-errors: 0          TX-bytes:  17469841388288

  Throughput (since last show)
  Rx-pps:            0          Rx-bps:            0
  Tx-pps:    187579263          Tx-bps:  96040582640
  ############################################################################
testpmd> 

# RX, Optimized - saturation achieved
./build/app/dpdk-testpmd -l 49-64,144-160 -a 0001:16:00.4,mprq_en=1,rxqs_min_mprq=1,mprq_log_stride_num=9,txq_inline_mpw=128,rxq_pkt_pad_en=1 --file-prefix sigitp-dpdk-test -- --nb-cores=32 --rxq=24 --txq=24 -i --forward-mode=rxonly --eth-peer=0,ca:3c:7c:8b:b2:7e --stats-period 5

testpmd> show port stats 0

  ######################## NIC statistics for port 0  ########################
  RX-packets: 264851673444 RX-missed: 0          RX-bytes:  16950507100416
  RX-errors: 0
  RX-nombuf:  0         
  TX-packets: 0          TX-errors: 0          TX-bytes:  0

  Throughput (since last show)
  Rx-pps:    182173653          Rx-bps:  93272910352
  Tx-pps:            0          Tx-bps:            0
  ############################################################################
testpmd> 

## Checking CPU allocation on the pods
ubuntu@ip-172-31-26-158:~$ kubectl exec -it mlnx-dpdk-dsf-node1 -- sh -c 'KUBEPOD_SLICE=$(cut -d: -f3 /proc/self/cgroup); cat /sys/fs/cgroup$KUBEPOD_SLICE/cpuset.cpus.effective'
49-64,144-160

ubuntu@ip-172-31-26-158:~$ kubectl exec -it mlnx-dpdk-dsf-node2 -- sh -c 'KUBEPOD_SLICE=$(cut -d: -f3 /proc/self/cgroup); cat /sys/fs/cgroup$KUBEPOD_SLICE/cpuset.cpus.effective'
49-64,144-160

kubectl exec -it mlnx-dpdk-1001-1002-node1 -- sh -c 'KUBEPOD_SLICE=$(cut -d: -f3 /proc/self/cgroup); cat /sys/fs/cgroup$KUBEPOD_SLICE/cpuset.cpus.effective'
49-64,144-160

kubectl exec -it mlnx-dpdk-1001-1002-node2 -- sh -c 'KUBEPOD_SLICE=$(cut -d: -f3 /proc/self/cgroup); cat /sys/fs/cgroup$KUBEPOD_SLICE/cpuset.cpus.effective'
48-64,144-159

## Checking CPU allocation on the hosts
node-1$ sudo cat /var/lib/kubelet/cpu_manager_state | jq
{
  "policyName": "static",
  "defaultCpuSet": "0-47,65-95,97-143,161-191",
  "entries": {
    "a36ce0ef-3989-4bd8-993d-0fba17c44b89": {
      "ubuntu-netutils": "48"
    },
    "af9c544c-dbc1-40f6-9392-dc5187b8c04c": {
      "ubuntu-mlnx-dpdk": "49-64,144-160"
    },
    "ed292075-3565-4919-83dc-248e3bf09ead": {
      "ubuntu-frr": "96"
    }
  },
  "checksum": 470772457
}
node-1$ 

node-2$ sudo cat /var/lib/kubelet/cpu_manager_state | jq
{
  "policyName": "static",
  "defaultCpuSet": "0-47,65-95,97-143,161-191",
  "entries": {
    "2ca9fce0-898b-4f5b-bd4e-4d4faf20935c": {
      "ubuntu-frr": "96"
    },
    "bced91a0-2e23-4a5e-98b5-1887239e7c9a": {
      "ubuntu-mlnx-dpdk": "49-64,144-160"
    },
    "d8f48b9f-fad8-40d2-a222-2286a88f6129": {
      "ubuntu-netutils": "48"
    }
  },
  "checksum": 67353168
}
node-2$ 
