#!/bin/bash

SHARE_NAME="mc-ec-backups"
OWNER_USER_NAME=""
OWNER_GROUP_NAME=""

sudo mkdir /vault/subvol-114-disk-0/nfs/${SHARE_NAME}
sudo mkdir /export/${SHARE_NAME}

ehco "/vault/subvol-114-disk-0/nfs/${SHARE_NAME}  /export/${SHARE_NAME}  none    bind,defaults,nofail,x-systemd.requires=zfs-mount.service   0 0" >> /etc/fstab
echo ""

sudo chown -R ${OWNER_USER_NAME}:${OWNER_GROUP_NAME} /vault/subvol-114-disk-0/nfs/${SHARE_NAME}

sudo exportfs -ra