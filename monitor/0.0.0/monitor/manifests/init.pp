# ----------------------------------------------------------------------------
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
# ----------------------------------------------------------------------------
#  THANKS - example42 (nagios module)
#
# Class: monitor
#
class monitor inherits monitor::params {

  package { 'apache':
    ensure => installed,
    name   => $apache_package,
  }

  service { 'apache':
    ensure    => running,
    name      => $apache_service,
    hasstatus => true,
    pattern   => $apache_process,
    require   => Package['apache'];
  }

  package { 'nrpe-plugin':
    ensure => installed,
    name   => $nrpeplugin_package,
  }

  package { 'nagios':
    ensure  => installed,
    name    => $nagios_package,
    require => Service['apache'];
  }

  service { 'nagios':
    ensure    => running,
    name      => $nagios_service,
    hasstatus => true,
    pattern   => $nagios_process,
    require   => Package['nagios'];
  }

  file { "${config_dir}/htpasswd.users":
    ensure  => present,
    source  => 'puppet:///modules/monitor/htpasswd.users',
    require => Package['nagios'];
  }

  file { "/etc/nagios-plugins/config/https_url.cfg":
    ensure  => present,
    source  => 'puppet:///modules/monitor/https_url.cfg',
    require => Package['nagios'],
    notify  => Service['nagios'];
  }


  file { "${config_dir}/conf.d/wso2":
    ensure  => directory,
    require => Package['nagios'];
  }

  File <<| tag == "nagios_check" |>>
}
