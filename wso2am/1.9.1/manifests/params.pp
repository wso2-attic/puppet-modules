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

class apimanager::params inherits wso2base::params {
  # API Mgt databases
  $apimgt_database = hiera('apimgt_database', {
    'hostname'     => "$wso2base::params::mysql_server",
    'database'     => 'dbApiMgt',
    'username'     => 'ApiMgtUser',
    'password'     => 'ApiMgtUserPass',
    'password_enc' => ""
  }
  )

  $apistats_database = hiera('apistats_database', {
    'hostname'     => "$wso2base::params::mysql_server",
    'database'     => 'dbApiStatus',
    'username'     => 'ApiStatuUser',
    'password'     => 'ApiStatuUserPass',
    'password_enc' => ""
  }
  )
}
