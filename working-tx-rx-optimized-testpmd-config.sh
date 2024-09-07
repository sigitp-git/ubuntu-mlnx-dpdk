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