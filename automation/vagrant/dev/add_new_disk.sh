set -e
set -x
if [ -f /etc/disk_added_date ]
then
   echo "disk already added so exiting."
   exit 0
fi
sudo fdisk -u /dev/sdb <<EOF
n
p
1


t
8e
w
EOF

pvcreate /dev/sdb1
vgextend vagrant-vg /dev/sdb1
lvextend -l +100%FREE /dev/vagrant-vg/root
resize2fs /dev/vagrant-vg/root

date > /etc/disk_added_date
