#!/usr/bin/env bash


echo "Install Java8"
sudo yum remove -y java
sudo yum install -y java-1.8.0-openjdk


echo "Install AWS Cli & kubectl & eks & docker"
sudo yum update -y
sudo yum install wget unzip -y
sleep 5

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo  ./aws/install -i /usr/local/aws-cli -b /usr/local/bin

curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.17.9/2020-08-04/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv kubectl /usr/local/bin/kubectl


curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
mv /tmp/eksctl /usr/local/bin

yum install docker -y
systemctl enable docker
systemctl start docker
usermod -aG docker ec2-user


echo "Install SSM-Agent"
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent


sleep 10

echo "SUCCESS! Installation succeeded!"
