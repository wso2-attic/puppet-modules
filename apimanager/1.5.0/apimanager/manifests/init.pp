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
#
# Class: apimanager
#
# This class installs WSO2 API Manager
#
# Parameters:
#  version            => '1.5.0',
#  offset             => 0,
#  hazelcast_port     => 4000,
#  config_db          => 'am_config',
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

class apimanager (
  $version            = undef,
  $env                = undef,
  $sub_cluster_domain = undef,
  $members            = undef,
  $port_mapping       = undef,
  $offset             = 0,
  $hazelcast_port     = 4000,
  $config_db          = 'governance',
  $maintenance_mode   = true,
  $depsync            = false,
  $clustering         = false,
  $cloud              = false,
  $amtype             = 'gateway',
  $owner              = 'root',
  $group              = 'root',
  $target             = '/mnt',
) inherits params {

  $deployment_code = 'apimanager'
  $carbon_version  = $version
  $service_code    = 'am'
  $carbon_home     = "${target}/wso2${service_code}-${carbon_version}"

  $service_templates = [
    'conf/api-manager.xml',
    'conf/axis2/axis2.xml',
    'conf/carbon.xml',
#    'conf/datasources/master-datasources.xml',
#    'conf/registry.xml',
#    'conf/tomcat/catalina-server.xml',
#    'conf/user-mgt.xml',
    'deployment/server/jaggeryapps/publisher/site/conf/site.json',
    'deployment/server/jaggeryapps/store/site/conf/site.json',
    ]

  tag($service_code)

  apimanager::clean { $deployment_code:
    mode   => $maintenance_mode,
    target => $carbon_home,
  }

  apimanager::initialize { $deployment_code:
    repo      => $package_repo,
    version   => $carbon_version,
    service   => $service_code,
    local_dir => $local_package_dir,
    target    => $target,
    mode      => $maintenance_mode,
    owner     => $owner,
    require   => Apimanager::Clean[$deployment_code],
  }

  apimanager::deploy { $deployment_code:
    service  => $deployment_code,
    security => true,
    owner    => $owner,
    group    => $group,
    target   => $carbon_home,
    require  => Apimanager::Initialize[$deployment_code],
  }

  if $sub_cluster_domain == 'worker' {
    apimanager::create_worker { $deployment_code:
      target  => $carbon_home,
      require => Apimanager::Deploy[$deployment_code],
    }
  }

  apimanager::push_templates {
    $service_templates:
      target    => $carbon_home,
      directory => $deployment_code,
      owner     => $owner,
      group     => $group,
      require   => Apimanager::Deploy[$deployment_code];
  }

  file {
    "${carbon_home}/bin/wso2server.sh":
      ensure    => present,
      owner     => $owner,
      group     => $group,
      mode      => '0755',
      content   => template('apimanager/wso2server.sh.erb'),
      require   => Apimanager::Deploy[$deployment_code];
  }

  apimanager::start { $deployment_code:
    owner   => $owner,
    target  => $carbon_home,
    require => [
      Apimanager::Initialize[$deployment_code],
      Apimanager::Deploy[$deployment_code],
      Apimanager::Push_templates[$service_templates],
      File["${carbon_home}/bin/wso2server.sh"],
      ],
  }
}
