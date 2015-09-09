# wso2base

#### Table of Contents

1. [Module Description - What the module does and why it is useful](#module-description)
2. [Backwards compatibility information](#backwards-compatibility)
3. [Setup - The basics of getting started with wso2base module](#setup)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Development - Guide for contributing to the module](#development)

## Module Description

This is the wso2base module which will prepare the system with required configuration needed to run WSO2 products.

## Setup

## Add Drivers to the module

##### Add MySQL JDBC driver 

Download [mysql-connector-java-5.X.XX-bin.jar](http://dev.mysql.com/downloads/connector/j/)

and copy to `files/configs/repository/components/lib/`

##### Add SVNKit bundle

Download [svnkit-bundle-1.0.0.jar](http://svnkit.com/download.php)

and copy to `files/configs/repository/components/dropins/`


### Beginning with WSO2 Base module

If you want a server installed with the default options you can run
`include 'wso2base'`. 

## Usage

## Reference

### Classes

#### Public classes

* [`wso2base`](#wso2base): Installs and manages the WSO2 base module

#### Private classes

* `wso2base::params`: Builds a hash of core module information.

### Parameters


## Limitations

This module has been tested on:

* Ubuntu 12.04, 14.04

Testing on other platforms has been minimal and cannot be guaranteed.

## Development

This module is maintained by WSO2, Inc.


