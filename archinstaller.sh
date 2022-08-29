echo "Welcome to the Arch Install Script"
echo "This is an Automation Script for a Virtualbox machine"
echo "WARNING! DO NOT RUN THIS SCRIPT ON A REAL MACHINE"
echo "Do you want to proceed? [y/N]"
read choice
if [ $choice = "y" ] || [ $choice = "Y" ]; then
	echo "Step 01 : Partitioning and Mounting the Disk"
	parted -s /dev/sda mklabel msdos mkpart primary 'ext4' '0%' '100%'
	echo y | mkfs.ext4 /dev/sda
	mount /dev/sda /mnt
	echo "Step 02 : Installing Base Packages"
	pacstrap /mnt base linux linux-headers
	echo "Step 03 : Generating the fstab file"
	genfstab -U /mnt >> /mnt/etc/fstab
	echo "Step 04 : Setting the Timezone"
	arch-chroot /mnt ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
	echo "Step 05 : Generating Locales"
	arch-chroot /mnt sed -i "s/#en_US.UTF8 UTF8/en_US.UTF8 UTF8/g" /etc/locale.gen
	arch-chroot /mnt sed -i "s/#en_IN.UTF8/en_IN UTF8/g"
	arch-chroot /mnt locale-gen
	echo "Step 06 : Setting Hostname"
	arch-chroot /mnt echo archvm | cat > /etc/hostname
	echo "Step 07 : Setting Root Password"
	arch-chroot /mnt echo root:rootpassword | chpasswd
	echo "Step 08 : Making and Adding Standard User"
	arch-chroot /mnt useradd -m nogoat
	arch-chroot /mnt echo nogoat:userpassword | chpasswd
	echo "Step 09 : Installing GRUB and sudo"
	pacstrap /mnt grub sudo
	echo "Step 10 : Adding Standard User to sudo group"
	arch-chroot /mnt usermod -aG sudo nogoat
	echo "Step 11 : Installing GRUB"
	arch-chroot /mnt grub-install /dev/sda --force
	arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg
	echo "Step 12 : Installing Xorg"
	pacstrap /mnt xorg xterm xterm-xinit
	echo "Step 13 : Installing KDE"
	pacstrap /mnt plasma kdeplasma-addons dolphin konsole
	echo "Step 14 : Installing and Setting up SDDM"
	pacstrap /mnt sddm
	arch-chroot /mnt systemctl enable sddm
	echo "Step 15 : Installing and Configuring NetworkManager"
	pacstrap /mnt networkmanager
	arch-chroot /mnt systemctl enable NetworkManager
	echo "Finished running Install steps."
	echo "WARNING! This script has no way of knowing if all the steps finished correctly." 
	echo "Please verify that yourself in order to ensure you don't have a broken system"
else
	echo "Aborted"
fi
