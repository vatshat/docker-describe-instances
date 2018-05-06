#!/bin/sh

# https://docs.aws.amazon.com/cloud9/latest/user-guide/sample-python.html

yum -y update
yum install -y epel-release
yum install -y docker
curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
yum install -y git

cd /home/ec2-user/
git clone https://github.com/vatshat/bsc-repo.git
chown -R ec2-user:ec2-user bsc-repo

cd /home/ec2-user/bsc-repo/docker-describe-instances

docker-compose build
docker-compose -f docker-compose.local.yml up -d --force-recreate
docker-compose up -d --force-recreate
