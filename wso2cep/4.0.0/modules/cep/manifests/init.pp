#
# Copyright (c) 2015, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# ----------------------------------------------------------------------------
#
# Class: CEP
#
# This class installs WSO2 CEP
#
# Parameters:
#
# version            => '4.0.0',
# offset             => 0,
# owner              => 'wso2',
# group              => 'wso2',
# target             => '/mnt/',
#
# Actions:
#   - Install WSO2 CEP
#
# Requires:
#
# Sample Usage:
#
class cep (
  $version 		       = '4.0.0',
  $offset  		       = 0,
  $owner   		       = 'root',
  $group   		       = 'root',
  $target  		       = '/mnt',
  $maintenance_mode  = 'zero',
  $cep_type          = 'standalone'
) inherits cep::params {

  $deployment_code = 'cep'
  $carbon_version  = $version
  $service_code    = 'cep'
  $carbon_home     = "${target}/wso2${service_code}-${carbon_version}"

 $service_templates = [
    'conf/carbon.xml',
 ]

 $common_templates = []

 tag($service_code)

 cep::clean { $deployment_code:
    mode   => $maintenance_mode,
    target => $carbon_home,
  }

 cep::initialize { $deployment_code:
    repo      => $package_repo,
    version   => $carbon_version,
    service   => $service_code,
    local_dir => $local_package_dir,
    target    => $target,
    owner     => $owner,
    require   => Cep::Clean[$deployment_code],
  }

  cep::deploy { $deployment_code:
    service  => $deployment_code,
    owner    => $owner,
    group    => $group,
    target   => $carbon_home,
    require  => Cep::Initialize[$deployment_code],
  }

  cep::push_templates {
    $service_templates:
      target    => $carbon_home,
      directory => $deployment_code,
      require   => Cep::Deploy[$deployment_code];

    $common_templates:
      target     => $carbon_home,
      directory  => "wso2base",
      require    => Cep::Deploy[$deployment_code];
  }

  file { "/etc/init.d/wso2${service_code}":
      ensure    => present,
      owner     => 'root',
      group     => 'root',
      mode      => '0775',
      content   => template("${deployment_code}/wso2${service_code}.erb"),
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
            File["/etc/init.d/wso2${service_code}"],
      ]
  }
}
