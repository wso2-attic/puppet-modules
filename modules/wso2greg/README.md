# WSO2 GREG Puppet Module

This repository contains generic puppet module for installing and configuring WSO2 GREG on various environments. It
supports multiple versions of WSO2 GREG. Configuration data is managed using [Hiera] (http://docs.puppetlabs.com/hiera/1/). 
Hiera provides a mechanism for separating configuration data from Puppet scripts and managing them in
 a separate set of YAML files in a hierarchical manner.

## Supported Operating Systems

- Debian 6 or higher
- Ubuntu 12.04 or higher

## Supported Puppet Versions

- Puppet 2.7, 3 or newer

## How to Contribute
Follow the steps mentioned in the [wiki](https://github.com/wso2/puppet-modules/wiki) to setup a development
environment and update/create new puppet modules.

## Hiera data configuration to start the product with default profile
With disabling the below proxy configuration in default.yaml file, product can be started in default profile with
adding product pack to files directory.

```yaml
wso2::ports:
  proxyPort :
    http: 32001
    https: 32002
```

## Hiera data configuration to start the product with clustering
Do the below changes to default hiera yaml files to start the server in distributed setup. For more details refer the
[WSO2 GREG 5.0.0](https://docs.wso2.com/display/CLUSTER44x/Clustering+Governance+Registry+5.0.0) and [WSO2 GREG 4.6
.0](https://docs.wso2.com/display/CLUSTER420/Clustering+Governance+Registry) clustering guide.

1. Enable clustering

   Ex:
    ```yaml
    wso2::clustering :
        enabled : true
        local_member_host : 192.168.100.13
        local_member_port : 4000
        membership_scheme : wka
        sub_domain : mgt
        wka :
           members :
             -
               hostname : 192.168.100.13
               port : 4000
             -
               hostname : 192.168.100.23
               port : 4000
    ```

2. Add external databases to master datasources

   Ex:
    ```yaml
    wso2::master_datasources :
     wso2_config_db:
       name : WSO2_CONFIG_DB
       description : The datasource used for config registry
       driver_class_name : org.h2.Driver
       url : jdbc:h2:repository/database/WSO2_CONFIG_DB;DB_CLOSE_ON_EXIT=FALSE;LOCK_TIMEOUT=60000
       username : "%{hiera('wso2::datasources::common::username')}"
       password : "%{hiera('wso2::datasources::common::password')}"
       jndi_config : jdbc/WSO2_CONFIG_DB
       max_active: "%{hiera('wso2::datasources::common::max_active')}"
       max_wait: "%{hiera('wso2::datasources::common::max_wait')}"
       test_on_borrow: "%{hiera('wso2::datasources::common::test_on_borrow')}"
       validation_query: "%{hiera('wso2::datasources::h2::validation_query')}"
       validation_interval: "%{hiera('wso2::datasources::common::validation_interval')}"

    ```

3. Add registry mounting

   Ex:
    ```yaml
    wso2_config_db :
      path : /_system/config
      target_path : /_system/config/
      read_only : false
      registry_root : /
      enable_cache : true
    wso2_gov_db :
      path : /_system/governance
      target_path : /_system/governance
      read_only : false
      registry_root : /
      enable_cache : true
    ```

4. Add deployment synchronization

    Ex:
    ```yaml
    wso2::dep_sync :
        enabled : true
        auto_checkout : true
        auto_commit : true
        repository_type : svn
        svn :
           url : http://svnrepo.example.com/repos/
           user : username
           password : password
           append_tenant_id: true
    ```

## Hiera data configuration to apply secure vault
WSO2 GREG needs to have sensitive data such as passwords, keys in configuration files and put them as plain text in
configuration files will lead to security attacks. WSO2 carbon secure vault implementation prevents this by using
secret aliases in configuration files which are mapped to cipher tool encrypted secrets. Read more details on WSO2
carbon secure vault implementation [here] (https://docs.wso2.com/display/Carbon444/Securing+Passwords+in+Configuration+Files).

Note that secure_vault can be applied to carbon kernel 4.4.x based products and 4.2.0 products which has carbon
kernel patch-0009. It's not supported for WSO2 GREG 4.6.0.

Do the below changes in hiera file.

1. Enable secure vault

    ```yaml
    wso2::enable_secure_vault : true
    ```

2. Add secure vault configurations as below

    ```yaml
    wso2::secure_vault_configs :
    <secure_vault_config_name>:
        secret_alias: <secret_alias>
        secret_alias_value: <secret_alias_value>
        password: <password>
    ```

    For GREG 5.1.0 which is based on carbon kernel 4.4.x

    Ex:

    ```yaml
    wso2::secure_vault_configs :
      key_store_password :
        secret_alias: Carbon.Security.KeyStore.Password
        secret_alias_value: repository/conf/carbon.xml//Server/Security/KeyStore/Password,false
        password: wso2carbon
    ```

3. Add below templates to template_list

    ```yaml
    wso2::template_list:
      - repository/conf/security/cipher-text.properties
      - repository/conf/security/cipher-tool.properties
      - bin/ciphertool.sh
      - password-tmp
    ```