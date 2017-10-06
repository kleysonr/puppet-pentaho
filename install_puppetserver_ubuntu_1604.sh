#!/bin/bash

###################################
#                                 #
# Script MUST be executed as root #
#                                 #
###################################

# Install tools 
apt-get update && \
apt-get install -y net-tools lsb-release vim wget iputils-ping ca-certificates locales tzdata ntp
 
# Set timezone
echo "America/Sao_Paulo" > /etc/timezone && \
dpkg-reconfigure --frontend noninteractive tzdata
 
# Set locale for all system
locale-gen en_US en_US.UTF-8 && \
update-locale LANG="en_US.UTF-8" \
              LANGUAGE="en_US:en:pt" \
              LC_NUMERIC="en_US.UTF-8" \
              LC_TIME="en_US.UTF-8" \
              LC_MONETARY="en_US.UTF-8" \
              LC_PAPER="en_US.UTF-8" \
              LC_NAME="en_US.UTF-8" \
              LC_ADDRESS="en_US.UTF-8" \
              LC_TELEPHONE="en_US.UTF-8" \
              LC_MEASUREMENT="en_US.UTF-8" \
              LC_IDENTIFICATION="en_US.UTF-8" && \
dpkg-reconfigure --frontend noninteractive locales

# Include the hostname (short name) to the hosts
cp /etc/hosts ~/hosts.new
eval "sed -i -e 's/"$(hostname -f)"$/"$(hostname -f) $(hostname -s)"/' ~/hosts.new"
cp -f ~/hosts.new /etc/hosts
rm ~/hosts.new

# Update the /etc/hosts to resolve the puppet name
echo
read -e -p "> Enter IP address for the puppet server: " ipaddress

echo
echo "Configuring /etc/hosts ..."

echo "$ipaddress puppet.$(hostname -d) puppet" >> /etc/hosts

# Update the $PATH
echo "export PATH=$PATH:/opt/puppetlabs/puppet/bin" >> /etc/profile
export PATH=$PATH:/opt/puppetlabs/puppet/bin

# Install puppet-server (for Ubuntu)
wget https://apt.puppetlabs.com/puppetlabs-release-pc1-$(lsb_release -c -s).deb
dpkg -i puppetlabs-release-pc1-$(lsb_release -c -s).deb
rm puppetlabs-release-pc1-$(lsb_release -c -s).deb

apt-get update && apt-get install -y puppetserver

# Start puppet-server
service puppetserver start 

# Install Pentaho puppet module
puppet module install kleysonr-pentaho