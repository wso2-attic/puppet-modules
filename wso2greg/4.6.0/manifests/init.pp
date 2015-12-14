#----------------------------------------------------------------------------
#  Copyright 2005-2015 WSO2, Inc. http://www.wso2.org
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
# Class: registry
#
# This class installs WSO2 Goverance Registry
#
# Parameters:
#  version            => '4.6.0',
#  offset             => 0,
#  config_database    => 'config',
#  maintenance_mode   => 'zero',
#  depsync            => false,
#  sub_cluster_domain => 'mgt',
#  clustering         => true,
#  cloud              => true,
#  service_code       => 'greg',
#  owner              => 'root',
#  group              => 'root',
#  target             => '/mnt',
#  members            => {'192.168.18.122' => 4010 },
#  port_mapping       => { 8280 => 9763, 8243 => 9443 }
#
# Actions:
#   - Install WSO2 Goverance Registry
#
# Requires:
#
# Sample Usage:
#

class registry (
  $version            = undef,
  $offset             = 0,
  $members            = undef,
  $greg_subdomain     = 'registry',
  $localmember_port   = 4100,
  $config_db          = governance,
  $maintenance_mode   = 'refresh',
  $depsync            = false,
  $sub_cluster_domain = 'mgt',
  $owner              = 'root',
  $group              = 'root',
  $clustering         = true,
  $target             = '/mnt',
  $auto_scaler        = false,
  $auto_failover      = false,
  $securevault        = false,) inherits registry::params {
  $deployment_code = 'registry'
  $service_code = 'wso2greg'
  $carbon_home = "${target}/${service_code}-${version}"

  $service_templates = [
    'conf/axis2/axis2.xml',
    'conf/carbon.xml',
    'conf/registry.xml',
    'conf/datasources/greg-datasources.xml'
  ]

  $common_templates = [
    'conf/user-mgt.xml',
    'conf/datasources/master-datasources.xml',
    'conf/tomcat/catalina-server.xml'
  ]

  $securevault_templates = [
    'conf/security/secret-conf.properties',
    'conf/security/cipher-text.properties'
  ]

  tag($deployment_code)

  registry::clean { $deployment_code:
    mode   => $maintenance_mode,
    target => $carbon_home,
  }

  registry::initialize { $deployment_code:
    repo      => $package_repo,
    version   => $version,
    mode      => $maintenance_mode,
    service   => $service_code,
    local_dir => $local_package_dir,
    owner     => $owner,
    target    => $target,
    require   => Clean[$deployment_code],
  }

  registry::deploy { $deployment_code:
    security => true,
    owner    => $owner,
    group    => $group,
    target   => $carbon_home,
    require  => Initialize[$deployment_code],
  }

  registry::push_templates {
    $service_templates:
      owner     => $owner,
      group     => $group,
      target    => $carbon_home,
      directory => $deployment_code,
      notify    => Service["${service_code}"],
      require   => Deploy[$deployment_code];

    $common_templates:
      owner     => $owner,
      group     => $group,
      target    => $carbon_home,
      directory => 'wso2base',
      notify    => Service["${service_code}"],
      require   => Deploy[$deployment_code];
  }

  if $securevault {
    registry::push_templates { $securevault_templates:
      target    => $carbon_home,
      directory => 'wso2base',
      require   => Deploy[$deployment_code];
    }
  }

  file { "${carbon_home}/bin/wso2server.sh":
    ensure  => present,
    owner   => $owner,
    group   => $group,
    mode    => '0755',
    content => template("${deployment_code}/wso2server.sh.erb"),
    require => Deploy[$deployment_code];
  }

  file { "/etc/init.d/${service_code}":
    ensure  => present,
    owner   => $owner,
    group   => $group,
    mode    => '0755',
    content => template("${deployment_code}/${service_code}.erb"),
  }

  service { "${service_code}":
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    enable     => true,
    require    => [
      Initialize[$deployment_code],
      Deploy[$deployment_code],
      Push_templates[$service_templates],
      File["${carbon_home}/bin/wso2server.sh"],
      File["/etc/init.d/${service_code}"],
      ],
  }
}
