FROM archlinux/base

RUN mkdir /run/shm && \
    pacman-key --init && \
    pacman-key --populate archlinux && \
    pacman --noconfirm -Sy reflector rsync && \
    reflector --verbose --latest 20 --sort rate --save /etc/pacman.d/mirrorlist && \
    pacman --noconfirm -Syu && \
    pacman --noconfirm -Sy --needed \
      git \
      make \
      curl \
      grep \
      file \
      arch-install-scripts \
      squashfs-tools \
      libisoburn \
      btrfs-progs \
      dosfstools \
      lynx \
      mkinitcpio-nfs-utils && \
    git clone --depth 1 git://projects.archlinux.org/archiso.git && \
    make -C archiso install

WORKDIR /usr/share/archiso/configs/releng

ADD customize.sh .

RUN ./customize.sh

CMD ["./build.sh","-v"]
