export KUBEPOD_SLICE=$(cut -d: -f3 /proc/self/cgroup); export CPU=$(cat /sys/fs/cgroup$KUBEPOD_SLICE/cpuset.cpus.effective)
echo ${CPU}

export PCI=$(ethtool -i net1 | grep bus-info | awk '{print $2}')
echo ${PCI}

export IP=$(ifconfig net1 | grep inet | awk '{print $2}')
echo ${IP}

./build/app/dpdk-testpmd -l ${CPU} -n 6 -a ${PCI},mprq_en=1,rxqs_min_mprq=1,mprq_log_stride_num=9,txq_inline_mpw=128,rxq_pkt_pad_en=1 --file-prefix sigitp-dpdk-test --socket-mem=4096,4096 --proc-type=auto -- --mbcache=512 --burst=64 --nb-cores=32 --rxq=24 --txq=24 -i --rxd=8192 --txd=8192 --forward-mode=txonly --txonly-multi-flow --tx-ip=${IP},169.30.1.3 --eth-peer=0,aa:64:62:7a:97:27
