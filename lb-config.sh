lb config \
	--architecture arm64 \
	--bootstrap-qemu-arch arm64 \
	--bootstrap-qemu-static /usr/bin/qemu-aarch64-static \
	--archive-areas 'main restricted universe multiverse' \
	--parent-archive-areas 'main restricted universe multiverse' \
	--debian-installer-distribution jammy \
	--distribution jammy \
	--distribution-chroot jammy \
	--distribution-binary jammy\
	--bootloaders grub-efi \
	--keyring-packages "ubuntu-keyring initramfs-tools" \
	--linux-packages "linux-image linux-dtb" \
	--linux-flavours "legacy-rk35xx" \
	--parent-mirror-bootstrap "http://ports.ubuntu.com" \
	--parent-mirror-chroot "http://ports.ubuntu.com" \
	--parent-mirror-chroot-security "http://ports.ubuntu.com" \
	--parent-mirror-binary "http://ports.ubuntu.com" \
	--parent-mirror-binary-security "http://ports.ubuntu.com" \
	--parent-mirror-debian-installer "http://ports.ubuntu.com" \
	--mirror-bootstrap "http://ports.ubuntu.com" \
	--mirror-chroot "http://ports.ubuntu.com" \
	--mirror-chroot-security "http://ports.ubuntu.com" \
	--mirror-binary "http://ports.ubuntu.com" \
	--mirror-binary-security "http://ports.ubuntu.com" \
	--mirror-debian-installer "http://ports.ubuntu.com"

echo "deb https://beta.armbian.com jammy main jammy-utils jammy-desktop" > config/archives/live.list.chroot
echo "deb https://ppa.launchpadcontent.net/liujianfeng1994/panfork-mesa/ubuntu/ jammy main" >> config/archives/live.list.chroot
echo "deb https://ppa.launchpadcontent.net/liujianfeng1994/rockchip-multimedia/ubuntu/ jammy main" >> config/archives/live.list.chroot
echo "deb https://beta.armbian.com jammy main jammy-utils jammy-desktop" > config/archives/live.list.binary

wget https://raw.githubusercontent.com/armbian/build/main/config/armbian.key
gpg --dearmor < armbian.key > armbian.gpg
curl -S "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x0B2F0747E3BD546820A639B68065BE1FC67AABDE" |gpg --batch --yes --dearmor --output "launchpad-liujianfeng1994.gpg"
cp armbian.gpg config/archives/armbian.key.binary
cp launchpad-liujianfeng1994.gpg config/archives/launchpad-liujianfeng1994.key.binary
cp armbian.gpg config/archives/armbian.key.chroot
cp launchpad-liujianfeng1994.gpg config/archives/launchpad-liujianfeng1994.key.chroot

wget https://raw.githubusercontent.com/armbian/build/main/config/cli/common/main/packages -O config/package-lists/armbian-cli.list.chroot
wget https://raw.githubusercontent.com/armbian/build/main/config/cli/common/main/packages.additional -O config/package-lists/armbian-cli-addtional.list.chroot
wget https://raw.githubusercontent.com/armbian/build/main/config/desktop/jammy/environments/gnome/config_base/packages -O config/package-lists/armbian-gnome.list.chroot
sed -i "/lightdm/d" config/package-lists/armbian-gnome.list.chroot
cp additional-packages config/package-lists/additional-packages.list.chroot
