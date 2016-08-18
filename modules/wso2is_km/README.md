# WSO2 Identity Server Key Manager Puppet Module

This repository contains the Puppet Module for installing and configuring WSO2 Identity Server Key Manager on various environments. Configuration data is managed using [Hiera](http://docs.puppetlabs.com/hiera/1/). Hiera provides a mechanism for separating configuration data from Puppet scripts and managing them in a separate set of YAML files in a hierarchical manner.

## Supported Operating Systems

- Debian 6 or higher
- Ubuntu 12.04 or higher

## Supported Puppet Versions

- Puppet 2.7, 3 or newer

## How to Contribute
Follow the steps mentioned in the [wiki](https://github.com/wso2/puppet-modules/wiki) to setup a development environment and update/create new puppet modules.

## Packs to be Copied

Copy the following files to their corresponding locations.

1. WSO2 Identity Server 5.1.0 distribution which has API Key Manager feature installed on it to `<PUPPET_HOME>/modules/wso2is_km/files`. If you are using the pre-packaged [WSO2 Identity Server 5.1.0 Key Manager pack](http://product-dist.wso2.com/downloads/api-manager/1.10.0/identity-server/wso2is-5.1.0.zip) with Secure Vault enabled, extract the product zip file, remove `authenticationendpoint` folder in `CARBON_HOME/repository/deployment/server/webapps`, compress the pack and then copy it to `<PUPPET_HOME>/modules/wso2is_km/files`. For more details, refer step 4 under `Running  WSO2 Identity Server Key Manager with Secure Vault`.
2. JDK 1.7_80 distribution to `<PUPPET_HOME>/modules/wso2base/files`

## Running  WSO2 Identity Server Key Manager in the `default` profile
No changes to Hiera data are required to run the `default` profile. Copy the above mentioned files to their corresponding locations and apply the Puppet Modules.

## Running  WSO2 Identity Server Key Manager with clustering in specific profiles
When running WSO2 Identity Server Key Manager as Key Manager node with WSO2 API Manager distributed setup, do the following changes:
- WSO2 API Manager store, publisher and gateway nodes have to be configured with WSO2 Identity Server Key Manager as the key manager node.
    Ex:
    ```yaml
    wso2::apim_keymanager:
      host: wso2am-api-key-manager
      port: 9443
      username: admin
      password: admin
    ```
       
- WSO2 Identity Server Key Manager has to be configured with WSO2 API Manager gateway nodes
    Ex:
    ```yaml
    wso2::apim_gateway:
      host: wso2am-gateway-manager
      port: 9443
      api_endpoint_host: wso2am-gateway-worker
      api_endpoint_port: 8280
      secure_api_endpoint_port: 8243
      api_token_revoke_endpoint_port: 8280
      secure_api_token_revoke_endpoint_port: 8243
      username: admin
      password: admin
    ```
    
No other changes to Hiera data are required to run the distributed deployment of WSO2 Identity Server Key Manager, other than pointing to the correct resources such as the deployment synchronization and remote DB instances. For more details refer the [ WSO2 Identity Server Key Manager ](https://docs.wso2.com/display/CLUSTER44x/Configuring+the+Pre-Packaged+Identity+Server+5.1.0+with+API+Manager+1.10.0) clustering guides.

1. If the Clustering Membership Scheme is `WKA`, add the Well Known Address list.

   Ex:
    ```yaml
    wso2::clustering:
      enabled: true
      local_member_host: "%{::ipaddress}"
      local_member_port: 4000
      domain: km.is.wso2.domain
      sub_domain: worker
    # WKA membership scheme
      membership_scheme: wka
      wka:
        members:
          -
            hostname: 192.168.100.141
            port: 4000
    ```

2. Add external databases to master datasources

   Ex:
    ```yaml
    wso2::master_datasources:
      wso2_config_db:
        name: WSO2_CONFIG_DB
        description: The datasource used for config registry
        driver_class_name: "%{hiera('wso2::datasources::mysql::driver_class_name')}"
        url: jdbc:mysql://mysql-is-db:3306/IS_DB?autoReconnect=true
        username: "%{hiera('wso2::datasources::common::username')}"
        password: "%{hiera('wso2::datasources::common::password')}"
        jndi_config: jdbc/WSO2_CONFIG_DB
        max_active: "%{hiera('wso2::datasources::common::max_active')}"
        max_wait: "%{hiera('wso2::datasources::common::max_wait')}"
        test_on_borrow: "%{hiera('wso2::datasources::common::test_on_borrow')}"
        default_auto_commit: "%{hiera('wso2::datasources::common::default_auto_commit')}"
        validation_query: "%{hiera('wso2::datasources::mysql::validation_query')}"
        validation_interval: "%{hiera('wso2::datasources::common::validation_interval')}"

    ```

3. Configure registry mounting

   Ex:
    ```yaml
    wso2_config_db:
      path: /_system/config
      target_path: /_system/config/is-km
      read_only: false
      registry_root: /
      enable_cache: true

    wso2_gov_db:
      path: /_system/governance
      target_path: /_system/governance
      read_only: false
      registry_root: /
      enable_cache: true
    ```

4. Configure deployment synchronization

    Ex:
    ```yaml
    wso2::dep_sync:
        enabled: true
        auto_checkout: true
        auto_commit: true
        repository_type: svn
        svn:
           url: http://svnrepo.example.com/repos/
           user: username
           password: password
           append_tenant_id: true
    ```

## Running  WSO2 Identity Server Key Manager with Secure Vault
WSO2 Carbon products may contain sensitive information such as passwords in configuration files. [WSO2 Secure Vault](https://docs.wso2.com/display/Carbon444/Securing+Passwords+in+Configuration+Files) provides a solution for securing such information.

Uncomment and modify the below changes in Hiera file to apply Secure Vault.

1. Enable Secure Vault

    ```yaml
    wso2::enable_secure_vault: true
    ```

2. Add Secure Vault configurations as below

    ```yaml
    wso2::secure_vault_configs:
      <secure_vault_config_name>:
        secret_alias: <secret_alias>
        secret_alias_value: <secret_alias_value>
        password: <password>
    ```

    Ex:
    ```yaml
    wso2::secure_vault_configs:
      key_store_password:
        secret_alias: Carbon.Security.KeyStore.Password
        secret_alias_value: repository/conf/carbon.xml//Server/Security/KeyStore/Password,false
        password: wso2carbon
    ```

3. Add Cipher Tool configuration file templates to `template_list`

    ```yaml
    wso2::template_list:
      - repository/conf/security/cipher-text.properties
      - repository/conf/security/cipher-tool.properties
      - bin/ciphertool.sh
    ```

    Please add the `password-tmp` template also to `template_list` if the `vm_type` is not `docker` when you are running the server in `default` platform.

4. Encrypting KeyStore and TrustStore passwords in `EndpointConfig.properties` using Cipher Tool fails to deploy `authenticationendpoint` web app. This is due to a class loading issue as reported in [JIRA: IDENTITY-4276](https://wso2.org/jira/browse/IDENTITY-4276). To fix this follow the below steps:
  - Get the `authenticationendpoint.war` in CARBON_HOME/repository/deployment/server/webapps folder, remove the `org.wso2.securevault-1.0.0-wso2v2.jar` from webapp's WEB_INF/lib folder and add it to `files/configs/repository/deployment/server` folder
  - Add the `authenticationendpoint.war` file path to `file_list` in default.yaml file
   
    ```yaml
    wso2::file_list:
      - repository/deployment/server/webapps/authenticationendpoint.war
    ```

## Running  WSO2 Identity Server Key Manager on Kubernetes
WSO2 Puppet Module ships Hiera data required to deploy  WSO2 Identity Server Key Manager on Kubernetes. For more information refer to the documentation on [deploying WSO2 products on Kubernetes using WSO2 Puppet Modules](https://docs.wso2.com/display/PM210/Deploying+WSO2+Products+on+Kubernetes+Using+WSO2+Puppet+Modules).
