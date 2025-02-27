export KUBEPOD_SLICE=$(cut -d: -f3 /proc/self/cgroup); export CPU=$(cat /sys/fs/cgroup$KUBEPOD_SLICE/cpuset.cpus.effective)
echo ${CPU}

export PCI=$(ethtool -i net1 | grep bus-info | awk '{print $2}')
echo ${PCI}

export IP=$(ifconfig net1 | grep inet | awk '{print $2}')
echo ${IP}

./build/app/dpdk-testpmd --lcores 0@93,1@94,2@95,3@189,4@190,5@191 -n 6 -a ${PCI},mprq_en=1,rxqs_min_mprq=1,mprq_log_stride_num=9,txq_inline_mpw=128,rxq_pkt_pad_en=1 --file-prefix sigitp-dpdk-test --socket-mem=4096,4096 --proc-type=auto -- --mbcache=512 --burst=64 --nb-cores=5 --rxq=24 --txq=24 -i --rxd=8192 --txd=8192
