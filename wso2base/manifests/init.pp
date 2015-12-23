#----------------------------------------------------------------------------
#  Copyright 2005-2013 WSO2, Inc. http://www.wso2.org
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
# This class installs required base packages for WSO2 products and configures operating system parameters

class wso2base {
  $packages           = hiera_array("packages")
  $template_list      = hiera_array("wso2::template_list")
  $file_list          = hiera_array("wso2::file_list")

  $java_install_dir   = hiera("java_install_dir")
  $java_source_file   = hiera("java_source_file")
  $jvm_xms            = hiera("wso2::jvm_xms")
  $jvm_xmx            = hiera("wso2::jvm_xmx")
  $jvm_perm           = hiera("wso2::jvm_perm")
  $worker_node        = hiera("wso2::worker_node")

  # symlink path to Java install directory
  $java_home_sym_link = hiera("java_home")

  $wso2_user          = hiera("wso2::user")
  $wso2_group         = hiera("wso2::group")
  $maintenance_mode   = hiera("wso2::maintenance_mode")
  $install_mode       = hiera("wso2::install_mode")
  $install_dir        = hiera("wso2::install_dir")
  $pack_dir           = hiera("wso2::pack_dir")
  $pack_filename      = hiera("wso2::pack_filename")
  $pack_extracted_dir = hiera("wso2::pack_extracted_dir")
  $hostname           = hiera("wso2::hostname")
  $mgt_hostname       = hiera("wso2::mgt_hostname")
  $patches_dir        = hiera("wso2::patches_dir")
  $service_name       = hiera("wso2::service_name")
  $service_template   = hiera("wso2::service_template")
  $usermgt_datasource = hiera("wso2::usermgt_datasource")

  $master_datasources = hiera_hash("wso2::master_datasources")
  $registry_mounts    = hiera_hash("wso2::registry_mounts", {})
  $clustering         = hiera_hash("wso2::clustering")
  $dep_sync           = hiera_hash("wso2::dep_sync")
  $ports              = hiera_hash("wso2::ports")

  $carbon_home        = "${install_dir}/${pack_extracted_dir}"
  $patches_abs_dir    = "${carbon_home}/${patches_dir}"
  $java_home          = $java_home_sym_link
  $jvm                = hiera("wso2::jvm")

  # Install system packages
  package { $packages: ensure => installed }

  ensure_resource('file', $java_install_dir, {
    ensure  => 'directory',
    require => Package[$packages]
  })

  file { '/etc/environment':
    ensure            => present,
    source            => "puppet:///modules/${module_name}/environment",
  }

  cron { 'ntpdate':
    command           => "/usr/sbin/ntpdate pool.ntp.org",
    user              => 'root',
    minute            => '*/50'
  }

  group { $wso2_group:
    ensure            => 'present',
    gid               => '502',
  }

  user { $wso2_user:
    password          => $wso2_user,
    gid               => $wso2_group,
    ensure            => present,
    managehome        => true,
    shell             => '/bin/bash',
    require           => Group[$wso2_group]
  }

  java::setup { $java_source_file :
    ensure            => 'present',
    source            => $java_source_file,
    deploymentdir     => $java_install_dir,
    user              => 'root',
    cachedir          => "/home/${wso2_user}/java-setup-${name}",
    require           => [User[$wso2_user], File[$java_install_dir]]
  }

  # create a symlink for Java deployment
  file { $java_home_sym_link:
    ensure            => 'link',
    target            => $java_install_dir,
    require           => Java::Setup[$java_source_file]
  }

  # set JAVA_HOME environment variable and include JAVA_HOME/bin in PATH for all users
  file { "/etc/profile.d/set_java_home.sh":
    ensure            => present,
    content           => inline_template("JAVA_HOME=${java_home_sym_link}\nPATH=${java_home_sym_link}/bin:\$PATH"),
    require           => File[$java_home_sym_link]
  }
}
