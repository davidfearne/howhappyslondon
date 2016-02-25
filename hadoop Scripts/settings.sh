#!/bin/bash

##############################################################
#
# Installing Hadoop HDP 2.2 base requirements for node
# Target OS Cent OS 6.5
# Author: David Fearne
# GitHub: https://github.com/davidfearne/howhappyslondon
#
##############################################################



read -p "whats the hostname of this server hadoopnodexx.demonet.local?" aa
read -p "Whats the ipaddress of this server?" bb

echo "Changing the hostname from $(hostname) to $aa ..."

echo "$aa" >> /etc/hostname

echo ""
echo "Assigning the Static IP ..."

cat <<EOF > /etc/sysconfig/network
NETWORKING=yes
HOSTNAME=$aa
EOF

cat <<EOF > /etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE=eth0
BOOTPROTO=static
IPADDR=$bb
NETMASK=255.255.255.0
GATEWAY=10.1.16.1
ONBOOT=yes
EOF

echo "Changing the dns ..."
echo "nameserver 8.8.8.8" >> /etc/resolv.conf

echo "Adding entries to hostname to the /etc/hosts file .."
echo "10.1.16.20	hadoopnode1.demonet.local
10.1.16.21      hadoopnode2.demonet.local
10.1.16.22      hadoopnode3.demonet.local
10.1.16.23      hadoopnode4.demonet.local
10.1.16.24      hadoopnode5.demonet.local
10.1.16.25      hadoopnode6.demonet.local
10.1.16.26      hadoopnode7.demonet.local
10.1.16.27      hadoopnode8.demonet.local
10.1.16.28      hadoopnode9.demonet.local
10.1.16.29      hadoopnode10.demonet.local
10.1.16.30      hadoopnode11.demonet.local
10.1.16.31      hadoopnode12.demonet.local
10.1.16.32      hadoopnode13.demonet.local
10.1.16.33      hadoopnode14.demonet.local
10.1.16.34      hadoopnode15.demonet.local
10.1.16.35      hadoopnode16.demonet.local
10.1.16.36      hadoopnode17.demonet.local
10.1.16.37      hadoopnode18.demonet.local
10.1.16.38      hadoopnode19.demonet.local
10.1.16.39      hadoopnode20.demonet.local" >> /etc/hosts

echo "Restarting the Network Service, Please connect it using the new IP Address if you are using ssh ..."
service network restart

echo "installing Open Java 1.8.0"
yum install -y java-1.7.0-openjdk-devel
echo export JAVA_HOME=/usr/lib/jvm/jre-1.7.0-openjdk.x86_64/bin/java >> /etc/profile
echo export PATH=$JAVA_HOME/bin:$PATH >> /etc/profile

yum upgrade -y openssl
yum install -y wget

echo "Disable firewall"
service iptables stop
chkconfig iptables off

reboot


