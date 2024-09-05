
TX
root@mlnx-dpdk-vlan100-node1:/usr/src/dpdk-21.11-rc4# ./build/app/dpdk-testpmd -l 1,2,97,98 -n 4 -a 02:00.3 --file-prefix sigitp-dpdk-test --socket-mem=4096,4096 --proc-type=auto -- --nb-cores=3 --rxq=4 --txq=4 -i --forward-mode=txonly --txonly-multi-flow --tx-ip=169.254.254.55,169.254.254.75 --eth-peer=0,26:de:45:df:09:80                                                                                    

RX
root@mlnx-dpdk-vlan100-node2:/usr/src/dpdk-21.11-rc4# ./build/app/dpdk-testpmd -l 1,2,97,98 --a 02:00.6 --file-prefix sigitp-dpdk-test --socket-mem=4096,4096 --proc-type=auto -- --nb-cores=3 --rxq=4 --txq=4 -i --forward-mode=rxonly --stats-period 5
