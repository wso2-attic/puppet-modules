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
#
# This class installs WSO2 API Manager

class wso2am inherits wso2base {
  notice("Starting WSO2 product [name] ${::product_name}, [version] ${::product_version}, [CARBON_HOME] ${carbon_home}")

  # Remove any existing installations
  wso2base::clean { $carbon_home:
    mode              => $maintenance_mode,
    pack_filename     => $pack_filename,
    pack_dir          => $pack_dir
  }

  # Copy the WSO2 product pack, extract and set permissions
  wso2base::install { $carbon_home:
    mode              => $install_mode,
    install_dir       => $install_dir,
    pack_filename     => $pack_filename,
    pack_dir          => $pack_dir,
    user              => $wso2_user,
    group             => $wso2_group,
    product_name      => $::product_name,
    require           => Wso2base::Clean[$carbon_home]
  }

  # Copy any patches to patch directory
  wso2base::patch { $carbon_home:
    patches_abs_dir   => $patches_abs_dir,
    patches_dir       => $patches_dir,
    user              => $wso2_user,
    group             => $wso2_group,
    product_name      => $::product_name,
    product_version   => $::product_version,
    notify            => Service["${service_name}"],
    require           => Wso2base::Install[$carbon_home]
  }

  # Populate templates and copy files provided
  wso2base::configure { $carbon_home:
    template_list     => $template_list,
    file_list         => $file_list,
    user              => $wso2_user,
    group             => $wso2_group,
    service_name      => $service_name,
    service_template  => $service_template,
    product_name      => $::product_name,
    product_version   => $::product_version,
    notify            => Service["${service_name}"],
    require           => Wso2base::Patch[$carbon_home]
  }

  # Deploy product artifacts
  wso2base::deploy { $carbon_home:
    user              => $wso2_user,
    group             => $wso2_group,
    product_name      => $::product_name,
    product_version   => $::product_version,
    require           => Wso2base::Configure[$carbon_home]
  }

  # Start the service
  service { $service_name:
    ensure            => running,
    hasstatus         => true,
    hasrestart        => true,
    enable            => true,
    require           => [Wso2base::Deploy[$carbon_home]]
  }

  notify{ "Successfully started WSO2 service [name] ${service_name}, [CARBON_HOME] ${carbon_home}":
    withpath => true,
    require  => Service[$service_name]
  }
}
