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

./build/app/dpdk-testpmd -l 1,2,97,98 -n 4 -a 02:00.3 --file-prefix sigitp-dpdk-test --socket-mem=4096,4096 --proc-type=auto -- --nb-cores=3 --rxq=4 --txq=4 -i --forward-mode=txonly --txonly-multi-flow --tx-ip=169.254.254.55,169.254.254.75 --eth-peer=0,26:de:45:df:09:80

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
