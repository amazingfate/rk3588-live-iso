LB_IMAGE_NAME="ubuntu-jammy-live" lb config \
	--architecture arm64 \
	--archive-areas 'main restricted universe multiverse' \
	--parent-archive-areas 'main restricted universe multiverse' \
	--debian-installer-distribution jammy \
	--distribution jammy \
	--distribution-chroot jammy \
	--distribution-binary jammy\
	--apt-recommends false \
	--bootloaders grub-efi \
	--compression xz \
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

echo "deb https://apt.armbian.com jammy main jammy-utils jammy-desktop" > config/archives/live.list.chroot
echo "deb https://ppa.launchpadcontent.net/liujianfeng1994/panfork-mesa/ubuntu/ jammy main" >> config/archives/live.list.chroot
echo "deb https://ppa.launchpadcontent.net/liujianfeng1994/rockchip-multimedia/ubuntu/ jammy main" >> config/archives/live.list.chroot
echo "deb https://apt.armbian.com jammy main jammy-utils jammy-desktop" > config/archives/live.list.binary
echo "deb https://ppa.launchpadcontent.net/liujianfeng1994/panfork-mesa/ubuntu/ jammy main" >> config/archives/live.list.binary
echo "deb https://ppa.launchpadcontent.net/liujianfeng1994/rockchip-multimedia/ubuntu/ jammy main" >> config/archives/live.list.binary

wget https://raw.githubusercontent.com/armbian/build/main/config/armbian.key
gpg --dearmor < armbian.key > armbian.gpg
curl -S "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x0B2F0747E3BD546820A639B68065BE1FC67AABDE" |gpg --batch --yes --dearmor --output "launchpad-liujianfeng1994.gpg"
cp armbian.gpg config/archives/armbian.key.binary
cp launchpad-liujianfeng1994.gpg config/archives/launchpad-liujianfeng1994.key.binary
cp armbian.gpg config/archives/armbian.key.chroot
cp launchpad-liujianfeng1994.gpg config/archives/launchpad-liujianfeng1994.key.chroot

wget https://raw.githubusercontent.com/armbian/build/main/config/cli/jammy/main/packages -O config/package-lists/armbian-cli.list.chroot_install
wget https://raw.githubusercontent.com/armbian/build/main/config/cli/common/main/packages.additional -O config/package-lists/armbian-cli-addtional.list.chroot_install
wget https://raw.githubusercontent.com/armbian/build/main/config/desktop/jammy/environments/gnome/config_base/packages -O config/package-lists/armbian-gnome.list.chroot_install
sed -i "/lightdm/d" config/package-lists/armbian-gnome.list.chroot_install
sed -i "/openssh-server/d" config/package-lists/armbian-cli.list.chroot_install
cp additional-packages config/package-lists/additional-packages.list.chroot_install
cp additional-packages-live.jammy config/package-lists/additional-packages.list.chroot_live
mv config/package-lists/live.list.chroot config/package-lists/live.list.chroot_live

mkdir -p config/includes.chroot_after_packages/etc/netplan
cp networkmanager.yaml config/includes.chroot_after_packages/etc/netplan

cp customize-chroot.hook.chroot config/hooks/live
mkdir -p config/includes.chroot_after_packages/etc/grub.d/
cp 10_linux config/includes.chroot_after_packages/etc/grub.d/
