# ubuntu-mlnx-dpdk

prepare docker build host, Ubuntu 22.04
```
sudo apt-get update
sudo apt-get install awscli -y
sudo apt-get install docker -y
sudo apt-get install docker.io -y 
sudo apt-get install docker-buildx -y
```

login to ECR
```
## Login to ECR
Admin:~/environment $ aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin 291615555612.dkr.ecr.us-east-1.amazonaws.com
Login Succeeded

## Reclaim previous docker build space
Admin:~/environment $ docker system prune --all --force --volumes
Deleted Images:
untagged: 291615555612.dkr.ecr.us-east-1.amazonaws.com/sigitp-ecr:ubuntu-frr
deleted: sha256:da5d74e8ba7902f8f37fe84450a6ac2f0bd334dcb7f24db830fb88c995369e51
deleted: sha256:fee564eb723ef2958d8536b9cb813293baa0e6c1e0aba0e7d704c4ee5eef167e
deleted: sha256:df7f89083e45e26bec3a41324082973acafe986537da899cb3c7075aa570f2c3
deleted: sha256:5ef25730feb795bdb0be8997e5510c9e8cd31c040c67a65db3de8de1039d51d2
deleted: sha256:fc30bdf591b7212bb6a9d104fe31e9e0391c6e5fb918a72b859646a658c41101
deleted: sha256:cdd94f398d310466fa85e4a851bb083025d6de042b3ae3d7bb6e3f99a9682a42
deleted: sha256:64b704b5e0d4c07386bf61403c1a161aed68d4a8558b624fc079b855807a1723
deleted: sha256:acdfb06f9bab1c51168d319a4d4b7fcff4420423d62ccb8a691c4ad3b48624bc
deleted: sha256:cf7cc9db884308c2f7e9a85385461e272a6faf271c6e0c44103cdee0c7073223
deleted: sha256:e5368690ebf2da7e75500cc8ddabe0edf9aff8da0aba83f196f1fab8a9b3038d
deleted: sha256:0e5fd1281aec73bc25e9d923dac688ffa5114590c9d8dfae02d5f47bd82730e0

Deleted build cache objects:
pa47kl412x7vmerr0m7qauqe8
pn7c4nyga6h5jv9ycwbobqdrc
rc7bdrtlq48q5z8dj57leba0c
0fyo52zak115pjxwdtouv4dxi
z2rr62sy9qwzetchvaywcebs1
0k8vlpxginuiq6wiuwr6apl6w
xt72hgt0n2ge4pgrnjkifqtqi
wi8akkumfugl0wo8mad9i61qw
mn5mp5jq2xd7wpvqcsvnwyzrw
orua5gr9zronof8u0pg5vxied
p199ufd8xkhxlx0i70khkphn6
mq691hzecx1atbad0ktbhph5p
f4aiz27x4n359rdtc9ey2i5ts
gwi0y96cb9x3ngxyrutzcxhao

Total reclaimed space: 962.7MB
```

