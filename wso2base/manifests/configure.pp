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

define wso2base::configure ($template_list, $file_list, $owner, $group, $service_name, $service_template, $product_name, $product_version) {
  $carbon_home  = $name

  if ($template_list != undef and size($template_list) > 0) {
    wso2base::push_templates {
      $template_list:
        owner            => $owner,
        group            => $group,
        carbon_home      => $carbon_home,
        product_name     => $product_name,
        product_version  => $product_version
    }
  }

  if ($file_list != undef and size($file_list) > 0) {
    wso2base::push_files {
      $file_list:
        owner            => $owner,
        group            => $group,
        carbon_home      => $carbon_home,
        product_name     => $product_name,
        product_version  => $product_version
    }
  }

  file { "/etc/init.d/${service_name}":
    ensure               => present,
    owner                => $owner,
    group                => $group,
    mode                 => '0755',
    content              => template("${service_template}"),
  }
}
