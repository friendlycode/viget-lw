#!/bin/bash
# this is run on the vagrant VM

if [ ! -e ".installed" ]
then
    touch /etc/apt/apt.conf.d/99vagrant && echo "dir::cache::archives /vagrant/apt-cache;" >> /etc/apt/apt.conf.d/99vagrant
    mkdir -p /vagrant/apt-cache/partial || echo "already made cache dir"
    mkdir -p /vagrant/make_cache || echo "already made cache dir"
    mkdir -p /vagrant/pip_cache || echo "already made pip cache"
    #mkdir -p /vagrant/viget-lw || echo "already made viget-lw dir"
    if [ ! -d /vagrant/viget-lw ]
    then
        apt-get install -y git
        git clone https://github.com/friendlycode/viget-lw.git /vagrant/viget-lw
    fi
    cp -pR /vagrant/viget-lw viget-lw
    export PIP_DOWNLOAD_CACHE="/vagrant/pip_cache"
    
    cd /home/vagrant/viget-lw
    apt-get install -y make
    make install_from_scratch
    rm /etc/apt/apt.conf.d/99vagrant
    cd /home/vagrant/
    echo "source viget-lw/venv/bin/activate" >> .bash_profile
    touch .installed
fi



