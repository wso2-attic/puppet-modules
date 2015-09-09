#----------------------------------------------------------------------------
#  Copyright 2005-2013 WSO2, Inc. http://www.wso2.org
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#----------------------------------------------------------------------------
#
# Class: wso2base
#
# This class installs WSO2 API Manager
#
# Parameters:
#  version            => '1.5.0',
#  offset             => 0,
#  config_database    => 'config',
#  maintenance_mode   => 'zero',
#  depsync            => false,
#  sub_cluster_domain => 'mgt',
#  clustering         => true,
#  cloud              => true,
#  amtype             => 'gateway',
#  owner              => 'root',
#  group              => 'root',
#  target             => '/mnt',
#  members            => {'192.168.18.122' => 4010 },
#  port_mapping       => { 8280 => 9763, 8243 => 9443 }
#
# Actions:
#   - Install WSO2 API Manager
#
# Requires:
#
# Sample Usage:
#

class wso2base inherits wso2base::params {
  file { '/etc/environment':
    ensure => present,
    source => 'puppet:///modules/wso2base/environment',
  }

  cron { 'ntpdate':
    command => "/usr/sbin/ntpdate pool.ntp.org",
    user    => 'root',
    minute  => '*/50'
  }

  user { 'wso2user':
    password   => "wso2user",
    ensure     => present,
    managehome => true,
    shell      => '/bin/bash',
  }

  file { '/etc/hosts':
    owner   => 'root',
    mode    => '0644',
    content => template('wso2base/hosts.erb'),
  }

  file { '/mnt/dbscripts':
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/wso2base/dbscripts',
  }

  package { $packages: ensure => installed }
}
