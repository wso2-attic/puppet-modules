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
# Class: monitor::params
#
class monitor::params {

  $monitoring_server_ip = '192.168.18.121'

  $nagios_package = $::operatingsystem ? {
    /(?i:Debian|Ubuntu)/ => 'nagios3',
    default              => 'nagios',
  }

  $nagios_service = $::operatingsystem ? {
    /(?i:Debian|Ubuntu)/ => 'nagios3',
    default              => 'nagios',
  }

  $nrpeplugin_package = $::operatingsystem ? {
    /(?i:RedHat|Centos|Fedora)/ => 'nagios-plugins-nrpe',
    default                     => 'nagios-nrpe-plugin',
  }

  $plugins_package = $::operatingsystem ? {
    /(?i:RedHat|Centos|Fedora)/ => 'nagios-plugins-all',
    default                     => 'nagios-plugins',
  }

  $config_dir = $::operatingsystem ? {
    /(?i:Debian|Ubuntu)/ => '/etc/nagios3',
    default              => '/etc/nagios',
  }

  $nagios_process = $::operatingsystem ? {
    /(?i:Debian|Ubuntu)/ => 'nagios3',
    default              => 'nagios',
  }

  # Apache configs
  $apache_package = $::operatingsystem ? {
    /(?i:Ubuntu|Debian)/ => 'apache2',
    /(?i:SLES|OpenSuSE)/ => 'apache2',
    default              => 'httpd',
  }

  $apache_service = $::operatingsystem ? {
    /(?i:Ubuntu|Debian)/ => 'apache2',
    /(?i:SLES|OpenSuSE)/ => 'apache2',
    default              => 'httpd',
  }

  $apache_process = $::operatingsystem ? {
    /(?i:Ubuntu|Debian)/ => 'apache2',
    /(?i:SLES|OpenSuSE)/ => 'httpd2-prefork',
    default              => 'httpd',
  }

  $nrpe_package = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => 'nagios-nrpe-server',
    /(?i:SLES|OpenSuSE)/      => 'nagios-nrpe',
    default                   => 'nrpe',
  }

  $nrpe_service = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => 'nagios-nrpe-server',
    /(?i:Solaris)/            => 'cswnrpe',
    default                   => 'nrpe',
  }

  $nrpe_process = $::operatingsystem ? {
    default => 'nrpe',
  }
}
