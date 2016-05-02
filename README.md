# WSO2 Puppet Modules

This repository contains Puppet modules for installing and configuring WSO2 products on various environments. Each puppet module is designed to support multiple versions of a WSO2 product.

Configuration data is managed using [Hiera] (http://docs.puppetlabs.com/hiera/1/). Hiera provides a mechanism for separating configuration data from Puppet scripts and managing them in a separate set of YAML files in a hierarchical manner.

## Supported Operating Systems

- Debian 6 or higher
- Ubuntu 12.04 or higher

## Supported Puppet Versions

- Puppet 2.7, 3 or newer

## How to Contribute
1. Fork
2. Follow the steps mentioned in the [wiki](https://github.com/wso2/puppet-modules/wiki) to setup a development environment and update/create new puppet modules
3. Send a PR
