SHELL = /bin/bash
IMAGE = custom-archiso-builder
CONTAINER = custom-archiso-builder
VM = custom-archiso-test

all: clean build

clean:
	sudo rm -f *.{log,vdi,iso}
	docker kill $(CONTAINER) || true
	docker rm $(CONTAINER) || true
	docker image rm $(IMAGE) || true

build: clean
	( \
		docker build -t $(IMAGE) . && \
		docker run \
		--name=$(CONTAINER) \
		--privileged \
		--mount type=bind,source=${PWD},target=/usr/share/archiso/configs/releng/out \
		$(IMAGE) && \
		mv archlinux-*.iso archlinux.iso \
	) | tee build.log

test:
	VBoxManage controlvm $(VM) poweroff || true
	VBoxManage unregistervm --delete $(VM) || true
	rm -f $(VM).vdi
	VBoxManage createhd --filename $(VM).vdi --size 16384
	VBoxManage createvm --name $(VM) --ostype ArchLinux_64 --register
	VBoxManage storagectl $(VM) --name "SATA Controller" --add sata --controller IntelAHCI
	VBoxManage storageattach $(VM) --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium $(VM).vdi
	VBoxManage storagectl $(VM) --name "IDE Controller" --add ide
	VBoxManage storageattach $(VM) --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium archlinux.iso
	VBoxManage modifyvm $(VM) --ioapic on
	VBoxManage modifyvm $(VM) --boot1 dvd --boot2 disk --boot3 none --boot4 none
	VBoxManage modifyvm $(VM) --memory 1024 --vram 128
	VBoxManage startvm $(VM)
	VBoxManage controlvm $(VM) setvideomodehint 1600 1200 32
