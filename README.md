# pentaho

#### Table of Contents

1. [Description](#description)
1. [Setup](#setup)
    * [What pentaho affects](#what-pentaho-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with pentaho](#beginning-with-pentaho)
      * [Customize deploy options](#customize-deploy-options)
1. [Usage](#usage)
    * [Sample](#sample)
1. [Reference](#reference)
1. [Limitations](#limitations)
1. [Contribute](#contribute)

## Description

A puppet module that allows us to install and configure the Pentaho server leveraging in files as templates and a hierarchical schema of tokens.

Any file can be deployed and/or any configuration can be done underneath the **PENTAHO_HOME** folder.

This module is not designed to install and/or configure databases.

## Setup

### What Pentaho affects

* Creates a new user.
* Creates a new group.
* Creates a new home directory under the /home.

### Setup Requirements

Any database dependencies MUST be resolved in advance.

### Beginning with pentaho

To have the module with the default pameters, include the class `pentaho`:

`include '::pentaho'`.

When you declare this class with the default options, the module:

 - Install a **CE** distribution
 - Install the **7.1.0** version
 - Copy the Pentaho software from **puppet:///modules/pentaho/software/pentaho-server-ce-7.1.0.0-12.zip**
 - Create the user **pentaho**
 - Create the group **pentaho**
 - Create the home directory **/home/pentaho**
 - Create a backup folder from the previous deploy
 - Use the directory **/tmp/pentaho_template** as a temporary space

#### Customize deploy options

To change the default options, declare the class `pentaho` setting the new values for the parameters:

```puppet
class { '::pentaho':
  backup => false,
  source => 'puppet:///modules/pentaho/software/pentaho-server-ce-7.0.0.zip',
  version => '7.0.0'
}
```

## Usage

### Sample

Check out the [sample](https://github.com/kleysonr/puppet-pentaho/tree/sample_ce_7.1.0).

-- TODO --
This section is where you describe how to customize, configure, and do the
fancy stuff with your module here. It's especially helpful if you include usage
examples and code samples for doing things with your module.

## Reference

#### Public classes

* `pentaho`: Installs and configures Pentaho

#### Private classes
* `pentaho::params`: Manages module parameters.
* `pentaho::setup`: Validates and sets which distribution to install.
* `pentaho::ce`: Starts the install for Pentaho CE. 
* `pentaho::deploy`: Manages the backup and download of the Pentaho software. 
* `pentaho::system`: Manages the creation of the user/group in the OS. 
* `pentaho::templates`: Orchestrates the downloads of the templates and tokens replacements. 
* `pentaho::templates::fetchtemplates`: Downloads the files and templates to be used. 
* `pentaho::templates::applytokens`: Replaces the tokens on the template files. 
* `pentaho::templates::applytemplates`: Update the Pentaho with the new files.

### Parameters

`dist` Default value: **'ce'**
The distribution to be installed. The options can be **ce** or **ee**.
*NOTE: ee not implemented yet.*

`version` Default value: **'7.1.0'**
Pentaho version to be installed.

`source` Default value: **'puppet:///modules/pentaho/software/pentaho-server-ce-7.1.0.0-12.zip'**
Path for the Pentaho software. The .zip file must be stored in the puppet-server under the **/etc/puppetlabs/code/environments/production/modules/pentaho/files/software** directory.

`user` Default value: **'pentaho'**
User name.

`group`Default value: **'pentaho'**
Group name.

`home` Default value: **'/opt/pentaho'**
User home folder. The Pentaho software will be installed in this folder.

`backup` Default value: **true**
Rename the older Pentaho folder appending a timestamp, otherwise, delete the directory.

`tmptemplatedir` Default value: **'/tmp/pentaho_template'**
A temporary directory used by the module.

## Limitations

This module has been tested only on:

 - Puppet 4.10
 - Ubuntu 16.04

## Contribute

Help to develop and improve the module. 