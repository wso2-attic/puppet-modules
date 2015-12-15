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
# Class: wso2ppaas
#
# This class installs WSO2 Private PaaS
#

class wso2ppaas {

  $service_code = 'wso2ppaas'
  $carbon_home = "${target}/${service_code}-${version}"

  # hiera lookup
  $datasources = hiera('datasources')

  $service_templates = [
    "${version}/conf/axis2/axis2.xml",
    "${version}/conf/carbon.xml",
    "${version}/conf/registry.xml",
    "${version}/conf/datasources/greg-datasources.xml"
  ]

  $common_templates = [
    "${version}/conf/user-mgt.xml",
    "${version}/conf/datasources/master-datasources.xml",
    "${version}/conf/tomcat/catalina-server.xml"
  ]

  $securevault_templates = [
    "${version}/conf/security/secret-conf.properties",
    "${version}/conf/security/cipher-text.properties"
  ]

  tag($service_code)

  wso2greg::clean { $service_code:
    mode   => $maintenance_mode,
    target => $carbon_home,
  }

  wso2greg::initialize { $service_code:
    repo      => $package_repo,
    version   => $version,
    mode      => $maintenance_mode,
    service   => $service_code,
    local_dir => $local_package_dir,
    owner     => $owner,
    target    => $target,
    require   => Clean[$service_code],
  }

  wso2greg::deploy { $service_code:
    security => true,
    owner    => $owner,
    group    => $group,
    target   => $carbon_home,
    require  => Initialize[$service_code],
  }

  wso2greg::push_templates {
    $service_templates:
      owner     => $owner,
      group     => $group,
      target    => $carbon_home,
      directory => $service_code,
      notify    => Service["${service_code}"],
      require   => Deploy[$service_code];

    $common_templates:
      owner     => $owner,
      group     => $group,
      target    => $carbon_home,
      directory => 'wso2base',
      notify    => Service["${service_code}"],
      require   => Deploy[$service_code];
  }

  if $securevault {
    wso2greg::push_templates { $securevault_templates:
      target    => $carbon_home,
      directory => 'wso2base',
      require   => Deploy[$service_code];
    }
  }

  file { "${carbon_home}/bin/wso2server.sh":
    ensure  => present,
    owner   => $owner,
    group   => $group,
    mode    => '0755',
    content => template("${service_code}/${version}/wso2server.sh.erb"),
    require => Deploy[$service_code];
  }

  file { "/etc/init.d/${service_code}":
    ensure  => present,
    owner   => $owner,
    group   => $group,
    mode    => '0755',
    content => template("${service_code}/${version}/${service_code}.erb")
  }

  service { "${service_code}":
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    enable     => true,
    require    => [
      Initialize[$service_code],
      Deploy[$service_code],
      Push_templates[$service_templates],
      File["${carbon_home}/bin/wso2server.sh"],
      File["/etc/init.d/${service_code}"]
      ];
  }
}
