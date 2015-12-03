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
# Creates a worker node by removing all unnecessary jars. Also this will remove default services of the super tenant.

define apimanager::create_worker ($target) {
  exec {
    "remove_default_deployment_from ${name}":
      path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
      onlyif  => "test -d ${target}/repository/deployment/server",
      command => "rm -rf ${target}/repository/deployment/server/* ;
                          rm -rf ${target}/repository/deployment/server/.svn";

    "remove_worker_jars_from_${name}":
      path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
      command => "find ${target}/repository/components/plugins \
                          -not \\( -iname \"org.wso2.carbon.cloud.gateway.agent.stub*\" \\) \
                                   -iname \"org.wso2.carbon.*ui_*\" -o \
                                   -iname \"org.wso2.carbon.*stub_*\" -o \
                                   -iname \"org.wso2.stratos.*ui_*\" -o \
                                   -iname \"org.wso2.stratos.*stub_*\" -o \
                                   -iname \"org.jaggeryjs.*ui_*\" -o \
                                   -iname \"org.jaggeryjs.*stub_*\" -o \
                                   -iname \"org.wso2.carbon.ui.menu.*\" -o \
                                   -iname \"org.wso2.*styles_*\" -o \
                                   -iname \"org.wso2.carbon.authenticator.proxy_*\" | xargs rm -f ",
  }
}
