## Recompile DPDK to use more than 128 vCPU --> done on the ECR Image rebuild
## edit
./x86/meson.build:74:dpdk_conf.set('RTE_MAX_LCORE', 128)
## to become
./x86/meson.build:74:dpdk_conf.set('RTE_MAX_LCORE', 191)

## then rebuild
root@mlnx-dpdk-dsf-node1:/usr/src/dpdk-21.11-rc4# meson build
root@mlnx-dpdk-dsf-node1:/usr/src/dpdk-21.11-rc4# ninja -C build

##############################################################################################################################################################################
##############################################################################################################################################################################
TX POD
##############################################################################################################################################################################
##############################################################################################################################################################################

sh-5.2$ sudo cat /var/lib/kubelet/cpu_manager_state | jq
{
  "policyName": "static",
  "defaultCpuSet": "0-47,65-95,97-143,161-191",
  "entries": {
    "52ee2eba-1853-49f0-9df1-6edd31fc332f": {
      "ubuntu-frr": "96"
    },
    "f3ab4a18-0e6d-454d-9e05-d0580eaa4fee": {
      "ubuntu-mlnx-dpdk": "49-64,144-160"
    },
    "f4f4036d-684a-4365-a26b-14af98cba7b2": {
      "ubuntu-netutils": "48"
    }
  },
  "checksum": 1891914285
}
sh-5.2$ 

root@mlnx-dpdk-dsf-node1:/usr/src/dpdk-21.11-rc4# cat config/x86/meson.build | grep 191
dpdk_conf.set('RTE_MAX_LCORE', 191)
root@mlnx-dpdk-dsf-node1:/usr/src/dpdk-21.11-rc4# 

root@mlnx-dpdk-dsf-node1:/usr/src/dpdk-21.11-rc4# ./usertools/dpdk-hugepages.py -s
Node Pages Size Total
0    4     1Gb    4Gb
1    4     1Gb    4Gb

Hugepages mounted on /hugepages

root@mlnx-dpdk-dsf-node1:/usr/src/dpdk-21.11-rc4# ethtool -i net1
driver: mlx5_core
version: 6.1.106-116.188.amzn2023.x86_64
firmware-version: 28.42.1000 (MT_0000000834)
expansion-rom-version: 
bus-info: 0001:16:00.4
supports-statistics: yes
supports-test: yes
supports-eeprom-access: no
supports-register-dump: no
supports-priv-flags: yes
root@mlnx-dpdk-dsf-node1:/usr/src/dpdk-21.11-rc4# 

