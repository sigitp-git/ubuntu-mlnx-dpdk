## Pod1
./build/app/dpdk-testpmd -l 1,2,97,98 -n 4 -a 02:00.5 --file-prefix sigitp-dpdk-test --socket-mem=1024,0 --proc-type=auto -- --nb-cores=3 --rxq=4 --txq=4 -i --forward-mode=txonly --eth-peer=0,7e:2b:33:59:0b:2e
./build/app/dpdk-testpmd -l 1,2,97,98 -n 4 -a 02:00.5 --file-prefix sigitp-dpdk-test --socket-mem=1024,0 --proc-type=auto -- --nb-cores=3 --rxq=4 --txq=4 -i --forward-mode=rxonly --eth-peer=0,7e:2b:33:59:0b:2e

## Pod2
./build/app/dpdk-testpmd -l 2,3,98,99 -n 4 -a 02:00.2 --file-prefix sigitp-dpdk-test --socket-mem=1024,0 --proc-type=auto -- --nb-cores=3 --rxq=4 --txq=4 -i --forward-mode=txonly --eth-peer=0,aa:1e:c6:17:9b:fc
./build/app/dpdk-testpmd -l 2,3,98,99 -n 4 -a 02:00.2 --file-prefix sigitp-dpdk-test --socket-mem=1024,0 --proc-type=auto -- --nb-cores=3 --rxq=4 --txq=4 -i --forward-mode=rxonly --eth-peer=0,aa:1e:c6:17:9b:fc
