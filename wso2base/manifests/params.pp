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

class wso2base::params {
  $package_repo = hiera('package_repo', 'https://packs.example.com/packages')
  $depsync_svn_repo = hiera('depsync_svn_repo', 'https://svn.example.com/repo')
  $local_package_dir = hiera('local_package_dir', '/mnt/packs')
  $java_home = hiera('java_home', '/opt/java')
  $packages = hiera('packages', 'unzip')

  $domain = hiera('domain', 'example.com')

  # Service subdomains
  $af_subdomain = hiera('af_subdomain', 'apps')
  $as_subdomain = hiera('as_subdomain', 'appserver')
  $ss_subdomain = hiera('ss_subdomain', 'storage')
  $is_subdomain = hiera('is_subdomain', 'identity')
  $ts_subdomain = hiera('ts_subdomain', 'task')
  $am_subdomain = hiera('am_subdomain', 'api')
  $appm_subdomain = hiera('appm_subdomain', 'appm')
  $mb_subdomain = hiera('mb_subdomain', 'messaging')
  $bam_subdomain = hiera('bam_subdomain', 'monitor')
  $store_subdomain = hiera('store_subdomain', 'store')
  $pubstore_subdomain = hiera('pubstore_subdomain', 'pubstore')
  $publisher_subdomain = hiera('publisher_subdomain', 'publisher')
  $bps_subdomain = hiera('bps_subdomain', 'process')
  $brs_subdomain = hiera('brs_subdomain', 'brs')
  $gateway_subdomain = hiera('gateway_subdomain', 'gateway')
  $gatewaymgt_subdomain = hiera('gatewaymgt_subdomain', 'gateway')
  $keymanager_subdomain = hiera('keymanager_subdomain', 'keymanager')
  $governance_subdomain = hiera('governance_subdomain', 'greg')
  $analyzer_subdomain = hiera('analyzer_subdomain', 'analyzer')
  $esb_subdomain = hiera('esb_subdomain', 'esb')
  $task_subdomain = hiera('task_subdomain', 'task')
  $ues_subdomain = hiera('ues_subdomain', 'dashboards')

  $admin_username = hiera('admin_username', 'admin')
  $admin_password = hiera('admin_password', 'admin')
  $admin_password_enc = hiera('admin_password_enc', '')

  $svn_user = 'wso2'
  $svn_password = hiera('svn_password', 'wso2')

  $carbondb_password = hiera('carbondb_password', 'wso2carbon')
  $carbondb_password_enc = hiera('carbondb_password_enc', '')
  $truststore_password = hiera('truststore_password', 'wso2carbon')
  $truststore_password_enc = hiera('truststore_password_enc', '')
  $keystore_password = hiera('truststore_password_enc', 'wso2carbon')
  $keystore_password_enc = hiera('truststore_password_enc', '')

  $mysql_server = hiera('mysql_server', "mysql.%{domain}")

  # Database details
  $config_database = hiera('config_database', {
    'hostname'     => "$mysql_server",
    'database'     => '',
    'username'     => 'ConfigDBUser',
    'password'     => 'ConfigDBUserPass',
    'password_enc' => ""
  }
  )

  $userstore_database = hiera('userstore_database', {
    'hostname'     => "$mysql_server",
    'database'     => 'dbUserstore',
    'username'     => 'UserstoreUser',
    'password'     => 'UserstoreUserPass',
    'password_enc' => ""
  }
  )

  $registry_database = hiera('registry_database', {
    'hostname'     => "$mysql_server",
    'database'     => 'dbGovernance',
    'username'     => 'GovernanceUser',
    'password'     => 'GovernanceUserPass',
    'password_enc' => ""
  }
  )

}
