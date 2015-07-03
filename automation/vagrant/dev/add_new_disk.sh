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
vgextend vg0 /dev/sdb1
lvextend -l +100%FREE /dev/vg0/root
resize2fs /dev/vg0/root

date > /etc/disk_added_date
