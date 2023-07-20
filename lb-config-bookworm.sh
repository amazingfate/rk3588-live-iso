LB_IMAGE_NAME="debian-bookworm-live" lb config \
	--architecture arm64 \
	--bootstrap-qemu-arch arm64 \
	--bootstrap-qemu-static /usr/bin/qemu-aarch64-static \
	--archive-areas 'contrib main non-free non-free-firmware' \
	--parent-archive-areas 'contrib main non-free non-free-firmware' \
	--debian-installer-distribution bookworm \
	--distribution bookworm \
	--distribution-chroot bookworm \
	--distribution-binary bookworm\
	--bootloaders grub-efi \
	--keyring-packages "debian-archive-keyring ca-certificates fontconfig-config initramfs-tools" \
	--linux-packages "linux-image linux-dtb" \
	--linux-flavours "legacy-rk35xx" \
	--parent-mirror-bootstrap "http://ftp.debian.org/debian/" \
	--parent-mirror-chroot "http://ftp.debian.org/debian/" \
	--parent-mirror-chroot-security "http://security.debian.org/debian-security/" \
	--parent-mirror-binary "http://ftp.debian.org/debian/" \
	--parent-mirror-binary-security "http://security.debian.org/debian-security/" \
	--parent-mirror-debian-installer "http://ftp.debian.org/debian/" \
	--mirror-bootstrap "http://ftp.debian.org/debian/" \
	--mirror-chroot "http://ftp.debian.org/debian/" \
	--mirror-chroot-security "http://security.debian.org/debian-security/" \
	--mirror-binary "http://ftp.debian.org/debian/" \
	--mirror-binary-security "http://security.debian.org/debian-security/" \
	--mirror-debian-installer "http://ftp.debian.org/debian/"

echo "deb https://beta.armbian.com bookworm main bookworm-utils bookworm-desktop" > config/archives/live.list.chroot
echo "deb https://beta.armbian.com bookworm main bookworm-utils bookworm-desktop" > config/archives/live.list.binary
echo "deb https://download.opensuse.org/repositories/home:/amazingfate:/panfork-mesa/Debian_12/ ./" >> config/archives/live.list.chroot
echo "deb https://download.opensuse.org/repositories/home:/amazingfate:/panfork-mesa/Debian_12/ ./" >> config/archives/live.list.binary

wget https://raw.githubusercontent.com/armbian/build/main/config/armbian.key
gpg --dearmor < armbian.key > armbian.gpg
cp armbian.gpg config/archives/armbian.key.binary
cp armbian.gpg config/archives/armbian.key.chroot
wget https://download.opensuse.org/repositories/home:/amazingfate:/panfork-mesa/Debian_12/Release.key
gpg --dearmor < Release.key > obs-amazingfate.gpg
cp obs-amazingfate.gpg config/archives/obs-amazingfate.key.binary
cp obs-amazingfate.gpg config/archives/obs-amazingfate.key.chroot

wget https://raw.githubusercontent.com/armbian/build/main/config/cli/common/main/packages -O config/package-lists/armbian-cli.list.chroot
wget https://raw.githubusercontent.com/armbian/build/main/config/cli/common/main/packages.additional -O config/package-lists/armbian-cli-addtional.list.chroot
wget https://raw.githubusercontent.com/armbian/build/main/config/desktop/bullseye/environments/gnome/config_base/packages -O config/package-lists/armbian-gnome.list.chroot
sed -i "/lightdm/d" config/package-lists/armbian-gnome.list.chroot
cp additional-packages.bookworm config/package-lists/additional-packages.list.chroot

mkdir -p config/includes.chroot_after_packages/etc/netplan
cp networkmanager.yaml config/includes.chroot_after_packages/etc/netplan

cp 0001-install-grub-efi-arm64.hook.chroot config/hooks/live
