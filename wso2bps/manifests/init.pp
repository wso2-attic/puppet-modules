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
# This class installs WSO2 Business Process Server

class wso2bps {
  require wso2base

  $maintenance_mode   = hiera("wso2::maintenance_mode")
  $install_mode       = hiera("wso2::install_mode")
  $install_dir        = hiera("wso2::install_dir")
  $pack_dir           = hiera("wso2::pack_dir")
  $pack_filename      = hiera("wso2::pack_filename")
  $pack_extracted_dir = hiera("wso2::pack_extracted_dir")
  $hostname           = hiera("wso2::hostname")
  $mgt_hostname       = hiera("wso2::mgt_hostname")
  $datasources        = hiera("wso2::datasources")
  $clustering         = hiera("wso2::clustering")
  $dep_sync           = hiera("wso2::dep_sync")
  $ports              = hiera("wso2::ports")
  $wso2_user          = hiera("wso2::user")
  $wso2_group         = hiera("wso2::group")
  $template_list      = hiera("wso2::template_list")
  $file_list          = hiera("wso2::file_list")
  $patches_dir        = hiera("wso2::patches_dir")
  $service_name       = hiera("wso2::service_name")
  $service_template   = hiera("wso2::service_template")
  $java_home          = hiera("java_home")

  $jvm                                        = hiera("wso2::jvm")
  $so_timeout                                 = hiera("wso2::so_timeout")
  $connection_timeout                         = hiera("wso2::connection_timeout")
  $domain                                     = hiera("wso2::domain")
  $sub_domain                                 = hiera("wso2::sub_domain")
  $http_proxy_port                            = hiera("wso2::http_proxy_port")
  $https_proxy_port                           = hiera("wso2::https_proxy_port")
  $mex_timeout                                = hiera("wso2::mex_timeout")
  $external_service_timeout                   = hiera("wso2::external_service_timeout")
  $max_connections_per_host                   = hiera("wso2::max_connections_per_host")
  $max_total_connections                      = hiera("wso2::max_total_connections")
  $ode_scheduler_thread_pool_size             = hiera("wso2::ode_scheduler_thread_pool_size")
  $scheduler_config_max_thread_pool_size      = hiera("wso2::scheduler_config_max_thread_pool_size")
  $enable_humantask_caching                   = hiera("wso2::enable_humantask_caching")


  $carbon_home        = "${install_dir}/${pack_extracted_dir}"
  $patches_abs_dir    = "${carbon_home}/${patches_dir}"

  notice("Installing WSO2 Product: ${::product_name} Version: ${::product_version}")

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
}
