#!/bin/bash
# ------------------------------------------------------------------------
#
# Copyright 2016 WSO2, Inc. (http://wso2.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License

# ------------------------------------------------------------------------
set -e

local_ip=$(ip route get 1 | awk '{print $NF;exit}')
server_path=/mnt/${local_ip}
server_name=${WSO2_SERVER}-${WSO2_SERVER_VERSION}
broker_xml_file_path=${server_path}/${server_name}/repository/conf/broker.xml

# replace thriftServerHost with local ip
sed -i "s/\(<thriftServerHost>\).*\(<\/thriftServerHost*\)/\1$local_ip\2/" "${broker_xml_file_path}"
if [[ $? == 0 ]];
    then
    echo "successfully updated thriftServerHost with local ip address $local_ip"
else
    echo "error occurred in updating thriftServerHost with local ip address $local_ip"
fi

