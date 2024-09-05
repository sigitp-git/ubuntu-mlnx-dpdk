TX
root@mlnx-dpdk-vlan100-node1:/usr/src/dpdk-21.11-rc4# ./build/app/dpdk-testpmd -l 1,2,97,98 -n 4 -a 02:00.3 --file-prefix sigitp-dpdk-test --socket-mem=4096,4096 --proc-type=auto -- --nb-cores=3 --rxq=4 --txq=4 -i --forward-mode=txonly --txonly-multi-flow --tx-ip=169.254.254.55,169.254.254.75 --eth-peer=0,26:de:45:df:09:80                                                                                    

testpmd> show port stats 0

  ######################## NIC statistics for port 0  ########################
  RX-packets: 0          RX-missed: 0          RX-bytes:  0
  RX-errors: 0
  RX-nombuf:  0         
  TX-packets: 13082468576 TX-errors: 0          TX-bytes:  837277988864

  Throughput (since last show)
  Rx-pps:            0          Rx-bps:            0
  Tx-pps:     90456607          Tx-bps:  46313782792
  ############################################################################
testpmd> 

RX
root@mlnx-dpdk-vlan100-node2:/usr/src/dpdk-21.11-rc4# ./build/app/dpdk-testpmd -l 1,2,97,98 --a 02:00.6 --file-prefix sigitp-dpdk-test --socket-mem=4096,4096 --proc-type=auto -- --nb-cores=3 --rxq=4 --txq=4 -i --forward-mode=rxonly --stats-period 5

testpmd> show port stats 0

  ######################## NIC statistics for port 0  ########################
  RX-packets: 13356447363 RX-missed: 21684      RX-bytes:  854812631232
  RX-errors: 0
  RX-nombuf:  0         
  TX-packets: 0          TX-errors: 0          TX-bytes:  0

  Throughput (since last show)
  Rx-pps:     90444297          Rx-bps:  46307480232
  Tx-pps:            0          Tx-bps:            0
  ############################################################################
testpmd> 
