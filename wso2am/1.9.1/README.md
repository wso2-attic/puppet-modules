# apimanager

#### Table of Contents

1. [Module Description - What the module does and why it is useful](#module-description)
2. [Backwards compatibility information](#backwards-compatibility)
3. [Setup - The basics of getting started with apimanager module](#setup)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Development - Guide for contributing to the module](#development)

## Module Description

This is apimanager module will install WSO2 API Manager

## Setup

### Beginning with apimanager module

If you want a server installed with the default options you can run,  
`include 'apimanager'`

If you want to install API Manager as a given specific roles, i.e. publisher, store, keymanager, gateway you can run,

`include 'apimanager::keymanager'`  
`include 'apimanager::gateway'`  
`include 'apimanager::pubstore'`  

## Usage

## Reference

### Classes

* [`apimanager`](#apimanager): Installs and manages the WSO2 base module in the standalone mode
* `apimanager::params`: Builds a hash of apimanager module information.
* `apimanager::keymanager`: Install and configure the API Manager as the keymanager.
* `apimanager::gateway`: Install and configure the API Manager as the gateway.
* `apimanager::pubstore`: Install and configure the API Manager as both publisher and store.

### Parameters

#### apimanager
`version`  
This is to specify the version of the API Manager, e.g.: 1.9.1  
`offset`  
Offset of the carbon server that will be deployed, default value is 0.
This will overide the `CARBON_HOME/repository/conf/carbon.xml` offset value.  
`config_database`  
This is to specify which config database to use, example value will be 'config'  
`maintenance_mode`  
To specify the maintenance mode to be used during cleanup and initialization processes.  
Allowed values are as follows,  
`refresh`: To remove the lock file and restart the carbon server.  
`new`: To stop process and remove carbon home.  
`zero`: To stop process, remove carbon home and remove the product pack.    
`depsync`  
Whether to specify deployment synchronization functionality is used or not.  
`sub_cluster_domain`  
This will be used in clustered setup.  
Allowed values, `mgt`, `worker`.  
`clustering`  
To specify whether the node is in a clustered setup or not.     
`cloud`  
To specify whether the node is running on a cloud environment.    
`amtype`  
Allowed values `apimanager`, `pubstore`, `gateway`, `keymanager`   
`owner`  
e.g.: 'root'   
`group`  
e.g.: 'root'  
`target`  
To specify the target folder where to extract the product pack and create carbon home  
e.g.: '/mnt'  
`members`  
To specify the well known members in a clustered setup.  
e.g.: {'192.168.18.122' => 4010 }  
`port_mapping`  
To specify the port mapping values.   
e.g.: { 8280 => 9763, 8243 => 9443 }    

## Limitations

This module has been tested on:

* Ubuntu 12.04, 14.04

Testing on other platforms has been minimal and cannot be guaranteed.

## Development

This module is maintained by WSO2, Inc.


