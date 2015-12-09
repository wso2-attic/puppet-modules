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
# Class: identity
#
# This class installs WSO2 IDENTITY
#
# Parameters:
#
# Actions:
#   - Install WSO2 IDENTITY
#
# Requires:
#
# Sample Usage:
#

class wso2is (
  $version            = '5.0.0',
  $offset             = 0,
  $identity_subdomain       = "cloudmgt",
  $localmember_port   = '4000',
  $config_db          = governance,
  $maintenance_mode   = true,
  $depsync            = false,
  $sub_cluster_domain = mgt,
  $clustering         = false,
  $members            = {
  }
  ,
  $owner              = root,
  $group              = root,
  $target             = '/home/gayan/wso2',
  $monitoring         = false) inherits wso2is::params {
  $deployment_code = 'wso2is'
  $service_code = 'is'
  $carbon_version = $version
  $carbon_home = "${target}/wso2${service_code}-${carbon_version}"

  $service_templates = [ 'conf/axis2/axis2.xml', 'conf/carbon.xml', ]

  $common_templates = [ 'conf/datasources/master-datasources.xml' ]

  $securevault_templates = [ 'conf/security/secret-conf.properties', 'conf/security/cipher-text.properties', ]

  tag('wso2is')

  wso2is::clean { $deployment_code:
    mode   => $maintenance_mode,
    target => $carbon_home;
  }

  wso2is::initialize { $deployment_code:
    repo      => $package_repo,
    version   => $carbon_version,
    mode      => $maintenance_mode,
    service   => $service_code,
    local_dir => $local_package_dir,
    owner     => $owner,
    target    => $target,
    require   => Clean[$deployment_code];
  }

  wso2is::deploy { $deployment_code:
    service  => $service_code,
    deployment_code => $deployment_code,
    security => true,
    owner    => $owner,
    group    => $group,
    target   => $carbon_home,
    require  => Initialize[$deployment_code];
  }

  wso2is::push_templates {
    $service_templates:
      owner     => $owner,
      group     => $group,
      target    => $carbon_home,
      directory => $deployment_code,
      require   => Deploy[$deployment_code];

    $common_templates:
      owner     => $owner,
      group     => $group,
      target    => $carbon_home,
      directory => 'wso2base',
      require   => Deploy[$deployment_code];
  }

  if $::securevault {
    wso2is::push_templates { $securevault_templates:
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
    require => Deploy[$deployment_code],
    notify  => Service["wso2${service_code}"],
  }

  file { "/etc/init.d/wso2${service_code}":
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0775',
    content => template("${deployment_code}/wso2${service_code}.erb"),
    require => Deploy[$deployment_code],
  }

  service { "wso2${service_code}":
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    enable     => true,
    require    => [
      Initialize[$deployment_code],
      Deploy[$deployment_code],
      Push_templates[$service_templates],
      File["${carbon_home}/bin/wso2server.sh"],
      File["/etc/init.d/wso2${service_code}"],
      ]
  }
}

