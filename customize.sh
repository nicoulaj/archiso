#!/bin/sh

# add packages
cat << EOF >> packages.x86_64
pacman-contrib
pkgfile
links
dfc
ncdu
fzf
ack
i7z
htop
iotop
powertop
iperf3
ranger
nnn
sshfs
wol
neovim
zsh-autosuggestions
zsh-history-substring-search
zsh-syntax-highlighting
EOF

# enable pacman colors
sed -i 's|^#Color|Color|' pacman.conf

# change autologin user
sed -i 's|isouser|nicoulaj|' airootfs/etc/systemd/system/getty@tty1.service.d/autologin.conf

# set keymap
echo KEYMAP=fr > airootfs/etc/vconsole.conf

# dotfiles
curl -Ls https://github.com/nicoulaj/dotfiles/archive/master.tar.gz | tar xvz -C airootfs/root/ --strip-components=1
