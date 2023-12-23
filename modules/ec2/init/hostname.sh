#!/bin/bash

INSTANCEID=`curl -s http://169.254.169.254/latest/meta-data/instance-id`
INSTANCEIP=`curl -s http://169.254.169.254/latest/meta-data/local-ipv4`
AWSREGION=`curl -s 169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/.$//'`

#Create aws dir for root user
echo "export NICKNAME=$" > /etc/profile.d/prompt.sh
mkdir -p ~/.aws

#Create config file with minimum required content for aws cli to work
cat << EOF > ~/.aws/config
[default]
region = $AWSREGION
EOF

#Get Name tag value
INSTANCENAME=`aws ec2 describe-tags --filters "Name=resource-id,Values=$INSTANCEID" --output=text | grep Name | awk '{print $5}'`

#Make sure we got a name, fail if we dont.
if [ -z "$INSTANCENAME" ]
        then
        echo "I have no name!"
        exit 1
fi

echo "127.0.0.1 $INSTANCENAME localhost.localdomain localhost" > /etc/hosts
echo "perserve_hostname:true" >> /etc/cloud/cloud.cfg

echo "$INSTANCENAME" > /etc/hostname
echo "HOSTNAME=$INSTANCENAME" >> /etc/sysconfig/network
hostnamectl set-hostname "$INSTANCENAME"