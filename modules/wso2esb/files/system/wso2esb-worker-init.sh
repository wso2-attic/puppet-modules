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
source /etc/profile.d/set_java_home.sh

prgdir=$(dirname "$0")
script_path=$(cd "$prgdir"; pwd)

local_ip=$(ip route get 1 | awk '{print $NF;exit}')
server_path=/mnt/${local_ip}
echo "Creating directory $server_path..."
mkdir -p "${server_path}"

server_name=${WSO2_SERVER}-${WSO2_SERVER_VERSION}
echo "Moving carbon server from /mnt/${server_name} to ${server_path}..."
ln -s "/mnt/${server_name}" "${server_path}/${server_name}"

axis2_xml_file_path=${server_path}/${server_name}/repository/conf/axis2/axis2.xml
secret_conf_properties_file=${server_path}/${server_name}/repository/conf/security/secret-conf.properties
password_tmp_file=${server_path}/${server_name}/password-tmp

# replace localMemberHost with local ip
function replace_local_member_host_with_ip {
    sed -i "s/\(<parameter\ name=\"localMemberHost\">\).*\(<\/parameter*\)/\1$local_ip\2/" "${axis2_xml_file_path}"
    if [[ $? == 0 ]];
        then
        echo "successfully updated localMemberHost with local ip address $local_ip"
    else
        echo "error occurred in updating localMemberHost with local ip address $local_ip"
    fi
}

# updating conf file path with server_path
function update_path {
    if [ -f "$secret_conf_properties_file" ]
        then
        sed -i "s|mnt|mnt/${local_ip}|g" "$secret_conf_properties_file"
        if [[ "$?" == 0 ]];
            then
            echo "Successfully updated keyStore identity location"
        else
            echo "Error occurred in updating keyStore identity location"
        fi
    fi
}

replace_local_member_host_with_ip

update_path

if [ ! -z "$KEY_STORE_PASSWORD" ]
    then
    # adding key-store-password to password-tmp file
    touch $password_tmp_file
    echo "$KEY_STORE_PASSWORD" >> $password_tmp_file
fi

artifact_dir='/mnt/wso2/carbon-home'
if [[ -d ${artifact_dir} ]]; then
    echo "copying artifacts at ${artifact_dir} to ${server_path}/${server_name}"
    cp -r ${artifact_dir}/* ${server_path}/${server_name}
fi

export CARBON_HOME="${server_path}/${server_name}"

# if there is an existing docker-<product_name>-<profile_name>-init.sh script, run that first
product_init_script_name="${WSO2_SERVER}-${WSO2_SERVER_PROFILE}-init.sh"
if [[ -f "${script_path}/${product_init_script_name}" ]]; then
    echo "found a init script specific to ${WSO2_SERVER_PROFILE} profile of ${WSO2_SERVER}"
    bash "${script_path}/${product_init_script_name}" || exit $?
fi

echo "Starting ${WSO2_SERVER}..."
${CARBON_HOME}/bin/wso2server.sh