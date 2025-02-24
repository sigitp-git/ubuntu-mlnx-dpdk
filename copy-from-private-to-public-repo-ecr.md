## Pull image from private repository to local machine

```
ubuntu@cloud9-sigitp:~/ubuntu-mlnx-dpdk$ aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin 291615555612.dkr.ecr.us-east-1.amazonaws.com
WARNING! Your password will be stored unencrypted in /root/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded

ubuntu@cloud9-sigitp:~/ubuntu-mlnx-dpdk$ sudo docker pull 291615555612.dkr.ecr.us-east-1.amazonaws.com/sigitp-ecr:ubuntu-mlnx-dpdk-amd64
ubuntu-mlnx-dpdk-amd64: Pulling from sigitp-ecr
857cc8cb19c0: Pull complete
9f9d0e685866: Pull complete
a3242217958e: Pull complete
38c20032c4ff: Pull complete
595af75d8411: Pull complete
7133825149c8: Pull complete
73045eeaad62: Pull complete
c97a4c463b35: Pull complete
54d4e04a0542: Pull complete
Digest: sha256:5a6dbaabacbd8f11d4bf75e7805da40462cd4acaa88f0ccc25fe842c87c2da6a
Status: Downloaded newer image for 291615555612.dkr.ecr.us-east-1.amazonaws.com/sigitp-ecr:ubuntu-mlnx-dpdk-amd64
291615555612.dkr.ecr.us-east-1.amazonaws.com/sigitp-ecr:ubuntu-mlnx-dpdk-amd64


ubuntu@cloud9-sigitp:~/ubuntu-mlnx-dpdk$ sudo docker images
REPOSITORY                                                         TAG                      IMAGE ID       CREATED        SIZE
291615555612.dkr.ecr.us-east-1.amazonaws.com/sigitp-ecr            ubuntu-mlnx-dpdk-amd64   87e987b1aaa3   5 months ago   1.37GB
```

## Push local image to public repository

```
ubuntu@cloud9-sigitp:~/ubuntu-mlnx-dpdk$ aws ecr-public get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin public.ecr.aws/h8q5n8w4
WARNING! Your password will be stored unencrypted in /root/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded

ubuntu@cloud9-sigitp:~/ubuntu-mlnx-dpdk$ sudo docker tag 87e987b1aaa3 public.ecr.aws/h8q5n8w4/sigitp-ecr-public/ubuntu-mlnx-dpdk-amd64

ubuntu@cloud9-sigitp:~/ubuntu-mlnx-dpdk$ sudo docker images
REPOSITORY                                                         TAG                      IMAGE ID       CREATED        SIZE
public.ecr.aws/h8q5n8w4/sigitp-ecr-public/ubuntu-mlnx-dpdk-amd64   latest                   87e987b1aaa3   5 months ago   1.37GB
291615555612.dkr.ecr.us-east-1.amazonaws.com/sigitp-ecr            ubuntu-mlnx-dpdk-amd64   87e987b1aaa3   5 months ago   1.37GB

## create public repository on ECR public.ecr.aws/h8q5n8w4/sigitp-ecr-public/ubuntu-mlnx-dpdk-amd64
ubuntu@cloud9-sigitp:~/ubuntu-mlnx-dpdk$ sudo docker push public.ecr.aws/h8q5n8w4/sigitp-ecr-public/ubuntu-mlnx-dpdk-amd64
Using default tag: latest
The push refers to repository [public.ecr.aws/h8q5n8w4/sigitp-ecr-public/ubuntu-mlnx-dpdk-amd64]
d582d2c8d774: Pushed
63ca5987020d: Pushed
417b11eb2776: Pushed
6ca05e37f68f: Pushed
051f55dec6a4: Pushed
2153eda2f9fb: Pushed
3f6d33e0310a: Pushed
1bca3632cf8f: Pushed
1b9b7346fee7: Pushed
latest: digest: sha256:1ea04b6fa7f75b1bd98e1b6f64d01b7706ccc48b3ac407581f9165d4ca21e92f size: 2214
```
