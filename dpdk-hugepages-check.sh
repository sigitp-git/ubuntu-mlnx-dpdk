cd /usr/src/dpdk-21.11-rc4
./usertools/dpdk-hugepages.py -s
./usertools/dpdk-hugepages.py -p 1G --setup 8G


root@mlnx-dpdk-vlan100-node1:/usr/src/dpdk-21.11-rc4# ./usertools/dpdk-hugepages.py -s
Node Pages Size Total
0    4     1Gb    4Gb
1    4     1Gb    4Gb

Hugepages mounted on /hugepages
root@mlnx-dpdk-vlan100-node1:/usr/src/dpdk-21.11-rc4# 

root@mlnx-dpdk-vlan100-node2:/usr/src/dpdk-21.11-rc4# ./usertools/dpdk-hugepages.py -s
Node Pages Size Total
0    4     1Gb    4Gb
1    4     1Gb    4Gb

Hugepages mounted on /hugepages
root@mlnx-dpdk-vlan100-node2:/usr/src/dpdk-21.11-rc4# 
