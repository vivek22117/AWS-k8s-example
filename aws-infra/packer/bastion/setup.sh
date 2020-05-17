#!/usr/bin/env bash

echo "Install AWS Cli & kubectl & eks & docker"
sudo yum update -y
curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
unzip  awscli-bundle.zip
sudo  ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws

curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.15.10/2020-02-22/bin/linux/amd64/kubectl
chmod +x kubectl
mv kubectl /usr/local/bin/kubectl


curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
mv /tmp/eksctl /usr/local/bin
yum install docker -y
systemctl enable docker
systemctl start docker
usermod -aG docker ec2-user

echo "Install Telegraf"
wget https://dl.influxdata.com/telegraf/releases/telegraf-1.6.0-1.x86_64.rpm -O /tmp/telegraf.rpm
yum localinstall -y /tmp/telegraf.rpm
rm /tmp/telegraf.rpm
chkconfig telegraf on
mv /tmp/telegraf.conf /etc/telegraf/telegraf.conf
service telegraf start


echo "Install SSM-Agent"
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent


echo "Install NodeExporter"
cd /tmp
wget https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-amd64.tar.gz
tar -xf node_exporter-0.18.1.linux-amd64.tar.gz
sudo mv node_exporter-0.18.1.linux-amd64/node_exporter /usr/local/bin/
sudo useradd -rs /bin/false node_exporter
chown node_exporter:node_exporter /usr/local/bin/node_exporter
rm -rf /tmp/node_exporter-0.18.1.linux-amd64*

sudo cat << EOF > /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter

echo "SUCCESS! Installation succeeded!"
