## ENA/ENI testing for EC2 instances in Region

### TX
```
./build/app/dpdk-testpmd -l 32-42 -n 6 -a 0000:00:06.0 --file-prefix sigitp-dpdk-test --socket-mem=4096,4096 --proc-type=auto -- --mbcache=512 --burst=64 --nb-cores=8 --rxq=4 --txq=4 -i --rxd=8192 --txd=256 --forward-mode=txonly --txonly-multi-flow --eth-peer=0,1e:5d:f6:08:f6:b9 --tx-ip=10.0.3.9,10.0.3.166 --max-pkt-len=9000
```

### RX
```
./build/app/dpdk-testpmd -l 32-42 -n 6 -a 0000:00:06.0 --file-prefix sigitp-dpdk-test -- --nb-cores=8 --rxq=4 --txq=4 -i --forward-mode=rxonly --eth-peer=0,1e:5d:f6:08:87:09 --stats-period 5
```

### Set MTU and Packet Size
```
testpmd> show port info 0
testpmd> port config mtu 0 9000
testpmd> set txpkts 750
testpmd> start
testpmd> show port stats 0
```
--
ENA team has some utilities for testing also https://github.com/amzn/amzn-ec2-ena-utilities/tree/main/ena-dts. Though the commits are a bit old.
Also see the sample result https://github.com/amzn/amzn-ec2-ena-utilities/blob/main/ena-dts/RESULTS.md
