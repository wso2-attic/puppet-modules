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
#
# Class: wso2base
#
# This class installs required system packages for WSO2 products and configures operating system parameters
class wso2base {
  $packages             = hiera_array('packages')
  $template_list        = hiera_array('wso2::template_list')
  $file_list            = hiera_array('wso2::file_list')
  $system_file_list     = hiera_array('wso2::system_file_list')
  $directory_list       = hiera_array('wso2::directory_list', [])

  $master_datasources   = hiera_hash('wso2::master_datasources')
  $registry_mounts      = hiera_hash('wso2::registry_mounts', { })
  $hosts_mapping        = hiera_hash('wso2::hosts_mapping')

  $java_install_dir     = hiera('java_install_dir')
  $java_source_file     = hiera('java_source_file')
  $worker_node          = hiera('wso2::worker_node')
  # symlink path to Java install directory
  $java_home            = hiera('java_home')
  $carbon_home_symlink  = hiera('wso2::carbon_home_symlink')
  $wso2_user            = hiera('wso2::user')
  $wso2_group           = hiera('wso2::group')
  $maintenance_mode     = hiera('wso2::maintenance_mode')
  $install_mode         = hiera('wso2::install_mode')
  $install_dir          = hiera('wso2::install_dir')
  $pack_dir             = hiera('wso2::pack_dir')
  $pack_filename        = hiera('wso2::pack_filename')
  $pack_extracted_dir   = hiera('wso2::pack_extracted_dir')
  $hostname             = hiera('wso2::hostname')
  $mgt_hostname         = hiera('wso2::mgt_hostname')
  $patches_dir          = hiera('wso2::patches_dir')
  $service_name         = hiera('wso2::service_name')
  $service_template     = hiera('wso2::service_template')
  $hosts_template       = hiera('wso2::hosts_template')
  $usermgt_datasource   = hiera('wso2::usermgt_datasource')
  $local_reg_datasource = hiera('wso2::local_reg_datasource')
  $clustering           = hiera('wso2::clustering')
  $dep_sync             = hiera('wso2::dep_sync')
  $ports                = hiera('wso2::ports')
  $jvm                  = hiera('wso2::jvm')
  $ipaddress            = hiera('wso2::ipaddress')
  $fqdn                 = hiera('wso2::fqdn')

  #secure_vault configurations
  $enable_secure_vault  = hiera('wso2::enable_secure_vault')
  if ($enable_secure_vault == true) {
      $secure_vault_configs = hiera('wso2::secure_vault_configs')
      $key_store_password   = $secure_vault_configs['key_store_password']['password']
  }

  $carbon_home          = "${install_dir}/${pack_extracted_dir}"
  $system_pref_dir      = ["/home/${wso2_user}/.java/", "/home/${wso2_user}/.java/.systemPrefs"]

  if ($::wso2_patching_mode == undef or
  str2bool($::wso2_patching_mode) != true) or
  ($::wso2_upgrade_jdk != undef and str2bool($::wso2_upgrade_jdk) == true) {
    class { '::wso2base::system':
      packages         => $packages,
      wso2_group       => $wso2_group,
      wso2_user        => $wso2_user,
      service_name     => $service_name,
      service_template => $service_template,
      hosts_template   => $hosts_template
    } ->
    class { '::wso2base::java':
      java_install_dir => $java_install_dir,
      java_source_file => $java_source_file,
      wso2_user        => $wso2_user,
      wso2_group       => $wso2_group,
      java_home        => $java_home,
      system_pref_dir  => $system_pref_dir
    }
  } else {
    class { '::wso2base::system':
      packages         => $packages,
      wso2_group       => $wso2_group,
      wso2_user        => $wso2_user,
      service_name     => $service_name,
      service_template => $service_template,
      hosts_template   => $hosts_template
    }
  }

  contain wso2base::system
  # Only install JDK if (wso2_patching_mode=false) or (wso2_patching_mode=true & wso2_upgrade_jdk=true)
  if ($::wso2_patching_mode == undef or str2bool($::wso2_patching_mode) != true) or
  ($::wso2_upgrade_jdk != undef and str2bool($::wso2_upgrade_jdk) == true) {
    contain wso2base::java
  }
}
