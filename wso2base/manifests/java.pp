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
# Class to manage Java installation.

class wso2base::java (
  $java_install_dir,
  $java_source_file,
  $wso2_user,
  $java_home
) {

  ensure_resource('file', $java_install_dir, {
    ensure  => 'directory',
  })

  # Module 7terminals-java is used to install Java at Puppet Forge
  # Puppet Forge URL: https://forge.puppetlabs.com/7terminals/java
  java::setup { $java_source_file :
    ensure            => 'present',
    source            => $java_source_file,
    deploymentdir     => $java_install_dir,
    user              => 'root',
    cachedir          => "/home/${wso2_user}/java-setup-${name}",
    require           => File[$java_install_dir]
  }

  # create a symlink for Java deployment
  file { $java_home:
    ensure            => 'link',
    target            => $java_install_dir,
    require           => Java::Setup[$java_source_file]
  }

  # set JAVA_HOME environment variable and include JAVA_HOME/bin in PATH for all users
  file { "/etc/profile.d/set_java_home.sh":
    ensure            => present,
    content           => inline_template("JAVA_HOME=${java_home}\nPATH=${java_home}/bin:\$PATH"),
    require           => File[$java_home]
  }
}
