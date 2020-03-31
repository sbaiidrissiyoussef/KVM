# Redhat KVM 
This repo contains a set of procedures and scripts related to KVM deployment, management, and monitoring. 
It has been tested on Redhat Entreprise Linux 8.1

### KVM deployment

Make sure you setup your yum before launching the script

```bash
mount -o loop /dev/sr0 /mnt
cp /mnt/media.repo /etc/yum.repos.d/
echo "[InstallMedia]" > /etc/yum.repos.d/media.repo
echo "name=Red Hat Enterprise Linux 8.1.0" >> /etc/yum.repos.d/media.repo
echo "gpgcheck=0" >> /etc/yum.repos.d/media.repo
echo "baseurl=file:///mnt/AppStream" >> /etc/yum.repos.d/media.repo
```

Verify the following dependencies on system
```bash
rpm -qa | grep libgusb
rpm -qa | grep avahi-glib
```
if they're not installed, download and install them as follow 
```bash
yum install libgusb-0.3.0-1.el8.x86_64.rpm avahi-glib-0.7-19.el8.x86_64.rpm
```

Launch the installation of KVM on Redhat 8.1
```bash
./setup_kvm.sh
```
