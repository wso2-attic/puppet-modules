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
# Class: monitor::agent
#
class monitor::agent inherits monitor::params {
  package { 'nrpe':
    ensure => installed,
    name   => $nrpe_package;
  }

  service { 'nrpe':
    ensure    => running,
    name      => $nrpe_service,
    hasstatus => true,
    pattern   => $nrpe_process,
    require   => Package['nrpe'];
  }

  file { '/etc/nagios/nrpe.cfg':
    ensure  => present,
    content => template('monitor/agent/nrpe.cfg.erb'),
    notify  => Service['nrpe'],
    require => Package['nrpe'];
  }

  @@file { "${config_dir}/conf.d/wso2/${ipaddress}-host.cfg":
    ensure  => present,
    mode    => '0644',
    notify  => Service['nagios'],
    content => template('monitor/master/host.erb'),
    tag     => 'nagios_check';
  }

  @@file { "${config_dir}/conf.d/wso2/${ipaddress}-services.cfg":
    ensure  => present,
    mode    => '0644',
    notify  => Service['nagios'],
    content => template('monitor/master/services.erb'),
    tag     => 'nagios_check';
  }
}
