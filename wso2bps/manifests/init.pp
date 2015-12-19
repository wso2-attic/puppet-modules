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

  $maintenance_mode   = hiera("maintenance_mode")
  $install_mode       = hiera("install_mode")
  $install_dir        = hiera("wso2_install_dir")
  $pack_dir           = hiera("pack_dir")
  $pack_filename      = hiera("pack_filename")
  $pack_extracted_dir = hiera("pack_extracted_dir")
  $offset             = hiera("offset")
  $depsync            = hiera("depsync")
  $owner              = hiera("owner")
  $group              = hiera("group")
  $securevault        = hiera("securevault")
  $template_list      = hiera("template_list")
  $file_list          = hiera("file_list")
  $patches_dir        = hiera("patches_dir")
  $service_name       = hiera("service_name")
  $service_template   = hiera("service_template")
  $java_home          = hiera("java_home")

  $jvm                                        = hiera("jvm")
  $so_timeout                                 = hiera("so_timeout")
  $connection_timeout                         = hiera("connection_timeout")
  $clustering                                 = hiera("clustering")
  $domain                                     = hiera("domain")
  $sub_domain                                 = hiera("sub_domain")
  $http_proxy_port                            = hiera("http_proxy_port")
  $https_proxy_port                           = hiera("https_proxy_port")
  $mex_timeout                                = hiera("mex_timeout")
  $external_service_timeout                   = hiera("external_service_timeout")
  $max_connections_per_host                   = hiera("max_connections_per_host")
  $max_total_connections                      = hiera("max_total_connections")
  $ode_scheduler_thread_pool_size             = hiera("ode_scheduler_thread_pool_size")
  $scheduler_config_max_thread_pool_size      = hiera("scheduler_config_max_thread_pool_size")
  $enable_humantask_caching                   = hiera("enable_humantask_caching")
  $datasources                                = hiera("datasources")


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
    product_name      => $::product_name,
    require           => Wso2base::Clean[$carbon_home]
  }

  wso2base::patch { $carbon_home:
    patches_abs_dir   => $patches_abs_dir,
    patches_dir       => $patches_dir,
    owner             => $owner,
    group             => $group,
    product_name      => $::product_name,
    product_version   => $::product_version,
    notify            => Service["${service_name}"],
    require           => Wso2base::Install[$carbon_home]
  }

  wso2base::configure { $carbon_home:
    template_list     => $template_list,
    file_list         => $file_list,
    owner             => $owner,
    group             => $group,
    service_name      => $service_name,
    service_template  => $service_template,
    product_name      => $::product_name,
    product_version   => $::product_version,
    notify            => Service["${service_name}"],
    require           => Wso2base::Patch[$carbon_home]
  }

  wso2base::deploy { $carbon_home:
    owner             => $owner,
    group             => $group,
    product_name      => $::product_name,
    product_version   => $::product_version,
    require           => Wso2base::Configure[$carbon_home]
  }

  service { $service_name:
    ensure            => running,
    hasstatus         => true,
    hasrestart        => true,
    enable            => true,
    require           => [Wso2base::Deploy[$carbon_home]]
  }
}
