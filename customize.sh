#!/bin/sh

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

# enable pacman colors
sed -i 's|^#Color|Color|' pacman.conf

# set keymap
echo KEYMAP=fr > airootfs/etc/vconsole.conf

# set timezone
sed -i 's|zoneinfo/UTC|zoneinfo/Europe/Paris|' airootfs/root/customize_airootfs.sh

# add dotfiles
curl -Ls https://github.com/nicoulaj/dotfiles/archive/master.tar.gz | tar xvz -C airootfs/root/ --strip-components=1
