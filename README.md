# WSO2 Puppet Modules

This repository contains Puppet modules for installing and configuring WSO2 products on various environments. Each puppet module is designed to support multiple versions of a WSO2 product.

Configuration data is managed using [Hiera] (http://docs.puppetlabs.com/hiera/1/). Hiera provides a mechanism for separating configuration data from Puppet scripts and managing them in a separate set of YAML files in a hierarchical manner.

## Supported Operating Systems

- Debian 6 or higher
- Ubuntu 12.04 or higher

## Supported Puppet Versions

- Puppet 2.7, 3 or newer

## Getting Started

Refer to the product specific README guides to get started with WSO2 Puppet Modules.

1. [WSO2 API Manager](https://github.com/wso2/puppet-modules/tree/master/modules/wso2am)
2. [WSO2 Application Server](https://github.com/wso2/puppet-modules/tree/master/modules/wso2as)
3. [WSO2 Business Process Server](https://github.com/wso2/puppet-modules/tree/master/modules/wso2bps)
4. [WSO2 Business Rules Server](https://github.com/wso2/puppet-modules/tree/master/modules/wso2brs)
5. [WSO2 Complex Event Processor](https://github.com/wso2/puppet-modules/tree/master/modules/wso2cep)
6. [WSO2 Data Analytics Server](https://github.com/wso2/puppet-modules/tree/master/modules/wso2das)
7. [WSO2 Data Services Server](https://github.com/wso2/puppet-modules/tree/master/modules/wso2dss)
8. [WSO2 Enterprise Store](https://github.com/wso2/puppet-modules/tree/master/modules/wso2es)
9. [WSO2 Enterprise Service Bus](https://github.com/wso2/puppet-modules/tree/master/modules/wso2esb)
10. [WSO2 Governance Registry](https://github.com/wso2/puppet-modules/tree/master/modules/wso2greg)
11. [WSO2 Governance Registry Publisher Store](https://github.com/wso2/puppet-modules/tree/master/modules/wso2greg_pubstore)
12. [WSO2 Identity Server](https://github.com/wso2/puppet-modules/tree/master/modules/wso2is)
13. [WSO2 Identity Server Key Manager](https://github.com/wso2/puppet-modules/tree/master/modules/wso2is_km)
14. [WSO2 Message Broker](https://github.com/wso2/puppet-modules/tree/master/modules/wso2mb)

## How to Contribute
1. Fork
2. Follow the steps mentioned in the [wiki](https://github.com/wso2/puppet-modules/wiki) to setup a development environment and update/create new puppet modules
3. Send a PR
