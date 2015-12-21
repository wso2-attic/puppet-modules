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
class cep::distributednode (
  $version 		                  = '4.0.0',
  $offset  		                  = 0,
  $owner   		                  = 'root',
  $group   		                  = 'root',
  $target  		                  = '/mnt/distributednode',
  $maintenance_mode             = 'zero',
  $clustering                   = false,
  $depsync                      = false,
  $local_member_port            = 4000,
  $membership_scheme            = 'wka',
  $cluster_domain               = 'wso2.cep.distributed.domain',
  $members                      = {'127.0.0.1' => '4000'},
  $deployment_type              = 'distributed',
  $worker                       = 'true',
  $presenter                    = 'false',
  $manager                      = 'false',
  $managers                     = {'127.0.0.1' => '4000'},
  $manager_port                 = 8904,
  $presenter_port               = '11000',
  $topology_workers             = 2,
  $registry_db_connection_url   = undef,
  $registry_db_user             = undef,
  $registry_db_password         = undef,
  $registry_db_driver_name      = undef,
  $userstore_db_connection_url  = undef,
  $userstore_db_user            = undef,
  $userstore_db_password        = undef,
  $userstore_db_driver_name     = undef,

) inherits cep::params {

  $deployment_code = 'cep'
  $carbon_version  = $version
  $service_code    = 'cep'
  $carbon_home     = "${target}/wso2${service_code}-${carbon_version}"

 $service_templates = [
    'conf/carbon.xml',
    'conf/event-processor.xml',
    'conf/axis2/axis2.xml',
    'conf/datasources/master-datasources.xml',
    'conf/registry.xml',
    'conf/user-mgt.xml',
    'conf/cep/storm/storm.yaml',
 ]

 $common_templates = []

 tag($service_code)

 cep::clean { $deployment_code:
    mode      => $maintenance_mode,
    target    => $carbon_home,
    version   => $carbon_version,
    service   => $service_code,
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
      owner     => $owner,
      group     => $group,
      require   => Cep::Deploy[$deployment_code];

    $common_templates:
      target     => $carbon_home,
      directory  => "wso2base",
      owner     => $owner,
      group     => $group,
      require    => Cep::Deploy[$deployment_code];
  }

  file { "/etc/init.d/wso2${service_code}":
      ensure    => present,
      owner     => $owner,
      group     => $group,
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
