LB_IMAGE_NAME="debian-trixie-live" lb config \
	--architecture arm64 \
	--archive-areas 'contrib main non-free non-free-firmware' \
	--parent-archive-areas 'contrib main non-free non-free-firmware' \
	--debian-installer-distribution trixie \
	--distribution trixie \
	--distribution-chroot trixie \
	--distribution-binary trixie \
	--bootloaders grub-efi \
	--keyring-packages "debian-archive-keyring ca-certificates fontconfig-config initramfs-tools" \
	--linux-packages "linux-image linux-headers" \
	--linux-flavours "vendor-rk35xx" \
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

echo "deb https://apt.armbian.com trixie main trixie-utils trixie-desktop" > config/archives/live.list.chroot
echo "deb https://apt.armbian.com bookworm main trixie-utils trixie-desktop" > config/archives/live.list.binary
echo "deb http://download.opensuse.org/repositories/home:/amazingfate:/grub-dtbo/Debian_Testing/ /" >> config/archives/live.list.chroot
echo "deb http://download.opensuse.org/repositories/home:/amazingfate:/grub-dtbo/Debian_Testing/ /" >> config/archives/live.list.binary
echo "deb http://download.opensuse.org/repositories/home:/amazingfate:/libmali-rockchip/Debian_Testing/ /" >> config/archives/live.list.chroot
echo "deb http://download.opensuse.org/repositories/home:/amazingfate:/libmali-rockchip/Debian_Testing/ /" >> config/archives/live.list.binary

wget https://raw.githubusercontent.com/armbian/build/main/config/armbian.key
gpg --dearmor < armbian.key > armbian.gpg
cp armbian.gpg config/archives/armbian.key.binary
cp armbian.gpg config/archives/armbian.key.chroot
wget https://download.opensuse.org/repositories/home:amazingfate:grub-dtbo/Debian_Testing/Release.key
gpg --dearmor < Release.key > obs-amazingfate.gpg
cp obs-amazingfate.gpg config/archives/obs-amazingfate.key.binary
cp obs-amazingfate.gpg config/archives/obs-amazingfate.key.chroot

wget https://raw.githubusercontent.com/armbian/build/main/config/cli/common/main/packages -O config/package-lists/armbian-cli.list.chroot
wget https://raw.githubusercontent.com/armbian/build/main/config/cli/common/main/packages.additional -O config/package-lists/armbian-cli-addtional.list.chroot
wget https://raw.githubusercontent.com/armbian/build/main/config/desktop/bookworm/environments/gnome/config_base/packages -O config/package-lists/armbian-gnome.list.chroot
sed -i "/wireguard-tools/d" config/package-lists/armbian-cli.list.chroot
cp additional-packages config/package-lists/additional-packages.list.chroot

mkdir -p config/includes.chroot_after_packages/etc/netplan
cp networkmanager.yaml config/includes.chroot_after_packages/etc/netplan

cp customize-chroot.hook.chroot config/hooks/live
mkdir -p config/includes.chroot_after_packages/etc/grub.d/
cp 10_linux config/includes.chroot_after_packages/etc/grub.d/
