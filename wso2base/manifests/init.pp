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
  $install_dir        = hiera("install_dir")
  $java_deploymentdir = hiera("java_deploymentdir")
  $java_source_file   = hiera("java_source_file")

  # symlink to Java install directory
  $java_home          = hiera("java_home")

  # absolute path to Java install directory
  $java_install_dir   = "${install_dir}/${java_deploymentdir}"

  ensure_resource('file', $install_dir, { ensure => 'directory' })

  file { '/etc/environment':
    ensure            => present,
    source            => 'puppet:///modules/wso2base/environment',
  }

  cron { 'ntpdate':
    command           => "/usr/sbin/ntpdate pool.ntp.org",
    user              => 'root',
    minute            => '*/50'
  }

  group { 'wso2':
    ensure            => 'present',
    gid               => '502',
  }

  user { 'wso2user':
    password          => "wso2user",
    gid               => "wso2",
    ensure            => present,
    managehome        => true,
    shell             => '/bin/bash',
    require           => Group["wso2"]
  }

  java::setup { $java_source_file :
    ensure            => 'present',
    source            => $java_source_file,
    deploymentdir     => $java_install_dir,
    user              => 'root',
    cachedir          => "/home/wso2user/java-setup-${name}",
    require           => [User['wso2user'], File[$install_dir]]
  }

  file { $java_home:
    ensure            => 'link',
    target            => $java_install_dir,
    require           => Java::Setup[$java_source_file]
  }

  file { "/etc/profile.d/set_java_home.sh":
    ensure            => present,
    content           => inline_template("JAVA_HOME=${java_home}\nPATH=${java_home}/bin:\$PATH"),
    require           => File[$java_home]
  }

  package { $packages: ensure => installed }
}
