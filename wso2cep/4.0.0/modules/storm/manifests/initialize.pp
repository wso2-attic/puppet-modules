# ----------------------------------------------------------------------------
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
# ----------------------------------------------------------------------------
#
# Initializing the deployment

define storm::initialize ($repo, $version, $local_dir, $target, $owner,) {
  exec {
    "creating_target_for_${name}":
      path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      unless  => "test -d ${target}",
      command => "mkdir -p ${target}";

    "creating_local_package_repo_for_${name}":
      path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/java/bin/',
      unless  => "test -d ${local_dir}",
      command => "mkdir -p ${local_dir}";

    "downloading_apache-storm-${version}.zip_for_${name}":
      path      => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      cwd       => $local_dir,
      unless    => "test -f ${local_dir}/apache-storm-${version}.zip",
      command   => "wget -q ${repo}/apache-storm-${version}/apache-storm-${version}.zip",
      logoutput => 'on_failure',
      creates   => "${local_dir}/apache-storm-${version}.zip",
      timeout   => 0,
      require   => Exec["creating_local_package_repo_for_${name}", "creating_target_for_${name}"];

    "extracting_apache-storm-${version}.zip_for_${name}":
      path      => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      cwd       => $target,
      unless    => "test -d ${target}/apache-storm-${version}.zip/repository",
      command   => "unzip ${local_dir}/apache-storm-${version}.zip",
      logoutput => 'on_failure',
      creates   => "${target}/apache-storm-${version}/repository",
      timeout   => 0,
      notify    => Exec["setting_permission_for_${name}"],
      require   => Exec["downloading_apache-storm-${version}.zip_for_${name}"];

    "setting_permission_for_${name}":
      path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      cwd         => $target,
      command     => "chown -R ${owner}:${owner} ${target}/apache-storm-${version} ;
                    chmod -R 755 ${target}/apache-storm-${version}",
      logoutput   => 'on_failure',
      timeout     => 0,
      refreshonly => true,
      require     => Exec["extracting_apache-storm-${version}.zip_for_${name}"];
  }
}
