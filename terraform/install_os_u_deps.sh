#!/bin/bash

function create_user {
    username="$1"
    password="$2"
    public_key="$3"
    private_key="$4"
    
    adduser --disabled-password --gecos "test" "$username"
    usermod -aG sudo "$username"
    if [[ "$password" != "" ]];then
        echo -e "$password\n$password" | passwd "$username"
        sed -i 's|[#]*PasswordAuthentication no|PasswordAuthentication yes|g' /etc/ssh/sshd_config
    fi
    if [[ "$public_key" != "" ]];then
        umask 0077
        mkdir -p /home/$username/.ssh
        echo "$public_key" >> /home/$username/.ssh/authorized_keys
        chown $username /home/$username/.ssh
        chown $username /home/$username/.ssh/authorized_keys
    fi
    if [[ "$private_key" != "" ]];then
        echo "$private_key" > /home/$username/ssh_private_key
        chown $username /home/$username/ssh_private_key
    fi
    systemctl restart sshd
}

apt update
apt install -y nmap curl nginx
service ufw stop
ufw disable

#set hostname
if [[ "${env_aws}" == "true" ]];then
    hostnamectl set-hostname "${host_name}"
    sed -i 's/preserve_hostname: false/preserve_hostname: true/g' /etc/cloud/cloud.cfg
fi

create_user "${new_user_a}" "${user_password}" "${user_key}" "${user_private_key}"
create_user "${new_user_b}" "${user_password}" "${user_key}" "${user_private_key}"

