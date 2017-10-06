# Sample

#### Table of Contents

1. [Description](#description)
1. [Installing the Puppet servers](#installing-the-puppet-servers)
1. [Configuring the sample](#configuring-the-sample)
1. [Deploying the Pentaho server](#deploying-the-pentaho-server)
1. [Validation](#validation)

## Description

This sample shows how to use the Pentaho puppet module to deploy a Pentaho CE 7.1.0 for 3 different environments based on their configurations.

## Installing the Puppet servers

 - Install an Ubuntu 16.04 server to role as the puppet-master and configure the network properly.
 - As root, run the [install_puppetserver_ubuntu_1604.sh](https://raw.githubusercontent.com/kleysonr/puppet-pentaho/sample_ce_7.1.0/install_puppetserver_ubuntu_1604.sh) script to configure and install the puppet-server software.
 - Install an Ubuntu 16.04 server to role as the puppet-agent and configure the network properly.
 - As root, run the [install_puppetagent_ubuntu_1604.sh](https://raw.githubusercontent.com/kleysonr/puppet-pentaho/sample_ce_7.1.0/install_puppetagent_ubuntu_1604.sh) script to configure and install the puppet-agent software.

## Configuring the sample

On the puppet-server **(as root)**:

 - Clone or download the [sample-ce-7.1.0](https://github.com/kleysonr/puppet-pentaho/tree/sample_ce_7.1.0).
 - Recursively copy the **production** folder to **/etc/puppetlabs/code/environments/production**
>cp -R production/\* /etc/puppetlabs/code/environments/production

 - Download the [Pentaho CE 7.1.0.0-12](https://sourceforge.net/projects/pentaho/files/Business%20Intelligence%20Server/7.1/pentaho-server-ce-7.1.0.0-12.zip/download)
 - Copy the .zip file to **/etc/puppetlabs/code/environments/production/modules/pentaho/files/software**

## Deploying the Pentaho server

On the puppet-agent **(as root)**:

- Run the command to deploy the Pentaho server with the default configurations
>puppet agent --onetime --no-daemonize --version

- Export the **FACTER_PENTAHO_ENV** variable to deploy the Pentaho on the **DEV** environment, and re-run the command to deploy
>export FACTER_PENTAHO_ENV=dev
> 
>puppet agent --onetime --no-daemonize --version

- Export the **FACTER_PENTAHO_ENV** variable to deploy the Pentaho on the **PROD** environment, and re-run the command to deploy
>export FACTER_PENTAHO_ENV=prod
> 
>puppet agent --onetime --no-daemonize --version

## Validation

Compare the following files among all the executions to check the differences:
>/opt/pentaho/README-PUPPET.txt
> 
>/opt/pentaho/pentaho-server/start-pentaho.sh
> 
>/opt/pentaho/pentaho-server/tomcat/webapps/pentaho/META-INF/context.xml

And verify that the new JDBC driver for postgres was deployed to all the environments.
>/opt/pentaho/pentaho-server/tomcat/lib/postgres-42.1.4.jar
