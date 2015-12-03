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

class apimanager::gateway (
  $version            = undef,
  $offset             = 0,
  $services           = undef,
  $members            = undef,
  $clustering         = false,
  $sub_cluster_domain = "worker",
  $maintenance_mode   = 'refresh',
  $localmember_port   = '4000',
  $config_db          = governance,
  $depsync            = false,
  $cloud              = false,
  $owner              = 'root',
  $group              = 'root',
  $target             = '/mnt',
  $auto_scaler        = false,
  $auto_failover      = false,
  $securevault        = false,) inherits apimanager::params {
  $deployment_code = 'apimanager'
  $service_code = 'am'
  $amtype = 'gateway'
  $carbon_home = "${target}/wso2${service_code}-${version}"

  $service_templates = [
    'conf/api-manager.xml',
    'conf/carbon.xml',
    'conf/registry.xml',
    'conf/axis2/axis2.xml',
    'conf/datasources/am-datasources.xml']

  $common_templates = ['conf/user-mgt.xml', 'conf/datasources/master-datasources.xml', 'conf/tomcat/catalina-server.xml',]

  $securevault_templates = ["conf/security/secret-conf.properties", "conf/security/cipher-text.properties",]

  tag('apimanager')

  apimanager::clean { $deployment_code:
    mode   => $maintenance_mode,
    target => $carbon_home,
  }

  apimanager::initialize { $deployment_code:
    repo      => $package_repo,
    version   => $version,
    mode      => $maintenance_mode,
    service   => $service_code,
    local_dir => $local_package_dir,
    owner     => $owner,
    target    => $target,
    require   => Clean[$deployment_code],
  }

  apimanager::deploy { $deployment_code:
    security => true,
    owner    => $owner,
    group    => $group,
    target   => $carbon_home,
    amtype   => $amtype,
    require  => Initialize[$deployment_code],
  }

  apimanager::push_templates {
    $service_templates:
      owner     => $owner,
      group     => $group,
      target    => $carbon_home,
      directory => $deployment_code,
      notify    => Service["wso2${amtype}"],
      require   => Deploy[$deployment_code];

    $common_templates:
      owner     => $owner,
      group     => $group,
      target    => $carbon_home,
      directory => "wso2base",
      notify    => Service["wso2${amtype}"],
      require   => Deploy[$deployment_code];
  }

  if $securevault {
    apimanager::push_templates { $securevault_templates:
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

  file { "/etc/init.d/wso2${amtype}":
    ensure  => present,
    owner   => $owner,
    group   => $group,
    mode    => '0755',
    content => template("${deployment_code}/wso2${service_code}.erb"),
  }

  service { "wso2${amtype}":
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    enable     => true,
    require    => [
      Initialize[$deployment_code],
      Deploy[$deployment_code],
      Push_templates[$service_templates],
      File["${carbon_home}/bin/wso2server.sh"],
      File["/etc/init.d/wso2${amtype}"],
      ],
  }
}
