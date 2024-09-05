## Recompile DPDK to use more than 128 vCPU
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
  "defaultCpuSet": "0-47,57-95,97-144,153-191",
  "entries": {
    "6bbffc7c-9b49-452b-9c12-908637657b05": {
      "ubuntu-mlnx-dpdk": "49-56,145-152"
    },
    "830f93db-aff7-4dbb-9310-9f41a4d3a08a": {
      "ubuntu-frr": "96"
    },
    "8c06a328-ca2c-4a86-865e-3bde46956cc7": {
      "ubuntu-netutils": "48"
    }
  },
  "checksum": 2405425341
}
sh-5.2$ 

root@mlnx-dpdk-dsf-node1:/usr/src/dpdk-21.11-rc4# ./usertools/dpdk-hugepages.py -s
Node Pages Size Total
0    4     1Gb    4Gb
1    4     1Gb    4Gb

Hugepages mounted on /hugepages
root@mlnx-dpdk-dsf-node1:/usr/src/dpdk-21.11-rc4# 

root@mlnx-dpdk-dsf-node1:/usr/src/dpdk-21.11-rc4# ethtool -i net1
driver: mlx5_core
version: 6.1.106-116.188.amzn2023.x86_64
firmware-version: 28.42.1000 (MT_0000000834)
expansion-rom-version: 
bus-info: 0001:16:00.3
supports-statistics: yes
supports-test: yes
supports-eeprom-access: no
supports-register-dump: no
supports-priv-flags: yes

