#!/bin/sh

# https://docs.aws.amazon.com/cloud9/latest/user-guide/sample-python.html

# install required packages
yum -y update
yum install -y epel-release
yum install -y docker
curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
yum install -y git
yum install -y jq
PATH=$PATH:/usr/local/bin

# download repo for the web application
cd /home/ec2-user/
git clone https://github.com/vatshat/bsc-repo.git
chown -R ec2-user:ec2-user bsc-repo

cd /home/ec2-user/bsc-repo/docker-describe-instances

# get the credentials from isntance role

# Alternative to using jq - https://michaelheap.com/extract-substring-values-jq
# instance_role=curl -s 169.254.169.254/latest/meta-data/iam/info | jq ".InstanceProfileArn" | sed -e 's/^"//' -e 's/"$//' | awk -F'/' '{print $2}'

# https://vsupalov.com/docker-arg-env-variable-guide/
# https://github.com/docker/compose/issues/2111#issuecomment-174571609

instance_role=$(curl -s http://169.254.169.254/latest/meta-data/iam/info | jq -r '. | map(.)[2] | split("/")[1]')
access_key_id=$(curl -s http://169.254.169.254/latest/meta-data/iam/security-credentials/"$instance_role"); access_key_id=$(jq --raw-output ".AccessKeyId" <<< $access_key_id)
secret_access_key=$(curl -s http://169.254.169.254/latest/meta-data/iam/security-credentials/"$instance_role"); secret_access_key=$(jq --raw-output ".SecretAccessKey" <<< $secret_access_key)
aws_default_region=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/.$//')

docker-compose build --build-arg access_key_id=$access_key_id --build-arg secret_access_key=$secret_access_key --build-arg region=$aws_default_region
docker-compose -f docker-compose.local.yml up -d --force-recreate
docker-compose up -d --force-recreate
