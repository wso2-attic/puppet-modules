#----------------------------------------------------------------------------
#  Copyright (c) 2016 WSO2, Inc. http://www.wso2.org
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
# Manages system configuration
class wso2base::system (
  $packages,
  $wso2_group,
  $wso2_user,
  $service_name,
  $service_template,
  $hosts_mapping
) {
  # Install system packages
  package { $packages: ensure => installed }

  if $::vm_type != 'docker' {
    cron { 'ntpdate':
      command => '/usr/sbin/ntpdate pool.ntp.org',
      user    => 'root',
      minute  => '*/50'
    }
  }

  group { $wso2_group:
    ensure => 'present',
    gid    => '502',
  }

  user { $wso2_user:
    ensure     => present,
    password   => $wso2_user,
    gid        => $wso2_group,
    managehome => true,
    shell      => '/bin/bash',
    require    => Group[$wso2_group]
  }

  if $::vm_type != 'docker' {
    file { "/etc/init.d/${service_name}":
      ensure  => present,
      owner   => $wso2_user,
      group   => $wso2_group,
      mode    => '0755',
      content => template($service_template),
    }

  if ($osfamily == 'RedHat') and ($operatingsystemmajrelease >= 7) {
    file { "/etc/systemd/system/${service_name}.service":
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template(wso2base/wso2unit.erb)
      }
    }
  }

  if $::vm_type != 'docker' {
    create_resources(host, $hosts_mapping)
  }
}