root@mlnx-dpdk-dsf-node1:/usr/src/dpdk-21.11-rc4# ifconfig net1
net1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 169.10.1.4  netmask 255.255.255.0  broadcast 169.10.1.255
        inet6 fe80::10e7:4cff:fe8d:ce86  prefixlen 64  scopeid 0x20<link>
        ether 12:e7:4c:8d:ce:86  txqueuelen 1000  (Ethernet)
        RX packets 5  bytes 364 (364.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 17  bytes 1312 (1.3 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

root@mlnx-dpdk-dsf-node1:/usr/src/dpdk-21.11-rc4# 

./build/app/dpdk-testpmd -l 49-56,145-152 -n 4 -a 0001:16:00.3 --file-prefix sigitp-dpdk-test --socket-mem=4096,4096 --proc-type=auto -- --nb-cores=15 --rxq=4 --txq=4 -i --forward-mode=txonly --txonly-multi-flow --tx-ip=169.10.1.4,169.10.1.5 --eth-peer=0,ee:2a:47:de:e1:eb

root@mlnx-dpdk-dsf-node1:/usr/src/dpdk-21.11-rc4# ./build/app/dpdk-testpmd -l 49-56,145-152 -n 4 -a 0001:16:00.3 --file-prefix sigitp-dpdk-test --socket-mem=4096,4096 --proc-type=auto -- --nb-cores=15 --rxq=4 --txq=4 -i --forward-mode=txonly --txonly-multi-flow --tx-ip=169.10.1.4,169.10.1.5 --eth-peer=0,ee:2a:47:de:e1:eb
EAL: Detected CPU lcores: 191
EAL: Detected NUMA nodes: 2
EAL: Auto-detected process type: PRIMARY
EAL: Detected static linkage of DPDK
EAL: Multi-process socket /var/run/dpdk/sigitp-dpdk-test/mp_socket
EAL: Selected IOVA mode 'PA'
EAL: No available 2048 kB hugepages reported
EAL: Probe PCI driver: mlx5_pci (15b3:101e) device: 0001:16:00.3 (socket 1)
TELEMETRY: No legacy callbacks, legacy socket not created
Interactive-mode selected
Set txonly packet forwarding mode
testpmd: create a new mbuf pool <mb_pool_1>: n=267456, size=2176, socket=1
testpmd: preferred mempool ops selected: ring_mp_mc

Warning! port-topology=paired and odd forward ports number, the last port will pair with itself.

Configuring Port 0 (socket 1)
Port 0: 12:E7:4C:8D:CE:86
Checking link statuses...
Done
testpmd> 

testpmd> show port summary all
Number of available ports: 1
Port MAC Address       Name         Driver         Status   Link
0    12:E7:4C:8D:CE:86 0001:16:00.3 mlx5_pci       up       200 Gbps
testpmd> 

testpmd> show port stats 0

  ######################## NIC statistics for port 0  ########################
  RX-packets: 0          RX-missed: 0          RX-bytes:  0
  RX-errors: 0
  RX-nombuf:  0         
  TX-packets: 6238955584 TX-errors: 0          TX-bytes:  399293161472

  Throughput (since last show)
  Rx-pps:            0          Rx-bps:            0
  Tx-pps:    143279102          Tx-bps:  73358900488
  ############################################################################
testpmd> 

## NVIDIA report
./build/app/dpdk-testpmd -l 0-8,40-48 -n 6 --socket-mem=4096 
-a 0000:2b:00.0,mprq_en=1,rxqs_min_mprq=1,mprq_log_stride_num=9,txq_inline_mpw=128,rxq_pkt_pad_en=1 
-a 0000:a2:00.1,mprq_en=1,rxqs_min_mprq=1,mprq_log_stride_num=9,txq_inline_mpw=128,rxq_pkt_pad_en=1 -- 
--mbcache=512 --burst=64 --rxq=16 --txq=16 --nb-cores=16 --rxd=8192 --txd=8192 -a 
-i --forward-mode=io --eth-peer=0,00:52:11:22:33:10 --eth-peer=1,00:52:11:22:33:20

./build/app/dpdk-testpmd -l 49-56,145-152 -n 6 -a 0001:16:00.3,mprq_en=1,rxqs_min_mprq=1,mprq_log_stride_num=9,txq_inline_mpw=128,rxq_pkt_pad_en=1 --file-prefix sigitp-dpdk-test --socket-mem=4096,4096 --proc-type=auto -- --mbcache=512 --burst=64 --nb-cores=15 --rxq=15 --txq=15 -i --rxd=8192 --txd=8192 --forward-mode=txonly --txonly-multi-flow --tx-ip=169.10.1.4,169.10.1.5 --eth-peer=0,ee:2a:47:de:e1:eb  

root@mlnx-dpdk-dsf-node1:/usr/src/dpdk-21.11-rc4# ./build/app/dpdk-testpmd -l 49-56,145-152 -n 6 -a 0001:16:00.3,mprq_en=1,rxqs_min_mprq=1,mprq_log_stride_num=9,txq_inline_mpw=128,rxq_pkt_pad_en=1 --file-prefix sigitp-dpdk-test --socket-mem=4096,4096 --proc-type=auto -- --mbcache=512 --burst=64 --nb-cores=15 --rxq=15 --txq=15 -i --rxd=8192 --txd=8192 --forward-mode=txonly --txonly-multi-flow --tx-ip=169.10.1.4,169.10.1.5 --eth-peer=0,ee:2a:47:de:e1:eb  
EAL: Detected CPU lcores: 191
EAL: Detected NUMA nodes: 2
EAL: Auto-detected process type: PRIMARY
EAL: Detected static linkage of DPDK
EAL: Multi-process socket /var/run/dpdk/sigitp-dpdk-test/mp_socket
EAL: Selected IOVA mode 'PA'
EAL: No available 2048 kB hugepages reported
EAL: Probe PCI driver: mlx5_pci (15b3:101e) device: 0001:16:00.3 (socket 1)
TELEMETRY: No legacy callbacks, legacy socket not created
Interactive-mode selected
Set txonly packet forwarding mode
testpmd: create a new mbuf pool <mb_pool_1>: n=393216, size=2176, socket=1
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
Port 0: 12:E7:4C:8D:CE:86
Checking link statuses...
Done
testpmd> 

##############################################################################################################################################################################
##############################################################################################################################################################################
RX POD
##############################################################################################################################################################################
##############################################################################################################################################################################

sh-5.2$ sudo cat /var/lib/kubelet/cpu_manager_state | jq
{
  "policyName": "static",
  "defaultCpuSet": "0-47,57-95,97-144,153-191",
  "entries": {
    "8d77362a-3a53-4693-af29-cd7a60333d5d": {
      "ubuntu-frr": "96"
    },
    "a44f2223-3ab5-4b09-8e50-62e9b3238605": {
      "ubuntu-netutils": "48"
    },
    "ff029745-7394-4549-a8dd-f416504245f1": {
      "ubuntu-mlnx-dpdk": "49-56,145-152"
    }
  },
  "checksum": 3055125623
}
sh-5.2$ 

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
bus-info: 0001:16:01.0
supports-statistics: yes
supports-test: yes
supports-eeprom-access: no
supports-register-dump: no
supports-priv-flags: yes

root@mlnx-dpdk-dsf-node2:/usr/src/dpdk-21.11-rc4# ifconfig net1
net1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 169.10.1.5  netmask 255.255.255.0  broadcast 169.10.1.255
        inet6 fe80::ec2a:47ff:fede:e1eb  prefixlen 64  scopeid 0x20<link>
        ether ee:2a:47:de:e1:eb  txqueuelen 1000  (Ethernet)
        RX packets 4  bytes 308 (308.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 18  bytes 1382 (1.3 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

root@mlnx-dpdk-dsf-node2:/usr/src/dpdk-21.11-rc4# 

./build/app/dpdk-testpmd -l 49-56,145-152 --a 0001:16:01.0 --file-prefix sigitp-dpdk-test --socket-mem=4096,4096 --proc-type=auto -- --nb-cores=15 --rxq=4 --txq=4 -i --forward-mode=rxonly --eth-peer=0,12:e7:4c:8d:ce:86 --stats-period 5

root@mlnx-dpdk-dsf-node2:/usr/src/dpdk-21.11-rc4# ./build/app/dpdk-testpmd -l 49-56,145-152 --a 0001:16:01.0 --file-prefix sigitp-dpdk-test --socket-mem=4096,4096 --proc-type=auto -- --nb-cores=15 --rxq=4 --txq=4 -i --forward-mode=rxonly --eth-peer=0,12:e7:4c:8d:ce:86 --stats-period 5
EAL: Detected CPU lcores: 191
EAL: Detected NUMA nodes: 2
EAL: Auto-detected process type: PRIMARY
EAL: Detected static linkage of DPDK
EAL: Multi-process socket /var/run/dpdk/sigitp-dpdk-test/mp_socket
EAL: Selected IOVA mode 'PA'
EAL: No available 2048 kB hugepages reported
EAL: Probe PCI driver: mlx5_pci (15b3:101e) device: 0001:16:01.0 (socket 1)
TELEMETRY: No legacy callbacks, legacy socket not created
Interactive-mode selected
Set rxonly packet forwarding mode
testpmd: create a new mbuf pool <mb_pool_1>: n=267456, size=2176, socket=1
testpmd: preferred mempool ops selected: ring_mp_mc

Warning! port-topology=paired and odd forward ports number, the last port will pair with itself.

Configuring Port 0 (socket 1)
Port 0: EE:2A:47:DE:E1:EB
Checking link statuses...
Done
testpmd>

Number of available ports: 1
Port MAC Address       Name         Driver         Status   Link
0    EE:2A:47:DE:E1:EB 0001:16:01.0 mlx5_pci       up       200 Gbps
testpmd> 

testpmd> start
rxonly packet forwarding - ports=1 - cores=4 - streams=4 - NUMA support enabled, MP allocation mode: native
Logical Core 50 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=0 (socket 1) -> TX P=0/Q=0 (socket 1) peer=12:E7:4C:8D:CE:86
Logical Core 51 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=1 (socket 1) -> TX P=0/Q=1 (socket 1) peer=12:E7:4C:8D:CE:86
Logical Core 52 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=2 (socket 1) -> TX P=0/Q=2 (socket 1) peer=12:E7:4C:8D:CE:86
Logical Core 53 (socket 1) forwards packets on 1 streams:
  RX P=0/Q=3 (socket 1) -> TX P=0/Q=3 (socket 1) peer=12:E7:4C:8D:CE:86

  rxonly packet forwarding packets/burst=32
  nb forwarding cores=15 - nb forwarding ports=1
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
  RX-packets: 4966966153 RX-missed: 890        RX-bytes:  317885833792
  RX-errors: 0
  RX-nombuf:  0         
  TX-packets: 0          TX-errors: 0          TX-bytes:  0

  Throughput (since last show)
  Rx-pps:    108197445          Rx-bps:  55397091840
  Tx-pps:            0          Tx-bps:            0
  ############################################################################
testpmd> 

## NVIDIA report
./build/app/dpdk-testpmd -l 49-56,145-152 -n 6 -a 0001:16:01.0,mprq_en=1,rxqs_min_mprq=1,mprq_log_stride_num=9,txq_inline_mpw=128,rxq_pkt_pad_en=1 --file-prefix sigitp-dpdk-test --socket-mem=4096,4096 --proc-type=auto -- --mbcache=512 --burst=64 --nb-cores=15 --rxq=15 --txq=15 -i --rxd=8192 --txd=8192 --forward-mode=rxonly --eth-peer=0,12:e7:4c:8d:ce:86 --stats-period 5

root@mlnx-dpdk-dsf-node2:/usr/src/dpdk-21.11-rc4# ./build/app/dpdk-testpmd -l 49-56,145-152 -n 6 -a 0001:16:01.0,mprq_en=1,rxqs_min_mprq=1,mprq_log_stride_num=9,txq_inline_mpw=128,rxq_pkt_pad_en=1 --file-prefix sigitp-dpdk-test --socket-mem=4096,4096 --proc-type=auto -- --mbcache=512 --burst=64 --nb-cores=15 --rxq=15 --txq=15 -i --rxd=8192 --txd=8192 --forward-mode=rxonly --eth-peer=0,12:e7:4c:8d:ce:86 --stats-period 5
EAL: Detected CPU lcores: 191
EAL: Detected NUMA nodes: 2
EAL: Auto-detected process type: PRIMARY
EAL: Detected static linkage of DPDK
EAL: Multi-process socket /var/run/dpdk/sigitp-dpdk-test/mp_socket
EAL: Selected IOVA mode 'PA'
EAL: No available 2048 kB hugepages reported
EAL: Probe PCI driver: mlx5_pci (15b3:101e) device: 0001:16:01.0 (socket 1)
TELEMETRY: No legacy callbacks, legacy socket not created
Interactive-mode selected
Set rxonly packet forwarding mode
testpmd: create a new mbuf pool <mb_pool_1>: n=393216, size=2176, socket=1
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
Port 0: EE:2A:47:DE:E1:EB
Checking link statuses...
Done
testpmd> 
