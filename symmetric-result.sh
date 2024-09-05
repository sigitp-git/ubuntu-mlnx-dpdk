##############################################################################################################################################################################
##############################################################################################################################################################################
TX POD
##############################################################################################################################################################################
##############################################################################################################################################################################

sh-5.2$ sudo cat /var/lib/kubelet/cpu_manager_state | jq
{
  "policyName": "static",
  "defaultCpuSet": "0,3-47,49-95,99-191",
  "entries": {
    "830f93db-aff7-4dbb-9310-9f41a4d3a08a": {
      "ubuntu-frr": "96"
    },
    "8c06a328-ca2c-4a86-865e-3bde46956cc7": {
      "ubuntu-netutils": "48"
    },
    "a5cd2c1a-4f17-49b8-8b23-aa4b3df44cba": {
      "ubuntu-mlnx-dpdk": "1-2,97-98"
    }
  },
  "checksum": 574156616
}
sh-5.2$ 

root@mlnx-dpdk-vlan100-node1:/usr/src/dpdk-21.11-rc4# ethtool -i net1
driver: mlx5_core
version: 6.1.106-116.188.amzn2023.x86_64
firmware-version: 28.42.1000 (MT_0000000834)
expansion-rom-version: 
bus-info: 0000:02:00.3
supports-statistics: yes
supports-test: yes
supports-eeprom-access: no
supports-register-dump: no
supports-priv-flags: yes

