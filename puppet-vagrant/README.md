# Puppet Vagrant

A Vagrant setup for setting up WSO2 servers using puppet and hiera.

## How to use

1. Clone WSO2 puppet modules git repository and consider this path in local machine as `PUPPET_HOME`:

    ````
    git clone https://github.com/wso2/puppet-modules.git
    ````
3. Update `PUPPET_HOME` path in `config.yaml` file.
4. Download and copy Oracle JDK `1.7` distribution to the following path:

    ````
    <PUPPET_HOME>/modules/wso2base/files/jdk-7u80-linux-x64.tar.gz
    ````
5. Download and copy required WSO2 product distributions to each files folder:

    ````
    <PUPPET_HOME>/modules/wso2esb/files
    <PUPPET_HOME>/modules/wso2am/files
    <PUPPET_HOME>/modules/wso2as/files
    ````
6. Update `config.yaml` with required products and VM configurations (cpu, memory).
7. Update `<PUPPET_HOME>/hieradata` with required product configurations.
8. Execute the following command to start the VMs:

    ````
    vagrant up
    ````
For more information refer the [wiki](https://github.com/wso2/puppet-modules/wiki) page.
