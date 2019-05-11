#!/bin/sh

cat << EOF >> packages.x86_64
dfc
ncdu
EOF

sed -i 's|isouser|nicoulaj|' airootfs/etc/systemd/system/getty@tty1.service.d/autologin.conf