root@mlnx-dpdk-vlan100-node1:/usr/src/dpdk-21.11-rc4# ifconfig net1
net1: flags=4419<UP,BROADCAST,RUNNING,PROMISC,MULTICAST>  mtu 1500
        inet 169.254.254.55  netmask 255.255.255.0  broadcast 169.254.254.255
        inet6 fe80::24a4:2ff:fe96:2f42  prefixlen 64  scopeid 0x20<link>
        ether 26:a4:02:96:2f:42  txqueuelen 1000  (Ethernet)
        RX packets 23  bytes 1918 (1.9 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 38  bytes 3106 (3.1 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

root@mlnx-dpdk-vlan100-node1:/usr/src/dpdk-21.11-rc4# 

./build/app/dpdk-testpmd -l 1,2,97,98 -n 4 -a 02:00.3 --file-prefix sigitp-dpdk-test --socket-mem=4096,4096 --proc-type=auto -- --nb-cores=3 --rxq=4 --txq=4 -i --forward-mode=txonly --txonly-multi-flow --tx-ip=169.254.254.55,169.254.254.75 --eth-peer=0,26:de:45:df:09:80                                                                                    

root@mlnx-dpdk-vlan100-node1:/usr/src/dpdk-21.11-rc4# ./build/app/dpdk-testpmd -l 1,2,97,98 -n 4 -a 02:00.3 --file-prefix sigitp-dpdk-test --socket-mem=4096,4096 --proc-type=auto -- --nb-cores=3 --rxq=4 --txq=4 -i --forward-mode=txonly --txonly-multi-flow --tx-ip=169.254.254.55,169.254.254.75 --eth-peer=0,26:de:45:df:09:80                                                                                    
EAL: Detected CPU lcores: 128
EAL: Detected NUMA nodes: 2
EAL: Auto-detected process type: PRIMARY
EAL: Detected static linkage of DPDK
EAL: Multi-process socket /var/run/dpdk/sigitp-dpdk-test/mp_socket
EAL: Selected IOVA mode 'PA'
EAL: No available 2048 kB hugepages reported
EAL: Probe PCI driver: mlx5_pci (15b3:101e) device: 0000:02:00.3 (socket 0)
TELEMETRY: No legacy callbacks, legacy socket not created
Interactive-mode selected
Set txonly packet forwarding mode
testpmd: create a new mbuf pool <mb_pool_0>: n=171456, size=2176, socket=0
testpmd: preferred mempool ops selected: ring_mp_mc

Warning! port-topology=paired and odd forward ports number, the last port will pair with itself.

Configuring Port 0 (socket 0)
Port 0: 26:A4:02:96:2F:42
Checking link statuses...
Done
testpmd> 

testpmd> start
txonly packet forwarding - ports=1 - cores=3 - streams=4 - NUMA support enabled, MP allocation mode: native
Logical Core 2 (socket 0) forwards packets on 1 streams:
  RX P=0/Q=0 (socket 0) -> TX P=0/Q=0 (socket 0) peer=26:DE:45:DF:09:80
Logical Core 97 (socket 0) forwards packets on 1 streams:
  RX P=0/Q=1 (socket 0) -> TX P=0/Q=1 (socket 0) peer=26:DE:45:DF:09:80
Logical Core 98 (socket 0) forwards packets on 2 streams:
  RX P=0/Q=2 (socket 0) -> TX P=0/Q=2 (socket 0) peer=26:DE:45:DF:09:80
  RX P=0/Q=3 (socket 0) -> TX P=0/Q=3 (socket 0) peer=26:DE:45:DF:09:80

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
testpmd> 

testpmd> show port stats 0

  ######################## NIC statistics for port 0  ########################
  RX-packets: 0          RX-missed: 0          RX-bytes:  0
  RX-errors: 0
  RX-nombuf:  0         
  TX-packets: 6530991616 TX-errors: 0          TX-bytes:  417983463424

  Throughput (since last show)
  Rx-pps:            0          Rx-bps:            0
  Tx-pps:     91362594          Tx-bps:  46777646536
  ############################################################################
testpmd> 

testpmd> stop
Telling cores to stop...
Waiting for lcores to finish...

  ------- Forward Stats for RX Port= 0/Queue= 0 -> TX Port= 0/Queue= 0 -------
  RX-packets: 0              TX-packets: 3924119584     TX-dropped: 0             

  ------- Forward Stats for RX Port= 0/Queue= 1 -> TX Port= 0/Queue= 1 -------
  RX-packets: 0              TX-packets: 6154646752     TX-dropped: 0             

  ------- Forward Stats for RX Port= 0/Queue= 2 -> TX Port= 0/Queue= 2 -------
  RX-packets: 0              TX-packets: 1966892224     TX-dropped: 0             

  ------- Forward Stats for RX Port= 0/Queue= 3 -> TX Port= 0/Queue= 3 -------
  RX-packets: 0              TX-packets: 1966892224     TX-dropped: 0             

  ---------------------- Forward statistics for port 0  ----------------------
  RX-packets: 0              RX-dropped: 0             RX-total: 0
  TX-packets: 14012550784    TX-dropped: 0             TX-total: 14012550784
  ----------------------------------------------------------------------------

  +++++++++++++++ Accumulated forward statistics for all ports+++++++++++++++
  RX-packets: 0              RX-dropped: 0             RX-total: 0
  TX-packets: 14012550784    TX-dropped: 0             TX-total: 14012550784
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Done.
testpmd> 

NOTE:
- changing peer MAC address to next hop is not correct for L2 network, but might be useful for L3 network
- removing --tx-ip=169.254.254.55,169.254.254.75 makes the traffic asymmetric, tx bps (46576114544) became more than rx bps (38698010784)
- keeping --tx-ip=169.254.254.55,169.254.254.75, but removing --txonly-multi-flow also makes the traffic asymmetric, tx bps (66044473776) rx bps (18366620792)

##############################################################################################################################################################################
##############################################################################################################################################################################
RX POD
##############################################################################################################################################################################
##############################################################################################################################################################################

sh-5.2$ sudo cat /var/lib/kubelet/cpu_manager_state | jq

{
  "policyName": "static",
  "defaultCpuSet": "0,3-47,49-95,99-191",
  "entries": {
    "8d77362a-3a53-4693-af29-cd7a60333d5d": {
      "ubuntu-frr": "96"
    },
    "a44f2223-3ab5-4b09-8e50-62e9b3238605": {
      "ubuntu-netutils": "48"
    },
    "be23d617-ce37-4b59-9d4f-f9cf19faca59": {
      "ubuntu-mlnx-dpdk": "1-2,97-98"
    }
  },
  "checksum": 1533520773
}
sh-5.2$ 

root@mlnx-dpdk-vlan100-node2:/usr/src/dpdk-21.11-rc4# ethtool -i net1
driver: mlx5_core
version: 6.1.106-116.188.amzn2023.x86_64
firmware-version: 28.42.1000 (MT_0000000834)
expansion-rom-version: 
bus-info: 0000:02:00.6
supports-statistics: yes
supports-test: yes
supports-eeprom-access: no
supports-register-dump: no
supports-priv-flags: yes

root@mlnx-dpdk-vlan100-node2:/usr/src/dpdk-21.11-rc4# ifconfig net1
net1: flags=4419<UP,BROADCAST,RUNNING,PROMISC,MULTICAST>  mtu 1500
        inet 169.254.254.75  netmask 255.255.255.0  broadcast 169.254.254.255
        inet6 fe80::24de:45ff:fedf:980  prefixlen 64  scopeid 0x20<link>
        ether 26:de:45:df:09:80  txqueuelen 1000  (Ethernet)
        RX packets 877702912  bytes 56172986514 (56.1 GB)
        RX errors 0  dropped 2614828155  overruns 0  frame 0
        TX packets 126  bytes 8196 (8.1 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

root@mlnx-dpdk-vlan100-node2:/usr/src/dpdk-21.11-rc4# 

./build/app/dpdk-testpmd -l 1,2,97,98 --a 02:00.6 --file-prefix sigitp-dpdk-test --socket-mem=4096,4096 --proc-type=auto -- --nb-cores=3 --rxq=4 --txq=4 -i --forward-mode=rxonly --stats-period 5

root@mlnx-dpdk-vlan100-node2:/usr/src/dpdk-21.11-rc4# ./build/app/dpdk-testpmd -l 1,2,97,98 --a 02:00.6 --file-prefix sigitp-dpdk-test --socket-mem=4096,4096 --proc-type=auto -- --nb-cores=3 --rxq=4 --txq=4 -i --forward-mode=rxonly --stats-period 5
EAL: Detected CPU lcores: 128
EAL: Detected NUMA nodes: 2
EAL: Auto-detected process type: PRIMARY
EAL: Detected static linkage of DPDK
EAL: Multi-process socket /var/run/dpdk/sigitp-dpdk-test/mp_socket
EAL: Selected IOVA mode 'PA'
EAL: No available 2048 kB hugepages reported
EAL: Probe PCI driver: mlx5_pci (15b3:101e) device: 0000:02:00.6 (socket 0)
TELEMETRY: No legacy callbacks, legacy socket not created
Interactive-mode selected
Set rxonly packet forwarding mode
testpmd: create a new mbuf pool <mb_pool_0>: n=171456, size=2176, socket=0
testpmd: preferred mempool ops selected: ring_mp_mc

Warning! port-topology=paired and odd forward ports number, the last port will pair with itself.

Configuring Port 0 (socket 0)
Port 0: 26:DE:45:DF:09:80
Checking link statuses...
Done
testpmd> 

testpmd> start
rxonly packet forwarding - ports=1 - cores=3 - streams=4 - NUMA support enabled, MP allocation mode: native
Logical Core 2 (socket 0) forwards packets on 1 streams:
  RX P=0/Q=0 (socket 0) -> TX P=0/Q=0 (socket 0) peer=02:00:00:00:00:00
Logical Core 97 (socket 0) forwards packets on 1 streams:
  RX P=0/Q=1 (socket 0) -> TX P=0/Q=1 (socket 0) peer=02:00:00:00:00:00
Logical Core 98 (socket 0) forwards packets on 2 streams:
  RX P=0/Q=2 (socket 0) -> TX P=0/Q=2 (socket 0) peer=02:00:00:00:00:00
  RX P=0/Q=3 (socket 0) -> TX P=0/Q=3 (socket 0) peer=02:00:00:00:00:00

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
testpmd> 

testpmd> show port stats 0

  ######################## NIC statistics for port 0  ########################
  RX-packets: 6136957676 RX-missed: 8438       RX-bytes:  392765291264
  RX-errors: 0
  RX-nombuf:  0         
  TX-packets: 0          TX-errors: 0          TX-bytes:  0

  Throughput (since last show)
  Rx-pps:     91423478          Rx-bps:  46808820760
  Tx-pps:            0          Tx-bps:            0
  ############################################################################
testpmd> 

testpmd> stop
Telling cores to stop...
Waiting for lcores to finish...

  ------- Forward Stats for RX Port= 0/Queue= 0 -> TX Port= 0/Queue= 0 -------
  RX-packets: 3034276136     TX-packets: 0              TX-dropped: 0             

  ------- Forward Stats for RX Port= 0/Queue= 1 -> TX Port= 0/Queue= 1 -------
  RX-packets: 3876080831     TX-packets: 0              TX-dropped: 0             

  ------- Forward Stats for RX Port= 0/Queue= 2 -> TX Port= 0/Queue= 2 -------
  RX-packets: 3035356672     TX-packets: 0              TX-dropped: 0             

  ------- Forward Stats for RX Port= 0/Queue= 3 -> TX Port= 0/Queue= 3 -------
  RX-packets: 3876002221     TX-packets: 0              TX-dropped: 0             

  ---------------------- Forward statistics for port 0  ----------------------
  RX-packets: 13821715860    RX-dropped: 19678         RX-total: 13821735538
  TX-packets: 0              TX-dropped: 0             TX-total: 0
  ----------------------------------------------------------------------------

  +++++++++++++++ Accumulated forward statistics for all ports+++++++++++++++
  RX-packets: 13821715860    RX-dropped: 19678         RX-total: 13821735538
  TX-packets: 0              TX-dropped: 0             TX-total: 0
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Done.
testpmd> 
