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

define registry::deploy ($security, $target, $owner, $group) {
  file { $target:
    ensure       => present,
    owner        => $owner,
    group        => $group,
    mode         => '0755',
    sourceselect => all,
    ignore       => '.svn',
    recurse      => 'remote',
    notify       => Service["wso2${registry::service_code}"],
    source       => [
      'puppet:///modules/registry/configs/',
      'puppet:///modules/registry/patches/',
      'puppet:///modules/registry/common/configs/',
      'puppet:///modules/registry/common/patches/',
      'puppet:///modules/wso2base/configs/',
      'puppet:///modules/wso2base/patches/',
      ],
  }
}
