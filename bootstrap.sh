#!/bin/bash

export VSTS_AGENT_INPUT_URL=${url}
export VSTS_AGENT_INPUT_AUTH=pat
export VSTS_AGENT_INPUT_TOKEN=${token}
export VSTS_AGENT_INPUT_POOL=${pool}

cd /home/ubuntu
 
wget https://vstsagentpackage.azureedge.net/agent/2.169.1/vsts-agent-linux-x64-2.169.1.tar.gz
mkdir myagent && cd myagent
tar zxvf ../vsts-agent-linux-x64-2.169.1.tar.gz
./bin/installdependencies.sh
chown -R ubuntu:ubuntu .
su ubuntu -c './config.sh --unattended'
echo "HOME=/home/ubuntu" >> .env
./svc.sh install

apt-get install -y curl
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv-keys 7EA0A9C3F273FCD8
apt-get update && apt-get install -y apt-transport-https gnupg2
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
apt-get update
apt-get install -y kubectl

wget https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb
apt-get update
apt-get install -y apt-transport-https
apt-get update
apt-get install -y dotnet-sdk-${dotnet_sdk_version}

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-cache policy docker-ce
apt-get install -y docker-ce
usermod -aG docker ubuntu

./svc.sh start

mkdir -p _work

chown -R ubuntu:ubuntu _work