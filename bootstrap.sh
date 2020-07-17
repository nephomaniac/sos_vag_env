#!/usr/bin/env bash
# Note the default user for provisioning is likely root so ~./ is root/ not /home/$VUSER 
VUSER="vagrant"
VHOME="/home/${VUSER}"

apt-get -y update
apt-get -y install net-tools bridge-utils
apt-get -y install doxygen
apt-get -y install python3
apt-get -y install vim vim-addon-manager vim-scripts vim-syntastic sudo
apt-get -y install build-essential
apt-get -y install openvpn
apt-get -y install snmpd
apt-get -y install mtr
apt-get -y install rsync
apt-get -y install git subversion
apt-get -y install htop
apt-get -y install libncurses5-dev zlib1g-dev gawk unzip
apt-get -y install gettext
#apt-get -y install libssl-dev
apt-get -y install libssl1.0-dev
apt-get -y install iotop
apt-get -y install dos2unix
apt-get -y install cryptsetup
apt-get -y install yui-compressor
apt-get -y install node-uglify node-less
apt-get -y install libxml-parser-perl
apt-get -y install libxml2-dev
apt-get -y install lzop
apt-get -y install quilt
apt-get -y install time
apt-get -y install apache2 apache2-utils
apt-get -y install php curl php-curl php-json
apt-get -y install npm
npm install -g grunt-cli
sudo apt-get install git-lfs
# lfs install prints unrelated errors if done outside a git dir
git lfs install 2> /tmp/lfs_install.log
if [ $? -ne 0 ]; then
    cat /tmp/lfs_install.log >&2
fi

# for root
mkdir -p ~/.ssh
chmod 700 ~/.ssh
[ -f ~/.ssh/known_hosts ] || touch ~/.ssh/known_hosts && chmod 700 ~/.ssh/known_hosts

# for vagrant user
mkdir -p ${VHOME}/.ssh
chmod 700 ${VHOME}/.ssh
[ -f ${VHOME}/.ssh/known_hosts ] || touch ${VHOME}/.ssh/known_hosts && chmod 700 ${VHOME}/.ssh/known_hosts
chown -R vagrant:vagrant ${VHOME}/.ssh/

if [ ! -n "$(grep "^bitbucket.org " ~/.ssh/known_hosts)" ]; then ssh-keyscan bitbucket.org >> ~/.ssh/known_hosts 2>/dev/null; fi
if [ ! -n "$(grep "^bitbucket.org " ${VHOME}/.ssh/known_hosts)" ]; then ssh-keyscan bitbucket.org >> ${VHOME}/.ssh/known_hosts 2>/dev/null; fi
ssh -T git@bitbucket.org
if [ ! -d /opt/srg-tools ]; then
    git clone git@bitbucket.org:smartrg/srg-tools.git /opt/srg-tools
    if [ $? -ne 0 ]; then
        echo "You may need to add your keys to the ssh-agent on the host machine?
        Try this:
            eval \"$(ssh-agent -s)\"
            ssh-add ~/.ssh/id_rsa" >&2
    fi
fi
[ -d /opt/srg-tools ] && chown -R ${VUSER}:${VUSER} /opt/srg-tools/
grep smartrg-bashrc-include ${VHOME}/.bashrc 2> /dev/null || echo "source /opt/srg-tools/smartrg-bashrc-include" >> ${VHOME}/.bashrc
grep smartrg-bashrc-include ~/.bashrc 2> /dev/null || echo "source /opt/srg-tools/smartrg-bashrc-include" >> ~/.bashrc

grep "source /opt/srg-tools/sos" ${VHOME}/.bashrc 2> /dev/null ||  echo "source /opt/srg-tools/sos" >> ${VHOME}/.bashrc
grep "source /opt/srg-tools/sos" ~/.bashrc 2> /dev/null ||  echo "source /opt/srg-tools/sos" >> ~/.bashrc

