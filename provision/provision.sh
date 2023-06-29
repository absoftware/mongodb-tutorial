#!/bin/bash

export DOLLAR='$'
export DEBIAN_FRONTEND=noninteractive

export FILES="/sources/provision/files"

function copy_file {
    echo "copy_file \"${1}\" \"${2}\" \"${3}\" \"${4}\""
    cp "${1}" "${2}"
    chmod "${3}" "${2}"
    chown "${4}" "${2}"
}

function install_file {
    echo "install_file \"${1}\" \"${2}\" \"${3}\""
    cp "${FILES}/${1}" "${1}"
    chmod "${2}" "${1}"
    chown "${3}" "${1}"
}

update_apt_get() {
    echo "Updating apt-get"
    apt-get update -y
    apt-get upgrade -y
    apt-get install -y build-essential
    apt-get install -y net-tools
}

install_emacs() {
    echo "Installing Emacs"
    apt-get install -y emacs
    install_file /home/vagrant/.emacs 644 vagrant:vagrant
    install_file /root/.emacs 644 root:root
}

install_time_sync() {
    apt-get install -y ntp
    timedatectl set-ntp on
}

set_hostname() {
    echo "Copying hostname configuration"
    install_file /etc/hostname 644 root:root
}

install_git() {
    echo "Installing Git"
    apt-get install -y git gitk ruby
    install_file /home/vagrant/.bash_profile 644 vagrant:vagrant
    install_file /root/.bash_profile 644 root:root
}

install_mongodb() {
    echo "Installing MongoDB"
    apt-get install -y gnupg
    curl -fsSL https://pgp.mongodb.com/server-6.0.asc | gpg -o /usr/share/keyrings/mongodb-server-6.0.gpg --dearmor
    echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
    apt-get update -y
    apt-get install -y mongodb-org
    sed -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/' /etc/mongod.conf
    systemctl restart mongod
}

echo "Provisioning virtual machine..."
update_apt_get
install_emacs
install_time_sync
set_hostname
install_git
install_mongodb
