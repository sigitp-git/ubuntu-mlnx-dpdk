## TX
testpmd> show config rxtx
  txonly packet forwarding packets/burst=32
  packet len=64 - nb packet segments=1
  nb forwarding cores=3 - nb forwarding ports=1
  port 0: RX queue number: 4 Tx queue number: 4
    Rx offloads=0x0 Tx offloads=0x10000
    RX queue: 0
      RX desc=2048 - RX free threshold=64
      RX threshold registers: pthresh=0 hthresh=0  wthresh=0
      RX Offloads=0x0
    TX queue: 0
      TX desc=2048 - TX free threshold=0
      TX threshold registers: pthresh=0 hthresh=0  wthresh=0
      TX offloads=0x10000 - TX RS bit threshold=0

testpmd> show config fwd
txonly packet forwarding - ports=1 - cores=3 - streams=4 - NUMA support enabled, MP allocation mode: native
Logical Core 2 (socket 0) forwards packets on 1 streams:
  RX P=0/Q=0 (socket 0) -> TX P=0/Q=0 (socket 0) peer=7E:2B:33:59:0B:2E
Logical Core 97 (socket 0) forwards packets on 1 streams:
  RX P=0/Q=1 (socket 0) -> TX P=0/Q=1 (socket 0) peer=7E:2B:33:59:0B:2E
Logical Core 98 (socket 0) forwards packets on 2 streams:
  RX P=0/Q=2 (socket 0) -> TX P=0/Q=2 (socket 0) peer=7E:2B:33:59:0B:2E
  RX P=0/Q=3 (socket 0) -> TX P=0/Q=3 (socket 0) peer=7E:2B:33:59:0B:2E

testpmd> start
txonly packet forwarding - ports=1 - cores=3 - streams=4 - NUMA support enabled, MP allocation mode: native
Logical Core 2 (socket 0) forwards packets on 1 streams:
  RX P=0/Q=0 (socket 0) -> TX P=0/Q=0 (socket 0) peer=7E:2B:33:59:0B:2E
Logical Core 97 (socket 0) forwards packets on 1 streams:
  RX P=0/Q=1 (socket 0) -> TX P=0/Q=1 (socket 0) peer=7E:2B:33:59:0B:2E
Logical Core 98 (socket 0) forwards packets on 2 streams:
  RX P=0/Q=2 (socket 0) -> TX P=0/Q=2 (socket 0) peer=7E:2B:33:59:0B:2E
  RX P=0/Q=3 (socket 0) -> TX P=0/Q=3 (socket 0) peer=7E:2B:33:59:0B:2E

  txonly packet forwarding packets/burst=32
  packet len=64 - nb packet segments=1
  nb forwarding cores=3 - nb forwarding ports=1
  port 0: RX queue number: 4 Tx queue number: 4
    Rx offloads=0x0 Tx offloads=0x10000
    RX queue: 0
      RX desc=2048 - RX free threshold=64
      RX threshold registers: pthresh=0 hthresh=0  wthresh=0
      RX Offloads=0x0
    TX queue: 0
      TX desc=2048 - TX free threshold=0
      TX threshold registers: pthresh=0 hthresh=0  wthresh=0
      TX offloads=0x10000 - TX RS bit threshold=0

testpmd> show port stats 0

  ######################## NIC statistics for port 0  ########################
  RX-packets: 0          RX-missed: 0          RX-bytes:  0
  RX-errors: 0
  RX-nombuf:  0         
  TX-packets: 14312327520 TX-errors: 0          TX-bytes:  900477110784

  Throughput (since last show)
  Rx-pps:            0          Rx-bps:            0
  Tx-pps:    131648009          Tx-bps:  67403780736
  ############################################################################
testpmd> 

## RX
testpmd> show config rxtx
  rxonly packet forwarding packets/burst=32
  nb forwarding cores=3 - nb forwarding ports=1
  port 0: RX queue number: 4 Tx queue number: 4
    Rx offloads=0x0 Tx offloads=0x10000
    RX queue: 0
      RX desc=2048 - RX free threshold=64
      RX threshold registers: pthresh=0 hthresh=0  wthresh=0
      RX Offloads=0x0
    TX queue: 0
      TX desc=2048 - TX free threshold=0
      TX threshold registers: pthresh=0 hthresh=0  wthresh=0
      TX offloads=0x10000 - TX RS bit threshold=0

testpmd> show config fwd
rxonly packet forwarding - ports=1 - cores=3 - streams=4 - NUMA support enabled, MP allocation mode: native
Logical Core 3 (socket 0) forwards packets on 1 streams:
  RX P=0/Q=0 (socket 0) -> TX P=0/Q=0 (socket 0) peer=AA:1E:C6:17:9B:FC
Logical Core 98 (socket 0) forwards packets on 1 streams:
  RX P=0/Q=1 (socket 0) -> TX P=0/Q=1 (socket 0) peer=AA:1E:C6:17:9B:FC
Logical Core 99 (socket 0) forwards packets on 2 streams:
  RX P=0/Q=2 (socket 0) -> TX P=0/Q=2 (socket 0) peer=AA:1E:C6:17:9B:FC
  RX P=0/Q=3 (socket 0) -> TX P=0/Q=3 (socket 0) peer=AA:1E:C6:17:9B:FC

testpmd> start
rxonly packet forwarding - ports=1 - cores=3 - streams=4 - NUMA support enabled, MP allocation mode: native
Logical Core 3 (socket 0) forwards packets on 1 streams:
  RX P=0/Q=0 (socket 0) -> TX P=0/Q=0 (socket 0) peer=AA:1E:C6:17:9B:FC
Logical Core 98 (socket 0) forwards packets on 1 streams:
  RX P=0/Q=1 (socket 0) -> TX P=0/Q=1 (socket 0) peer=AA:1E:C6:17:9B:FC
Logical Core 99 (socket 0) forwards packets on 2 streams:
  RX P=0/Q=2 (socket 0) -> TX P=0/Q=2 (socket 0) peer=AA:1E:C6:17:9B:FC
  RX P=0/Q=3 (socket 0) -> TX P=0/Q=3 (socket 0) peer=AA:1E:C6:17:9B:FC

  rxonly packet forwarding packets/burst=32
  nb forwarding cores=3 - nb forwarding ports=1
  port 0: RX queue number: 4 Tx queue number: 4
    Rx offloads=0x0 Tx offloads=0x10000
    RX queue: 0
      RX desc=2048 - RX free threshold=64
      RX threshold registers: pthresh=0 hthresh=0  wthresh=0
      RX Offloads=0x0
    TX queue: 0
      TX desc=2048 - TX free threshold=0
      TX threshold registers: pthresh=0 hthresh=0  wthresh=0
      TX offloads=0x10000 - TX RS bit threshold=0

testpmd> show port stats 0

  ######################## NIC statistics for port 0  ########################
  RX-packets: 2533284493 RX-missed: 1245923873 RX-bytes:  162130207552
  RX-errors: 0
  RX-nombuf:  0         
  TX-packets: 3435244384 TX-errors: 0          TX-bytes:  206114663040

  Throughput (since last show)
  Rx-pps:     35965981          Rx-bps:  18414582544
  Tx-pps:            0          Tx-bps:            0
  ############################################################################
testpmd> 