root@mlnx-dpdk-dsf-node1:/usr/src/dpdk-21.11-rc4# ifconfig net1
net1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 169.10.1.4  netmask 255.255.255.0  broadcast 169.10.1.255
        inet6 fe80::c83c:7cff:fe8b:b27e  prefixlen 64  scopeid 0x20<link>
        ether ca:3c:7c:8b:b2:7e  txqueuelen 1000  (Ethernet)
        RX packets 1  bytes 56 (56.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 13  bytes 996 (996.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

root@mlnx-dpdk-dsf-node1:/usr/src/dpdk-21.11-rc4# 

## NVIDIA report
./build/app/dpdk-testpmd -l 0-8,40-48 -n 6 --socket-mem=4096 
-a 0000:2b:00.0,mprq_en=1,rxqs_min_mprq=1,mprq_log_stride_num=9,txq_inline_mpw=128,rxq_pkt_pad_en=1 
-a 0000:a2:00.1,mprq_en=1,rxqs_min_mprq=1,mprq_log_stride_num=9,txq_inline_mpw=128,rxq_pkt_pad_en=1 -- 
--mbcache=512 --burst=64 --rxq=16 --txq=16 --nb-cores=16 --rxd=8192 --txd=8192 -a 
-i --forward-mode=io --eth-peer=0,00:52:11:22:33:10 --eth-peer=1,00:52:11:22:33:20

./build/app/dpdk-testpmd -l 49-64,144-160 -n 6 -a 0001:16:00.4,mprq_en=1,rxqs_min_mprq=1,mprq_log_stride_num=9,txq_inline_mpw=128,rxq_pkt_pad_en=1 --file-prefix sigitp-dpdk-test --socket-mem=4096,4096 --proc-type=auto -- --mbcache=512 --burst=64 --nb-cores=32 --rxq=24 --txq=24 -i --rxd=8192 --txd=8192 --forward-mode=txonly --txonly-multi-flow --tx-ip=169.10.1.4,169.10.1.5 --eth-peer=0,46:2c:0b:44:84:8e  

root@mlnx-dpdk-dsf-node1:/usr/src/dpdk-21.11-rc4# ./build/app/dpdk-testpmd -l 49-64,144-160 -n 6 -a 0001:16:00.4,mprq_en=1,rxqs_min_mprq=1,mprq_log_stride_num=9,txq_inline_mpw=128,rxq_pkt_pad_en=1 --file-prefix sigitp-dpdk-test --socket-mem=4096,4096 --proc-type=auto -- --mbcache=512 --burst=64 --nb-cores=32 --rxq=24 --txq=24 -i --rxd=8192 --txd=8192 --forward-mode=txonly --txonly-multi-flow --tx-ip=169.10.1.4,169.10.1.5 --eth-peer=0,46:2c:0b:44:84:8e  
EAL: Detected CPU lcores: 191
EAL: Detected NUMA nodes: 2
EAL: Auto-detected process type: PRIMARY
EAL: Detected static linkage of DPDK
EAL: Multi-process socket /var/run/dpdk/sigitp-dpdk-test/mp_socket
EAL: Selected IOVA mode 'PA'
EAL: No available 2048 kB hugepages reported
EAL: Probe PCI driver: mlx5_pci (15b3:101e) device: 0001:16:00.4 (socket 1)
TELEMETRY: No legacy callbacks, legacy socket not created
Interactive-mode selected
Set txonly packet forwarding mode
testpmd: create a new mbuf pool <mb_pool_1>: n=671744, size=2176, socket=1
testpmd: preferred mempool ops selected: ring_mp_mc

Warning! port-topology=paired and odd forward ports number, the last port will pair with itself.

Configuring Port 0 (socket 1)
mlx5_net: adjust txq_inline_max (290->204) due to large Tx queue on port 0
mlx5_net: adjust txq_inline_max (290->204) due to large Tx queue on port 0
mlx5_net: adjust txq_inline_max (290->204) due to large Tx queue on port 0
mlx5_net: adjust txq_inline_max (290->204) due to large Tx queue on port 0
mlx5_net: adjust txq_inline_max (290->204) due to large Tx queue on port 0
mlx5_net: adjust txq_inline_max (290->204) due to large Tx queue on port 0
mlx5_net: adjust txq_inline_max (290->204) due to large Tx queue on port 0
mlx5_net: adjust txq_inline_max (290->204) due to large Tx queue on port 0
mlx5_net: adjust txq_inline_max (290->204) due to large Tx queue on port 0
mlx5_net: adjust txq_inline_max (290->204) due to large Tx queue on port 0
mlx5_net: adjust txq_inline_max (290->204) due to large Tx queue on port 0
mlx5_net: adjust txq_inline_max (290->204) due to large Tx queue on port 0
mlx5_net: adjust txq_inline_max (290->204) due to large Tx queue on port 0
mlx5_net: adjust txq_inline_max (290->204) due to large Tx queue on port 0
mlx5_net: adjust txq_inline_max (290->204) due to large Tx queue on port 0
mlx5_net: adjust txq_inline_max (290->204) due to large Tx queue on port 0
mlx5_net: adjust txq_inline_max (290->204) due to large Tx queue on port 0
mlx5_net: adjust txq_inline_max (290->204) due to large Tx queue on port 0
mlx5_net: adjust txq_inline_max (290->204) due to large Tx queue on port 0
mlx5_net: adjust txq_inline_max (290->204) due to large Tx queue on port 0
mlx5_net: adjust txq_inline_max (290->204) due to large Tx queue on port 0
mlx5_net: adjust txq_inline_max (290->204) due to large Tx queue on port 0
mlx5_net: adjust txq_inline_max (290->204) due to large Tx queue on port 0
mlx5_net: adjust txq_inline_max (290->204) due to large Tx queue on port 0
Port 0: CA:3C:7C:8B:B2:7E
Checking link statuses...
Done
testpmd> 

testpmd> show port summary all
Number of available ports: 1
Port MAC Address       Name         Driver         Status   Link
0    CA:3C:7C:8B:B2:7E 0001:16:00.4 mlx5_pci       up       200 Gbps
testpmd> 

testpmd> start
txonly packet forwarding - ports=1 - cores=24 - streams=24 - NUMA support enabled, MP allocation mode: native
Logical Core 50 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=0 (socket 1) -> TX P=0/Q=0 (socket 1) peer=46:2C:0B:44:84:8E
Logical Core 51 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=1 (socket 1) -> TX P=0/Q=1 (socket 1) peer=46:2C:0B:44:84:8E
Logical Core 52 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=2 (socket 1) -> TX P=0/Q=2 (socket 1) peer=46:2C:0B:44:84:8E
Logical Core 53 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=3 (socket 1) -> TX P=0/Q=3 (socket 1) peer=46:2C:0B:44:84:8E
Logical Core 54 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=4 (socket 1) -> TX P=0/Q=4 (socket 1) peer=46:2C:0B:44:84:8E
Logical Core 55 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=5 (socket 1) -> TX P=0/Q=5 (socket 1) peer=46:2C:0B:44:84:8E
Logical Core 56 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=6 (socket 1) -> TX P=0/Q=6 (socket 1) peer=46:2C:0B:44:84:8E
Logical Core 57 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=7 (socket 1) -> TX P=0/Q=7 (socket 1) peer=46:2C:0B:44:84:8E
Logical Core 58 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=8 (socket 1) -> TX P=0/Q=8 (socket 1) peer=46:2C:0B:44:84:8E
Logical Core 59 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=9 (socket 1) -> TX P=0/Q=9 (socket 1) peer=46:2C:0B:44:84:8E
Logical Core 60 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=10 (socket 1) -> TX P=0/Q=10 (socket 1) peer=46:2C:0B:44:84:8E
Logical Core 61 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=11 (socket 1) -> TX P=0/Q=11 (socket 1) peer=46:2C:0B:44:84:8E
Logical Core 62 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=12 (socket 1) -> TX P=0/Q=12 (socket 1) peer=46:2C:0B:44:84:8E
Logical Core 63 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=13 (socket 1) -> TX P=0/Q=13 (socket 1) peer=46:2C:0B:44:84:8E
Logical Core 64 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=14 (socket 1) -> TX P=0/Q=14 (socket 1) peer=46:2C:0B:44:84:8E
Logical Core 144 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=15 (socket 1) -> TX P=0/Q=15 (socket 1) peer=46:2C:0B:44:84:8E
Logical Core 145 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=16 (socket 1) -> TX P=0/Q=16 (socket 1) peer=46:2C:0B:44:84:8E
Logical Core 146 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=17 (socket 1) -> TX P=0/Q=17 (socket 1) peer=46:2C:0B:44:84:8E
Logical Core 147 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=18 (socket 1) -> TX P=0/Q=18 (socket 1) peer=46:2C:0B:44:84:8E
Logical Core 148 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=19 (socket 1) -> TX P=0/Q=19 (socket 1) peer=46:2C:0B:44:84:8E
Logical Core 149 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=20 (socket 1) -> TX P=0/Q=20 (socket 1) peer=46:2C:0B:44:84:8E
Logical Core 150 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=21 (socket 1) -> TX P=0/Q=21 (socket 1) peer=46:2C:0B:44:84:8E
Logical Core 151 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=22 (socket 1) -> TX P=0/Q=22 (socket 1) peer=46:2C:0B:44:84:8E
Logical Core 152 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=23 (socket 1) -> TX P=0/Q=23 (socket 1) peer=46:2C:0B:44:84:8E

  txonly packet forwarding packets/burst=64
  packet len=64 - nb packet segments=1
  nb forwarding cores=32 - nb forwarding ports=1
  port 0: RX queue number: 24 Tx queue number: 24
    Rx offloads=0x0 Tx offloads=0x0
    RX queue: 0
      RX desc=8192 - RX free threshold=64
      RX threshold registers: pthresh=0 hthresh=0  wthresh=0
      RX Offloads=0x0
    TX queue: 0
      TX desc=8192 - TX free threshold=0
      TX threshold registers: pthresh=0 hthresh=0  wthresh=0
      TX offloads=0x0 - TX RS bit threshold=0
testpmd> 

testpmd> show port stats 0

  ######################## NIC statistics for port 0  ########################
  RX-packets: 0          RX-missed: 0          RX-bytes:  0
  RX-errors: 0
  RX-nombuf:  0         
  TX-packets: 15999269632 TX-errors: 0          TX-bytes:  1023953259968

  Throughput (since last show)
  Rx-pps:            0          Rx-bps:            0
  Tx-pps:    187356769          Tx-bps:  95926727344
  ############################################################################
testpmd>

# second run
testpmd> show port stats 0

  ######################## NIC statistics for port 0  ########################
  RX-packets: 0          RX-missed: 0          RX-bytes:  0
  RX-errors: 0
  RX-nombuf:  0         
  TX-packets: 10702554624 TX-errors: 0          TX-bytes:  684963495936

  Throughput (since last show)
  Rx-pps:            0          Rx-bps:            0
  Tx-pps:    187573076          Tx-bps:  96037413896
  ############################################################################
testpmd> 

testpmd> show port stats 0

  ######################## NIC statistics for port 0  ########################
  RX-packets: 0          RX-missed: 0          RX-bytes:  0
  RX-errors: 0
  RX-nombuf:  0         
  TX-packets: 23941822880 TX-errors: 0          TX-bytes:  1532276664320

  Throughput (since last show)
  Rx-pps:            0          Rx-bps:            0
  Tx-pps:    187467692          Tx-bps:  95983458456
  ############################################################################
testpmd> 

##############################################################################################################################################################################
##############################################################################################################################################################################
RX POD
##############################################################################################################################################################################
##############################################################################################################################################################################

sh-5.2$ sudo cat /var/lib/kubelet/cpu_manager_state | jq
{
  "policyName": "static",
  "defaultCpuSet": "0-47,65-95,97-143,161-191",
  "entries": {
    "39b96f09-531b-4f34-a8d7-9ec6aaec6b9e": {
      "ubuntu-frr": "96"
    },
    "8ec03d68-975e-4083-8be7-62d1bf7f9c34": {
      "ubuntu-netutils": "48"
    },
    "e8044a2a-b30e-4240-8276-09c54594819e": {
      "ubuntu-mlnx-dpdk": "49-64,144-160"
    }
  },
  "checksum": 1622899460
}
sh-5.2$ 

root@mlnx-dpdk-dsf-node2:/usr/src/dpdk-21.11-rc4# cat config/x86/meson.build | grep 191
dpdk_conf.set('RTE_MAX_LCORE', 191)
root@mlnx-dpdk-dsf-node2:/usr/src/dpdk-21.11-rc4# 

root@mlnx-dpdk-dsf-node2:/usr/src/dpdk-21.11-rc4# ./usertools/dpdk-hugepages.py -s
Node Pages Size Total
0    4     1Gb    4Gb
1    4     1Gb    4Gb

Hugepages mounted on /hugepages
root@mlnx-dpdk-dsf-node2:/usr/src/dpdk-21.11-rc4# 

root@mlnx-dpdk-dsf-node2:/usr/src/dpdk-21.11-rc4# ethtool -i net1   
driver: mlx5_core
version: 6.1.106-116.188.amzn2023.x86_64
firmware-version: 28.42.1000 (MT_0000000834)
expansion-rom-version: 
bus-info: 0001:16:00.4
supports-statistics: yes
supports-test: yes
supports-eeprom-access: no
supports-register-dump: no
supports-priv-flags: yes
root@mlnx-dpdk-dsf-node2:/usr/src/dpdk-21.11-rc4# 

root@mlnx-dpdk-dsf-node2:/usr/src/dpdk-21.11-rc4# ifconfig net1
net1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 169.10.1.5  netmask 255.255.255.0  broadcast 169.10.1.255
        inet6 fe80::442c:bff:fe44:848e  prefixlen 64  scopeid 0x20<link>
        ether 46:2c:0b:44:84:8e  txqueuelen 1000  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 15  bytes 1136 (1.1 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

root@mlnx-dpdk-dsf-node2:/usr/src/dpdk-21.11-rc4# 

## NVIDIA report 
./build/app/dpdk-testpmd -l 49-64,144-160 -n 6 -a 0001:16:00.4,mprq_en=1,rxqs_min_mprq=1,mprq_log_stride_num=9,txq_inline_mpw=128,rxq_pkt_pad_en=1 --file-prefix sigitp-dpdk-test --socket-mem=4096,4096 --proc-type=auto -- --mbcache=512 --burst=64 --nb-cores=32 --rxq=24 --txq=24 -i --rxd=8192 --txd=8192 --forward-mode=rxonly --eth-peer=0,ca:3c:7c:8b:b2:7e --stats-period 5

root@mlnx-dpdk-dsf-node2:/usr/src/dpdk-21.11-rc4# ./build/app/dpdk-testpmd -l 49-64,144-160 -n 6 -a 0001:16:00.4,mprq_en=1,rxqs_min_mprq=1,mprq_log_stride_num=9,txq_inline_mpw=128,rxq_pkt_pad_en=1 --file-prefix sigitp-dpdk-test --socket-mem=4096,4096 --proc-type=auto -- --mbcache=512 --burst=64 --nb-cores=32 --rxq=24 --txq=24 -i --rxd=8192 --txd=8192 --forward-mode=rxonly --eth-peer=0,ca:3c:7c:8b:b2:7e --stats-period 5
EAL: Detected CPU lcores: 191
EAL: Detected NUMA nodes: 2
EAL: Auto-detected process type: PRIMARY
EAL: Detected static linkage of DPDK
EAL: Multi-process socket /var/run/dpdk/sigitp-dpdk-test/mp_socket
EAL: Selected IOVA mode 'PA'
EAL: No available 2048 kB hugepages reported
EAL: Probe PCI driver: mlx5_pci (15b3:101e) device: 0001:16:00.4 (socket 1)
TELEMETRY: No legacy callbacks, legacy socket not created
Interactive-mode selected
Set rxonly packet forwarding mode
testpmd: create a new mbuf pool <mb_pool_1>: n=671744, size=2176, socket=1
testpmd: preferred mempool ops selected: ring_mp_mc

Warning! port-topology=paired and odd forward ports number, the last port will pair with itself.

Configuring Port 0 (socket 1)
mlx5_net: adjust txq_inline_max (290->204) due to large Tx queue on port 0
mlx5_net: adjust txq_inline_max (290->204) due to large Tx queue on port 0
mlx5_net: adjust txq_inline_max (290->204) due to large Tx queue on port 0
mlx5_net: adjust txq_inline_max (290->204) due to large Tx queue on port 0
mlx5_net: adjust txq_inline_max (290->204) due to large Tx queue on port 0
mlx5_net: adjust txq_inline_max (290->204) due to large Tx queue on port 0
mlx5_net: adjust txq_inline_max (290->204) due to large Tx queue on port 0
mlx5_net: adjust txq_inline_max (290->204) due to large Tx queue on port 0
mlx5_net: adjust txq_inline_max (290->204) due to large Tx queue on port 0
mlx5_net: adjust txq_inline_max (290->204) due to large Tx queue on port 0
mlx5_net: adjust txq_inline_max (290->204) due to large Tx queue on port 0
mlx5_net: adjust txq_inline_max (290->204) due to large Tx queue on port 0
mlx5_net: adjust txq_inline_max (290->204) due to large Tx queue on port 0
mlx5_net: adjust txq_inline_max (290->204) due to large Tx queue on port 0
mlx5_net: adjust txq_inline_max (290->204) due to large Tx queue on port 0
mlx5_net: adjust txq_inline_max (290->204) due to large Tx queue on port 0
mlx5_net: adjust txq_inline_max (290->204) due to large Tx queue on port 0
mlx5_net: adjust txq_inline_max (290->204) due to large Tx queue on port 0
mlx5_net: adjust txq_inline_max (290->204) due to large Tx queue on port 0
mlx5_net: adjust txq_inline_max (290->204) due to large Tx queue on port 0
mlx5_net: adjust txq_inline_max (290->204) due to large Tx queue on port 0
mlx5_net: adjust txq_inline_max (290->204) due to large Tx queue on port 0
mlx5_net: adjust txq_inline_max (290->204) due to large Tx queue on port 0
mlx5_net: adjust txq_inline_max (290->204) due to large Tx queue on port 0
Port 0: 46:2C:0B:44:84:8E
Checking link statuses...
Done
testpmd> 

testpmd> show port summary all
Number of available ports: 1
Port MAC Address       Name         Driver         Status   Link
0    46:2C:0B:44:84:8E 0001:16:00.4 mlx5_pci       up       200 Gbps
testpmd> 

testpmd> start
rxonly packet forwarding - ports=1 - cores=24 - streams=24 - NUMA support enabled, MP allocation mode: native
Logical Core 50 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=0 (socket 1) -> TX P=0/Q=0 (socket 1) peer=CA:3C:7C:8B:B2:7E
Logical Core 51 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=1 (socket 1) -> TX P=0/Q=1 (socket 1) peer=CA:3C:7C:8B:B2:7E
Logical Core 52 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=2 (socket 1) -> TX P=0/Q=2 (socket 1) peer=CA:3C:7C:8B:B2:7E
Logical Core 53 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=3 (socket 1) -> TX P=0/Q=3 (socket 1) peer=CA:3C:7C:8B:B2:7E
Logical Core 54 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=4 (socket 1) -> TX P=0/Q=4 (socket 1) peer=CA:3C:7C:8B:B2:7E
Logical Core 55 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=5 (socket 1) -> TX P=0/Q=5 (socket 1) peer=CA:3C:7C:8B:B2:7E
Logical Core 56 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=6 (socket 1) -> TX P=0/Q=6 (socket 1) peer=CA:3C:7C:8B:B2:7E
Logical Core 57 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=7 (socket 1) -> TX P=0/Q=7 (socket 1) peer=CA:3C:7C:8B:B2:7E
Logical Core 58 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=8 (socket 1) -> TX P=0/Q=8 (socket 1) peer=CA:3C:7C:8B:B2:7E
Logical Core 59 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=9 (socket 1) -> TX P=0/Q=9 (socket 1) peer=CA:3C:7C:8B:B2:7E
Logical Core 60 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=10 (socket 1) -> TX P=0/Q=10 (socket 1) peer=CA:3C:7C:8B:B2:7E
Logical Core 61 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=11 (socket 1) -> TX P=0/Q=11 (socket 1) peer=CA:3C:7C:8B:B2:7E
Logical Core 62 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=12 (socket 1) -> TX P=0/Q=12 (socket 1) peer=CA:3C:7C:8B:B2:7E
Logical Core 63 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=13 (socket 1) -> TX P=0/Q=13 (socket 1) peer=CA:3C:7C:8B:B2:7E
Logical Core 64 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=14 (socket 1) -> TX P=0/Q=14 (socket 1) peer=CA:3C:7C:8B:B2:7E
Logical Core 144 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=15 (socket 1) -> TX P=0/Q=15 (socket 1) peer=CA:3C:7C:8B:B2:7E
Logical Core 145 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=16 (socket 1) -> TX P=0/Q=16 (socket 1) peer=CA:3C:7C:8B:B2:7E
Logical Core 146 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=17 (socket 1) -> TX P=0/Q=17 (socket 1) peer=CA:3C:7C:8B:B2:7E
Logical Core 147 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=18 (socket 1) -> TX P=0/Q=18 (socket 1) peer=CA:3C:7C:8B:B2:7E
Logical Core 148 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=19 (socket 1) -> TX P=0/Q=19 (socket 1) peer=CA:3C:7C:8B:B2:7E
Logical Core 149 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=20 (socket 1) -> TX P=0/Q=20 (socket 1) peer=CA:3C:7C:8B:B2:7E
Logical Core 150 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=21 (socket 1) -> TX P=0/Q=21 (socket 1) peer=CA:3C:7C:8B:B2:7E
Logical Core 151 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=22 (socket 1) -> TX P=0/Q=22 (socket 1) peer=CA:3C:7C:8B:B2:7E
Logical Core 152 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=23 (socket 1) -> TX P=0/Q=23 (socket 1) peer=CA:3C:7C:8B:B2:7E

  rxonly packet forwarding packets/burst=64
  nb forwarding cores=32 - nb forwarding ports=1
  port 0: RX queue number: 24 Tx queue number: 24
    Rx offloads=0x0 Tx offloads=0x0
    RX queue: 0
      RX desc=8192 - RX free threshold=64
      RX threshold registers: pthresh=0 hthresh=0  wthresh=0
      RX Offloads=0x0
    TX queue: 0
      TX desc=8192 - TX free threshold=0
      TX threshold registers: pthresh=0 hthresh=0  wthresh=0
      TX offloads=0x0 - TX RS bit threshold=0
testpmd> 

testpmd> show port stats 0

  ######################## NIC statistics for port 0  ########################
  RX-packets: 29928488183 RX-missed: 0          RX-bytes:  1915423243712
  RX-errors: 0
  RX-nombuf:  0         
  TX-packets: 0          TX-errors: 0          TX-bytes:  0

  Throughput (since last show)
  Rx-pps:     18571849          Rx-bps:   9508786928
  Tx-pps:            0          Tx-bps:            0
  ############################################################################
testpmd>

# second run
testpmd> show port stats 0

  ######################## NIC statistics for port 0  ########################
  RX-packets: 9821594650 RX-missed: 0          RX-bytes:  628582057600
  RX-errors: 0
  RX-nombuf:  0         
  TX-packets: 0          TX-errors: 0          TX-bytes:  0

  Throughput (since last show)
  Rx-pps:    182190127          Rx-bps:  93281345496
  Tx-pps:            0          Tx-bps:            0
  ############################################################################
testpmd> 

testpmd> show port stats 0

  ######################## NIC statistics for port 0  ########################
  RX-packets: 23798980369 RX-missed: 0          RX-bytes:  1523134743616
  RX-errors: 0
  RX-nombuf:  0         
  TX-packets: 0          TX-errors: 0          TX-bytes:  0

  Throughput (since last show)
  Rx-pps:    182184934          Rx-bps:  93278686672
  Tx-pps:            0          Tx-bps:            0
  ############################################################################
testpmd> 