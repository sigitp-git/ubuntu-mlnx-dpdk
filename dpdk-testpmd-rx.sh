export KUBEPOD_SLICE=$(cut -d: -f3 /proc/self/cgroup); export CPU=$(cat /sys/fs/cgroup$KUBEPOD_SLICE/cpuset.cpus.effective)
echo ${CPU}

export PCI=$(ethtool -i net1 | grep bus-info | awk '{print $2}')
echo ${PCI}

export IP=$(ifconfig net1 | grep inet | awk '{print $2}')
echo ${IP}

./build/app/dpdk-testpmd -l ${CPU} -a ${PCI},mprq_en=1,rxqs_min_mprq=1,mprq_log_stride_num=9,txq_inline_mpw=128,rxq_pkt_pad_en=1 --file-prefix sigitp-dpdk-test -- --nb-cores=32 --rxq=24 --txq=24 -i --forward-mode=rxonly --eth-peer=0,2e:61:54:1c:3d:73 --stats-period 5
