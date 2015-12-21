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
class storm::nimbus (
  $version 		        = '0.9.5',
  $owner   		        = 'root',
  $group   		        = 'root',
  $target  		        = '/mnt/storm-nimbus',
  $maintenance_mode   = 'zero',
  $full_name          = 'backtype.storm.daemon.nimbus'
 
) inherits storm::params {

  $deployment_code = 'storm'
  $storm_version  = $version
  $service_code    = 'nimbus'
  $storm_home     = "${target}/apache-storm-${storm_version}"

 $service_templates = [
    'conf/storm.yaml',
 ]

 tag($service_code)

 storm::clean { $deployment_code:
    mode      => $maintenance_mode,
    target    => $storm_home,
    version   => $storm_version,
    name      => $full_name,
  }

 storm::initialize { $deployment_code:
    repo      => $package_repo,
    version   => $storm_version,
    local_dir => $local_package_dir,
    target    => $target,
    owner     => $owner,
    require   => Storm::Clean[$deployment_code],
  }

  storm::push_templates {
    $service_templates:
      target    => $storm_home,
      directory => $deployment_code,
      owner     => $owner,
      group     => $group,
      require   => Storm::Initialize[$deployment_code];
  }

  storm::start { $deployment_code:
    target  => $storm_home,
    owner   => $owner,
    service => $service_code,
    java_home => $java_home,
    require  => [
                 Storm::Initialize[$deployment_code],
                 Storm::Push_templates[$service_templates],
                 ],
  }
}
