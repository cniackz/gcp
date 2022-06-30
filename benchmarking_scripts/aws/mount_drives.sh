#!/bin/bash
#set -x

mount_device(){
DEVICE="/dev/$1"
VOLUME_NAME=$2
MOUNT_POINT=$3

format_device() {
  echo "Formatting $DEVICE"
  mkfs.xfs -imaxpct=25 -f -L $MOUNT_POINT $DEVICE
}
check_device() {
  if [ -f "/etc/systemd/system/$MOUNT_POINT.mount" ]; then
    echo "Device $MOUNT_POINT ($DEVICE) exists"
    echo "No actions required..."
  else
    echo "$MOUNT_POINT.mount was not found, creating volume"
    format_device
  fi
}
check_mount() {
  if [ -f "/etc/systemd/system/$MOUNT_POINT.mount" ]; then
    echo "Found $MOUNT_POINT.mount in /etc/systemd/system/"
    echo "No actions required..."
  else
    echo "$MOUNT_POINT.mount was not found in /etc/systemd/system/ adding it"
    mkdir -p /$MOUNT_POINT
    
    echo "[Unit]" >> /etc/systemd/system/$MOUNT_POINT.mount
    echo "Description=Mount System Backups Directory" >> /etc/systemd/system/$MOUNT_POINT.mount
    echo "" >> /etc/systemd/system/$MOUNT_POINT.mount
    echo "[Mount]" >> /etc/systemd/system/$MOUNT_POINT.mount
    echo "What=LABEL=$MOUNT_POINT" >> /etc/systemd/system/$MOUNT_POINT.mount
    echo "Where=/$MOUNT_POINT" >> /etc/systemd/system/$MOUNT_POINT.mount
    echo "Type=xfs" >> /etc/systemd/system/$MOUNT_POINT.mount
    echo "Options=noatime" >> /etc/systemd/system/$MOUNT_POINT.mount
    echo "" >> /etc/systemd/system/$MOUNT_POINT.mount
    echo "[Install]" >> /etc/systemd/system/$MOUNT_POINT.mount
    echo "WantedBy=multi-user.target" >> /etc/systemd/system/$MOUNT_POINT.mount

    systemctl enable $MOUNT_POINT.mount
    systemctl start $MOUNT_POINT.mount
  fi
}
LABEL=$(blkid -L $VOLUME_NAME)
check_device
check_mount
systemctl daemon-reload
}

for i in `lsblk -d | grep -v NAME | grep -v nvme0 | awk '{print $1}'`; do
  mnt_point=`echo $i | sed -e 's/nvme/disk/g' -e 's/n1//g'`
  mount_device $i $i $mnt_point;
done
