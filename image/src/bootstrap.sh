#!/bin/sh

set -x

setup-keymap gb gb

setup-interfaces -i <<EOF
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp
EOF

echo "root:alpine" | chpasswd

setup-timezone -z UTC
setup-apkrepos -1
setup-ntp -c chrony

apk add --quiet openssh
rc-update --quiet add sshd default
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

rc-update --quiet add networking boot
rc-update --quiet add urandom boot

ERASE_DISKS=/dev/vda setup-disk -s 0 -m sys /dev/vda

reboot
