# pentaho

#### Table of Contents

1. [Description](#description)
1. [Setup](#setup)
    * [What pentaho affects](#what-pentaho-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with pentaho](#beginning-with-pentaho)
       * [Customize deploy options](#customize-deploy-options)
1. [Usage](#usage)
    * [Copying and 'templating' files](#copying-and-templating-files)
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

The module was designed to be flexible enough to copy files and do lookups/replaces of tokens based on metadata and hierarchical priorities.

The following metadata are used:

 - `pentaho::dist` - Pentaho distribution being installed (ce/ee).
 - `pentaho::version` - Pentaho version being installed.
 - `fqdn` - fully qualified domain name for the Pentaho server.
 - `pentaho_env` - A variable, on the Pentaho server, that represent the environment being installed, such as DEV / QA / PROD.

The `pentaho::dist` and `pentaho::version` are defined during the import of the `pentaho` classe or assuming their default values.

The `fqdn` is the hostname configured on the Pentaho server itself.

If used, the `pentaho_env` must be defined on the Pentaho server, exporting a variable called **FACTER_PENTAHO_ENV**.
> export FACTER_PENTAHO_ENV=dev

### Copying and 'templating' files

Files can be copied from the puppet-server to every pentaho server (puppet-agent) to be used in the build process of the new installation package.

Every text file can also hold **tokens** to be replaced for the appropriate value during the build process, that will scan a set of definitions files to lookup the more specific value for each token. This feature leverage on the Hiera and templates based on ERB.

The files must be placed in a properly structure under the **/etc/puppetlabs/code/environments/production/modules/pentaho/files/fs** folder.

Below the order that the files are copied, starting by the more generics and ending by the more specifics.
```
fs/files
fs/${pentaho::dist}/files
fs/${pentaho::dist}/${pentaho::version}/files
fs/${pentaho::dist}/${pentaho::version}/${fqdn}/files
fs/${pentaho::dist}/${pentaho::version}/${pentaho_env}/files
fs/${pentaho::dist}/${pentaho::version}/${fqdn}/${pentaho_env}/files
```
For instance:

 1. fs/**ce**/**7.1.0**/files/**pentaho-server/start-pentaho.sh**
 2. fs/**ce**/**7.1.0**/files/**pentaho-server/tomcat/webapps/pentaho/META-INF/context.xml**
 3. fs/files/**pentaho-server/tomca/lib/postgresql-42.1.4.jar**
 4. fs/files/**README-PUPPET.txt**

Each installation of Pentaho **CE 7.1.0** the files (1) and (2) will be copied and files the (3) and (4) will be copied for all installations.

To tokenise the text files use the code `<%= scope().call_function('lookup',['pentaho::token-name']) %>`.

The **pentaho-server/tomcat/webapps/pentaho/META-INF/context.xml** could be tokenised as the follow:

``` xml
<Resource name="jdbc/Quartz" auth="Container" 
    type="javax.sql.DataSource"
    factory="org.apache.commons.dbcp.BasicDataSourceFactory" 
    maxTotal="20" maxIdle="5"
    maxWaitMillis="10000"
    username="<%= scope().call_function('lookup',['pentaho::quartz-jdbc-username']) %>"
    password="<%= scope().call_function('lookup',['pentaho::quartz-jdbc-password']) %>"
    url="<%= scope().call_function('lookup',['pentaho::quartz-jdbc-url']) %>"
    driverClassName="<%= scope().call_function('lookup',['pentaho::quartz-jdbc-driver']) %>"
    validationQuery="<%= scope().call_function('lookup',['pentaho::quartz-jdbc-query']) %>"
/>
```
During the building process, the tokens for the **username**, **password**, **url**, **driverClassName** and **validationQuery** will be replaced by values relative to the server being installed.

### Tokens definition files

The Hiera scan the definition files on the following order and the .yaml files must be stored under the **/etc/puppetlabs/code/environments/production/modules/pentaho/data/fs** folder.

```
fs/%{pentaho::dist}/%{pentaho::version}/%{fqdn}/%{::pentaho_env}.yaml
fs/%{pentaho::dist}/%{pentaho::version}/%{::pentaho_env}.yaml
fs/%{pentaho::dist}/%{pentaho::version}/%{fqdn}.yaml
fs/%{pentaho::dist}/%{pentaho::version}.yaml
fs/%{pentaho::dist}.yaml
fs/general.yaml
```
For the example above, we would have the following .yaml files:

 - For all Pentaho **CE 7.1.0** without the **PENTAHO_ENV** variable
```
fs/ce/7.1.0.yaml

---
pentaho::quartz-jdbc-url: jdbc:hsqldb:hsql://localhost/quartz
pentaho::quartz-jdbc-driver: org.hsqldb.jdbcDriver
pentaho::quartz-jdbc-username: pentaho_user
pentaho::quartz-jdbc-password: password
pentaho::quartz-jdbc-query: select count(*) from INFORMATION_SCHEMA.SYSTEM_SEQUENCES
```
 - For a Pentaho server **CE 7.1.0 / DEV**
```
fs/ce/7.1.0/dev.yaml

---
pentaho::quartz-jdbc-url: jdbc:postgresql://dev-db.mycompany.com:5432/quartz
pentaho::quartz-jdbc-driver: org.postgresql.Driver
pentaho::quartz-jdbc-username: pentaho_user
pentaho::quartz-jdbc-password: password
pentaho::quartz-jdbc-query: select 1
```
 - For a Pentaho server **CE 7.1.0 / PROD**
```
fs/ce/7.1.0/prod.yaml

---
pentaho::quartz-jdbc-url: jdbc:postgresql://prod-db.mycompany.com:5432/quartz
pentaho::quartz-jdbc-driver: org.postgresql.Driver
pentaho::quartz-jdbc-username: pentaho_user
pentaho::quartz-jdbc-password: password
pentaho::quartz-jdbc-query: select 1
```

### Sample

Check out the [sample](https://github.com/kleysonr/puppet-pentaho/tree/sample_ce_7.1.0).

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