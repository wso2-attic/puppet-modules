#
# Copyright (c) 2015, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# ----------------------------------------------------------------------------
#
# Class cep::params

# This class manages CEP parameters
#
# Parameters:
#
# Usage: Uncomment the variable and assign a value to override the nodes.pp value
#
#

class cep::params {
   $package_repo 			= hiera('package_repo', 'http://svn.wso2.org/repos/wso2/people/suho/packs/cep/4.0.0/RC4')
   $local_package_dir 		= hiera('local_package_dir', '/mnt/packs')
   
   $svn_url 	 = 'svn://192.168.57.169/cepdepsync'
   $svn_admin 	 = 'admin'
   $svn_password = 'admin'
}
