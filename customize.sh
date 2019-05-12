#!/bin/bash

# remove packages
sed -i '/grml-zsh-config/d' packages.x86_64

# add packages
cat << EOF >> packages.x86_64
pacman-contrib
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
mkdir /archiso-aur-repo
cat << EOF >> pacman.conf
[archiso-aur-repo]
SigLevel = Optional TrustAll
Server = file:///archiso-aur-repo
EOF
mkdir /.{cache,terminfo} && chmod -R o+rw /.{cache,terminfo}
for package in fbterm-git; do
  pushd $PWD
  cd /tmp
  git clone --depth 1 https://aur.archlinux.org/${package}
  chmod -R o+rw ${package}
  cd ${package}
  su nobody -s /bin/sh -c 'makepkg -s --noconfirm --noprogressbar'
  mv -v *.pkg.* /archiso-aur-repo/
  popd
  echo ${package} >> packages.x86_64
done
repo-add /archiso-aur-repo/archiso-aur-repo.db.tar.gz /archiso-aur-repo/*.pkg.*

# enable pacman colors
sed -i 's|^#Color|Color|' pacman.conf

# set keymap
echo KEYMAP=fr > airootfs/etc/vconsole.conf

# set timezone
sed -i 's|zoneinfo/UTC|zoneinfo/Europe/Paris|' airootfs/root/customize_airootfs.sh

# add dotfiles
curl -Ls https://github.com/nicoulaj/dotfiles/archive/master.tar.gz | tar xvz -C airootfs/root/ --strip-components=1

# set terminal to fbterm
sed -i 's|linux|fbterm|' airootfs/etc/systemd/system/getty@tty1.service.d/autologin.conf
