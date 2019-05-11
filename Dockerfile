FROM archlinux/base
MAINTAINER Julien Nicoulaud <julien.nicoulaud@gmail.com>

RUN pacman-key --init && \
    pacman-key --populate archlinux && \
    pacman --noconfirm -Sy reflector && \
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

RUN sed -i 's|isouser|nicoulaj|' airootfs/etc/systemd/system/getty@tty1.service.d/autologin.conf

CMD ["./build.sh","-v"]
