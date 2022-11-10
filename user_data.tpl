#!/bin/bash
set -x
sudo yum update -y
sudo yum install wget -y
sudo yum install unzip -y
sudo yum install mod_ssl -y

#Apache install
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd

#PHP8 install
sudo dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
sudo dnf install -y https://rpms.remirepo.net/enterprise/remi-release-8.rpm
sudo dnf module list PHP -y
#sudo dnf install php php-cli php-common -y
#sudo dnf module reset php

sudo dnf module enable php:remi-8.1 -y
sudo dnf install php -y

#TLS certificate install
cd /home/ec2-user/
mkdir /home/ec2-user/certificate
cp ${ssl_certificate}* /home/ec2-user/certificate/
cd /home/ec2-user/certificate
sudo unzip ${ssl_certificate}.zip
rm -rf ${ssl_certificate}.zip
mv ${ssl_certificate}* ${ssl_certificate}
sudo  cp /home/ec2-user/certificate/${ssl_certificate}/${ssl_certificate}.key /etc/pki/tls/private/
sudo cp /home/ec2-user/certificate/${ssl_certificate}/${ssl_certificate}.crt /etc/pki/tls/certs/
sudo sed -i "85s/localhost.crt/${ssl_certificate}.crt/1" /etc/httpd/conf.d/ssl.conf
sudo sed -i "93s/localhost.key/${ssl_certificate}.key/1" /etc/httpd/conf.d/ssl.conf
sudo systemctl restart httpd

#ADO agent install
sudo adduser -r -s /bin/nologin adoagent
sudo mkdir -p /agent/myagent
sudo chown -R adoagent:adoagent /agent
sudo -H -u adoagent bash
cd /agent/myagent/ 
wget https://vstsagentpackage.azureedge.net/agent/2.211.1/vsts-agent-linux-x64-2.211.1.tar.gz
tar -xf vsts-agent-linux-x64-2.211.1.tar.gz
sudo chown -R adoagent:adoagent /agent
exit & cd /agent/myagent/ & sudo  ./bin/installdependencies.sh
sudo -H -u adoagent bash
cd /agent/myagent/
#./config.sh --unattended --url https://dev.azure.com/tazioonline --auth pat --token wrnhifqucsaajtda7dexgpmgc2dlzjwnlkpj6bic3fnumhnne6hq --pool "Heidrick Test Pool" --agent test-insights-websrv-1 --acceptTeeEula --work ./_work --runAsService

./config.sh --unattended --url ${agent_url} --auth pat --token ${agent_token} --pool "${agent_pool}" --agent ${agent_hostname} --acceptTeeEula --work ./_work --runAsService




