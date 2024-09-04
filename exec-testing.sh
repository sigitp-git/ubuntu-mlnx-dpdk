####################################################################################################################################################################################
## RX and TX only
## https://doc.dpdk.org/guides/testpmd_app_ug/testpmd_funcs.html
####################################################################################################################################################################################
## TXONLY
## ./build/app/dpdk-testpmd -l 1,2,97,98 -n 4 -a 02:00.5 --file-prefix sigitp-dpdk-test --socket-mem=1024,0 --proc-type=auto -- --nb-cores=3 --rxq=4 --txq=4 -i --forward-mode=mac --eth-peer=0,7e:2b:33:59:0b:2e
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

## RXONLY
## ./build/app/dpdk-testpmd -l 2,3,98,99 -n 4 -a 02:00.2 --file-prefix sigitp-dpdk-test --socket-mem=1024,0 --proc-type=auto -- --nb-cores=3 --rxq=4 --txq=4 -i --forward-mode=mac --eth-peer=0,aa:1e:c6:17:9b:fc
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

####################################################################################################################################################################################
## Flowgen retry on both end
####################################################################################################################################################################################
## Pod1
testpmd> set fwd flowgen retry
Set flowgen packet forwarding mode with retry
testpmd> start
flowgen packet forwarding with retry - ports=1 - cores=3 - streams=4 - NUMA support enabled, MP allocation mode: native
TX retry num: 64, delay between TX retries: 1us
Logical Core 2 (socket 0) forwards packets on 1 streams:
  RX P=0/Q=0 (socket 0) -> TX P=0/Q=0 (socket 0) peer=7E:2B:33:59:0B:2E
Logical Core 97 (socket 0) forwards packets on 1 streams:
  RX P=0/Q=1 (socket 0) -> TX P=0/Q=1 (socket 0) peer=7E:2B:33:59:0B:2E
Logical Core 98 (socket 0) forwards packets on 2 streams:
  RX P=0/Q=2 (socket 0) -> TX P=0/Q=2 (socket 0) peer=7E:2B:33:59:0B:2E
  RX P=0/Q=3 (socket 0) -> TX P=0/Q=3 (socket 0) peer=7E:2B:33:59:0B:2E

  number of flows for port 0: 1024
  flowgen packet forwarding with retry packets/burst=32
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
  TX-packets: 64400892352 TX-errors: 0          TX-bytes:  3971245344640

  Throughput (since last show)
  Rx-pps:            0          Rx-bps:            0
  Tx-pps:    107614610          Tx-bps:  51655013168
  ############################################################################
testpmd> 

testpmd> show fwd stats all

  ------- Forward Stats for RX Port= 0/Queue= 0 -> TX Port= 0/Queue= 0 -------
  RX-packets: 0              TX-packets: 13079777024    TX-dropped: 0             

  ------- Forward Stats for RX Port= 0/Queue= 1 -> TX Port= 0/Queue= 1 -------
  RX-packets: 0              TX-packets: 19690080832    TX-dropped: 0             

  ------- Forward Stats for RX Port= 0/Queue= 2 -> TX Port= 0/Queue= 2 -------
  RX-packets: 0              TX-packets: 6437547488     TX-dropped: 0             

  ------- Forward Stats for RX Port= 0/Queue= 3 -> TX Port= 0/Queue= 3 -------
  RX-packets: 0              TX-packets: 6437547552     TX-dropped: 0             

  ---------------------- Forward statistics for port 0  ----------------------
  RX-packets: 0              RX-dropped: 0             RX-total: 0
  TX-packets: 45644954144    TX-dropped: 0             TX-total: 45644954144
  ----------------------------------------------------------------------------

  +++++++++++++++ Accumulated forward statistics for all ports+++++++++++++++
  RX-packets: 0              RX-dropped: 0             RX-total: 0
  TX-packets: 45644954144    TX-dropped: 0             TX-total: 45644954144
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
testpmd> 

## Pod2
testpmd> set fwd flowgen retry
Set flowgen packet forwarding mode with retry
testpmd> start
flowgen packet forwarding with retry - ports=1 - cores=3 - streams=4 - NUMA support enabled, MP allocation mode: native
TX retry num: 64, delay between TX retries: 1us
Logical Core 3 (socket 0) forwards packets on 1 streams:
  RX P=0/Q=0 (socket 0) -> TX P=0/Q=0 (socket 0) peer=AA:1E:C6:17:9B:FC
Logical Core 98 (socket 0) forwards packets on 1 streams:
  RX P=0/Q=1 (socket 0) -> TX P=0/Q=1 (socket 0) peer=AA:1E:C6:17:9B:FC
Logical Core 99 (socket 0) forwards packets on 2 streams:
  RX P=0/Q=2 (socket 0) -> TX P=0/Q=2 (socket 0) peer=AA:1E:C6:17:9B:FC
  RX P=0/Q=3 (socket 0) -> TX P=0/Q=3 (socket 0) peer=AA:1E:C6:17:9B:FC

  number of flows for port 0: 1024
  flowgen packet forwarding with retry packets/burst=32
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
  RX-packets: 6340968450 RX-missed: 1245923873 RX-bytes:  405821980800
  RX-errors: 0
  RX-nombuf:  0         
  TX-packets: 46746679104 TX-errors: 0          TX-bytes:  2804800746240

  Throughput (since last show)
  Rx-pps:            0          Rx-bps:            0
  Tx-pps:    108284211          Tx-bps:  51976421504
  ############################################################################
testpmd> 

testpmd> show fwd stats all

  ------- Forward Stats for RX Port= 0/Queue= 0 -> TX Port= 0/Queue= 0 -------
  RX-packets: 0              TX-packets: 14456629056    TX-dropped: 0             

  ------- Forward Stats for RX Port= 0/Queue= 1 -> TX Port= 0/Queue= 1 -------
  RX-packets: 0              TX-packets: 22758399872    TX-dropped: 0             

  ------- Forward Stats for RX Port= 0/Queue= 2 -> TX Port= 0/Queue= 2 -------
  RX-packets: 0              TX-packets: 7092221792     TX-dropped: 0             

  ------- Forward Stats for RX Port= 0/Queue= 3 -> TX Port= 0/Queue= 3 -------
  RX-packets: 0              TX-packets: 7092221792     TX-dropped: 0             

  ---------------------- Forward statistics for port 0  ----------------------
  RX-packets: 0              RX-dropped: 0             RX-total: 0
  TX-packets: 51399473216    TX-dropped: 0             TX-total: 51399473216
  ----------------------------------------------------------------------------

  +++++++++++++++ Accumulated forward statistics for all ports+++++++++++++++
  RX-packets: 0              RX-dropped: 0             RX-total: 0
  TX-packets: 51399473216    TX-dropped: 0             TX-total: 51399473216
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
testpmd> 
