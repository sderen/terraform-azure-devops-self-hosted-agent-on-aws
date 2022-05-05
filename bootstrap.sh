#!/bin/bash

export VSTS_AGENT_INPUT_URL=${url}
export VSTS_AGENT_INPUT_AUTH=pat
export VSTS_AGENT_INPUT_TOKEN=${token}
export VSTS_AGENT_INPUT_POOL=${pool}

cd /home/ubuntu

function download_and_extract_agent () {
    
    agent_releases_page=$(curl -L https://github.com/Microsoft/azure-pipelines-agent/releases)
    
    # extract latest version number from releases page
    agent_version=`echo "$agent_releases_page" | grep -ioh "/download\/v\d.*\/" -m1 | grep -ioh "\d.\d*.\d"`
    
    # compose the download url based on the version provided
    agent_download_url="https://vstsagentpackage.azureedge.net/agent/$agent_version/vsts-agent-linux-x64-$agent_version.tar.gz"

    # if download page is not valid
    if ! wget -q --method=HEAD $agent_download_url;
    then
        # assign version number manually
        agent_version="2.204.0"

        # recompose the download url based on the version provided
        agent_download_url="https://vstsagentpackage.azureedge.net/agent/$agent_version/vsts-agent-linux-x64-$agent_version.tar.gz"
    fi

    # download the agent
    wget $agent_download_url

    mkdir myagent && cd myagent

    # extract the agent into parent dir '/home/ubuntu'
    tar zxvf ../vsts-agent-linux-x64-$agent_version.tar.gz
}

download_and_extract_agent

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