#!/bin/bash

## Make sure you setup your yum before launching the script
:'
 mount -o loop /dev/sr0 /mnt
 cp /mnt/media.repo /etc/yum.repos.d/
 echo "[InstallMedia]" > /etc/yum.repos.d/media.repo
 echo "name=Red Hat Enterprise Linux 8.1.0" >> /etc/yum.repos.d/media.repo
 echo "gpgcheck=0" >> /etc/yum.repos.d/media.repo
 echo "baseurl=file:///mnt/AppStream" >> /etc/yum.repos.d/media.repo
'

## Verify operating system configuration

check_prereq()
{
    hostname_f=$(hostname -f)
    hostname_s=$(hostname -s)
    ip=$(ifconfig -a | head -2 | tail -1 | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | head -1)
    timezone=$(timedatectl | grep "Time zone")
    dat=$(date)
    firewall=$(systemctl status firewalld | grep Active | cut -f2 -d':')
    selinux=$(cat /etc/selinux/config | grep ^SELINUX= |cut -f2 -d'=')

    echo " "; echo " ";
    echo " ## Full Hostname                 :       $hostname_f "
    echo " ## Short Hostname                        :       $hostname_s "
    echo " ## IP Adresses                           :       "

    echo " "; echo " ---------      IP ADDRESSES       ------- "; echo " "
    tput setaf 1; ifconfig | grep -E "inet ";tput sgr0;
    echo " "; echo " -------------------------------------- "; echo " "


    echo " ## List Host File /etc/hosts             :       " ;

    echo " "; echo " ---------      HOST FILE       ------- "; echo " "
    tput setaf 1; cat /etc/hosts;tput sgr0;
    echo " "; echo " -------------------------------------- "; echo " "

    echo " ## Check Timezone                        :$timezone "
    echo " ## Check Current Date                    :       $dat      "
    echo " ## Check SELINUX Status          :       $selinux  "
    echo " ## Check Space Info                      :       ";

    echo " "; echo " ---------      SPACE INFO      ------- "; echo " "
    tput setaf 1; df -h | grep -v "tmp";tput sgr0;
    echo " "; echo " -------------------------------------- "; echo " "

    echo " ## Check Mounted Devices                      :       ";

    echo " "; echo " ---------      SPACE INFO      ------- "; echo " "
    tput setaf 1; lsblk ;tput sgr0;
    echo " "; echo " -------------------------------------- "; echo " "

    echo " ## Check Firewall Status         :       $firewall "

    echo " ## Check CPU                                 :       ";

    echo " "; echo " ---------      CPU INFO      ------- "; echo " "
    tput setaf 1; lscpu ;tput sgr0;
    echo " "; echo " -------------------------------------- "; echo " "

    echo " "; echo " ";
}


## Installing KVM 

install_kvm()
{
    echo " ## Updating packages ";
    sudo yum update -y &>/dev/null

    echo " ## Installing KVM packages ";
    dnf install qemu-kvm qemu-img libvirt virt-install libvirt-client virt-manager network-scripts xorg-x11-xauth xorg-x11-fonts-* xorg-x11-utils -y &>/dev/null

    echo " ## Verify KVM on kernel "
    echo " "
    tput setaf 1; lsmod | grep kvm ;tput sgr0;
    echo " "

    echo " ## Starting services "
    systemctl enable libvirtd
    systemctl start libvirtd

    echo " ## Installation completed !"

}

## MAIN

check_prereq | more

read -p "Proceed with this configuration ? [ y,n ] : " doit

if [[ $doit == "Y" || $doit == "y" ]]; then

    install_kvm
        
else
        echo "Exiting ... "
        exit
fi

