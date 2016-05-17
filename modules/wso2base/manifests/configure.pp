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

define wso2base::configure ($template_list, $directory_list, $file_list, $system_file_list, $user, $group, $wso2_module) {
  $carbon_home  = $name
  notice("Configuring WSO2 product [name] ${::product_name}, [version] ${::product_version}, [CARBON_HOME] ${carbon_home}")

  if ($directory_list != undef and size($directory_list) > 0) {
    wso2base::ensure_directory_structures {
      $directory_list:
        system           => false,
        carbon_home      => $carbon_home
    }
  }

  if ($template_list != undef and size($template_list) > 0) {
    wso2base::push_templates {
      $template_list:
        owner       => $user,
        group       => $group,
        carbon_home => $carbon_home,
        wso2_module => $wso2_module,
        require     => Wso2base::Ensure_directory_structures[$directory_list]
    }
  }

  if ($file_list != undef and size($file_list) > 0) {
    wso2base::push_files {
      $file_list:
        owner       => $user,
        group       => $group,
        carbon_home => $carbon_home,
        wso2_module => $wso2_module,
        require     => Wso2base::Ensure_directory_structures[$directory_list]
    }
  }

  if ($system_file_list != undef and size($system_file_list) > 0) {
    wso2base::push_system_files {
      $system_file_list:
        owner       => $user,
        group       => $group,
        wso2_module => $wso2_module,
        require     => Wso2base::Ensure_directory_structures[$directory_list]
    }
  }
}
