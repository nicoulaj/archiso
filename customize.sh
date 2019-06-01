#!/bin/bash

# add repos
aur_repo=${PWD}/var/lib/pacman/aur
cat << EOF >> pacman.conf
[archzfs]
SigLevel = Optional TrustAll
Server = http://archzfs.com/\$repo/x86_64

[AUR]
SigLevel = Optional TrustAll
Server = file://${aur_repo}
EOF

# remove packages
sed -i '/grml-zsh-config/d' packages.x86_64

# add packages
cat << EOF >> packages.x86_64
archzfs-linux
zfs-linux-headers
pacman-contrib
terminus-font
pkgfile
elinks
dfc
ncdu
tmux
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
source-highlight
grc
diff-so-fancy
EOF

# build and add AUR packages
mkdir -p ${aur_repo}
mkdir /.{cache,terminfo} && chmod -R o+rw /.{cache,terminfo}
for package in fbterm-git; do
  pushd $PWD
  cd /tmp
  git clone --depth 1 https://aur.archlinux.org/${package}
  chmod -R o+rw ${package}
  cd ${package}
  su nobody -s /bin/sh -c 'makepkg -s --noconfirm --noprogressbar'
  mv -v *.pkg.* ${aur_repo}/
  popd
  echo ${package} >> packages.x86_64
done
repo-add ${aur_repo}/AUR.db.tar.gz ${aur_repo}/*.pkg.*

# enable pacman colors
sed -i 's|^#Color|Color|' pacman.conf

# set timezone
sed -i 's|zoneinfo/UTC|zoneinfo/Europe/Paris|' airootfs/root/customize_airootfs.sh

# set keymap and console font
cat << EOF >  airootfs/etc/vconsole.conf
KEYMAP=fr
FONT=ter-116n
EOF

# add dotfiles
curl -Ls https://github.com/nicoulaj/dotfiles/archive/master.tar.gz | tar xvz -C airootfs/root/ --strip-components=1

# set terminal to fbterm
sed -i 's|linux|fbterm|' airootfs/etc/systemd/system/getty@tty1.service.d/autologin.conf
