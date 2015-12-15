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
# This class installs WSO2 Goverance Registry

class wso2greg {

  require wso2base

  $maintenance_mode   = hiera("maintenance_mode")
  $install_mode       = hiera("install_mode")
  $install_dir        = hiera("install_dir")
  $pack_dir           = hiera("pack_dir")
  $pack_filename      = hiera("pack_filename")
  $pack_extracted_dir = hiera("pack_extracted_dir")
  $ports              = hiera("ports")
  $datasources        = hiera("datasources")
  $clustering         = hiera("clustering")
  $dep_sync           = hiera("dep_sync")
  $owner              = hiera("owner")
  $group              = hiera("group")
  $securevault        = hiera("securevault")
  $template_list      = hiera("template_list")
  $file_list          = hiera("file_list")
  $patches_dir        = hiera("patches_dir")
  $service_name       = hiera("service_name")

  $carbon_home        = "${install_dir}/${pack_extracted_dir}"
  $patches_abs_dir    = "${carbon_home}/${patches_dir}"


  wso2base::clean { $carbon_home:
    mode              => $maintenance_mode,
    pack_filename     => $pack_filename,
    pack_dir          => $pack_dir
  }

  wso2base::install { $carbon_home:
    mode              => $install_mode,
    install_dir       => $install_dir,
    pack_filename     => $pack_filename,
    pack_dir          => $pack_dir,
    owner             => $owner,
    group             => $group,
    product_name      => $product_name,
    require           => Wso2base::Clean[$carbon_home]
  }

  wso2base::patch { $carbon_home:
    patches_abs_dir   => $patches_abs_dir,
    patches_dir       => $patches_dir,
    owner             => $owner,
    group             => $group,
    product_name      => $product_name,
    product_version   => $product_version,
    notify            => Service["${service_name}"],
    require           => Wso2base::Install[$carbon_home]
  }

  wso2base::configure { $carbon_home:
    template_list     => $template_list,
    file_list         => $file_list,
    owner             => $owner,
    group             => $group,
    service_name      => $service_name,
    product_name      => $product_name,
    product_version   => $product_version,
    notify            => Service["${service_name}"],
    require           => Wso2base::Patch[$carbon_home]
  }

  wso2base::deploy { $carbon_home:
    owner             => $owner,
    group             => $group,
    product_name      => $product_name,
    product_version   => $product_version,
    require           => Wso2base::Configure[$carbon_home]
  }

  service { $service_name:
    ensure           => running,
    hasstatus        => true,
    hasrestart       => true,
    enable           => true,
    require          => [Wso2base::Deploy[$carbon_home]]
  }
}