docker build, works for amd64 only, regular build without buildx, then push to ECR
```
ubuntu@ip-172-31-16-91:~/ubuntu-mlnx-dpdk-dockerfile$ sudo docker build -t 291615555612.dkr.ecr.us-east-1.amazonaws.com/sigitp-ecr:ubuntu-mlnx-dpdk-amd64 .
[+] Building 922.9s (9/11)                                                                                                       docker:default
[+] Building 923.0s (9/11)                                                                                                       docker:default
[+] Building 923.2s (9/11)                                                                                                       docker:default
[+] Building 1066.4s (12/12) FINISHED                                                                                            docker:default
 => [internal] load build definition from Dockerfile                                                                                       0.0s
 => => transferring dockerfile: 1.91kB                                                                                                     0.0s
 => [internal] load .dockerignore                                                                                                          0.0s
 => => transferring context: 2B                                                                                                            0.0s
 => [internal] load metadata for docker.io/library/ubuntu:22.04                                                                            0.1s
 => CACHED [1/9] FROM docker.io/library/ubuntu:22.04@sha256:adbb90115a21969d2fe6fa7f9af4253e16d45f8d4c1e930182610c4731962658               0.0s 
 => => resolve docker.io/library/ubuntu:22.04@sha256:adbb90115a21969d2fe6fa7f9af4253e16d45f8d4c1e930182610c4731962658                      0.0s 
 => [2/9] RUN apt-get update && apt-get install -y dpkg libnl-3-dev libnl-route-3-dev libnl-3-200 libnl-route-3-200 udev libmnl-dev libn  39.5s 
 => [3/9] RUN pip3 install pyelftools                                                                                                      1.3s 
 => [4/9] RUN if [ "23.10-1.1.9.0" != "" ] ; then  cd /root/ && wget https://linux.mellanox.com/public/repo/mlnx_ofed/23.10-1.1.9.0/ubunt  3.2s 
 => [5/9] RUN cd /root/ && dpkg -i *.deb                                                                                                   0.8s 
 => [6/9] RUN cd /usr/src/ &&  wget https://git.dpdk.org/dpdk/snapshot/dpdk-21.11-rc4.tar.gz && tar xzvf dpdk-21.11-rc4.tar.gz            11.5s 
 => [7/9] RUN cd /usr/src/dpdk-21.11-rc4 && meson build && ninja -C build                                                                952.7s 
 => [8/9] RUN rm -rf /tmp/* && rm /usr/src/dpdk-21.11-rc4.tar.gz                                                                           0.3s 
 => exporting to image                                                                                                                    56.6s 
 => => exporting layers                                                                                                                   41.1s 
 => => exporting manifest sha256:50540de46df450e633ed3948ceb35b99a3fe8dfc9d03ae1f1da5cdb2521604f5                                          0.0s 
 => => exporting config sha256:5b86196bc4250d75f8234d3d8954e61a878d1a5c9b536b2b0d65d6a79830fd66                                            0.0s 
 => => exporting attestation manifest sha256:8cd1fa317ed365eeabf671ab97924b8c8d4bdc776de0f68a8a75599b7742c3f6                              0.0s 
 => => exporting manifest list sha256:738f627b78205cbdd12bd621177b36cd888f4a31eff077bd792f3a6759f4961e                                     0.0s
 => => naming to 291615555612.dkr.ecr.us-east-1.amazonaws.com/sigitp-ecr:ubuntu-mlnx-dpdk-amd64                                            0.0s
 => => unpacking to 291615555612.dkr.ecr.us-east-1.amazonaws.com/sigitp-ecr:ubuntu-mlnx-dpdk-amd64                                        15.4s
ubuntu@ip-172-31-16-91:~/ubuntu-mlnx-dpdk-dockerfile$ sudo docker images
REPOSITORY                                                TAG                      IMAGE ID       CREATED        SIZE
291615555612.dkr.ecr.us-east-1.amazonaws.com/sigitp-ecr   ubuntu-mlnx-dpdk-amd64   738f627b7820   19 hours ago   1.9GB
ubuntu@ip-172-31-16-91:~/ubuntu-mlnx-dpdk-dockerfile$ sudo docker push 291615555612.dkr.ecr.us-east-1.amazonaws.com/sigitp-ecr:ubuntu-mlnx-dpdk-amd64
8cd1fa317ed3: Pushed 
738f627b7820: Pushed 
e58436ab2b0c: Pushed 
73a347de4d63: Pushed 
ab263c36dd96: Pushed 
f1acc55b78c0: Pushed 
50540de46df4: Pushed 
5b86196bc425: Pushed 
857cc8cb19c0: Pushed 
3af6aecfa2d7: Pushed 
abd85dc07065: Pushed 
3045eb314b32: Pushed 
a5d3781910db: Pushed 
a305f2aba1b8: Pushed 
ubuntu@ip-172-31-16-91:~/ubuntu-mlnx-dpdk-dockerfile$ 
```
