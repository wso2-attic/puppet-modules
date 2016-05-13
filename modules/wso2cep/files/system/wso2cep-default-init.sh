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
event_processor_xml_file_path=${server_path}/${server_name}/repository/conf/event-processor.xml

# replace eventSync/hostName
sed -i "/<eventSync>/,/<\/eventSync>/ s|<hostName>[0-9a-z.]\{1,\}</hostName>|<hostName>${local_ip}</hostName>|g" ${event_processor_xml_file_path}
echo "replaced eventSync/hostName with local ip ${local_ip}"

# replace management/hostName
sed -i "/<management>/,/<\/management>/ s|<hostName>[0-9a-z.]\{1,\}</hostName>|<hostName>${local_ip}</hostName>|g" ${event_processor_xml_file_path}
echo "replaced management/hostName with local ip ${local_ip}"

# replace presentation/hostName
sed -i "/<presentation>/,/<\/presentation>/ s|<hostName>[0-9a-z.]\{1,\}</hostName>|<hostName>${local_ip}</hostName>|g" ${event_processor_xml_file_path}
echo "replaced presentation/hostName with local ip ${local_ip}"