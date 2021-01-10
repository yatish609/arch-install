#!/bin/bash

#######################################################
# INSTALL PARAMETERS (PLEASE CONFIGURE BEFORE INSTALL)
efipart=nvme0n1p1 #EFI Partition
swappart=nvme0n1p2
uSernAme=yatish
hostname=yatish-arch
language=en_IN.UTF-8
timezone=Asia/Kolkata
#########################################################


echo "Installing ARCH Linux" 

#Set Time and locale
timedatectl set-timezone "$timezone"

#Set Language
sudo sed --in-place 's/^#\s*\(en_IN\s\+UTF-8\)/\1/' /etc/locale.gen
locale-gen
echo LANG="$language" > /etc/locale.conf
export LANG="$language"

#Set Hostname
echo "$hostname" > /etc/hostname
touch /etc/hosts
echo "127.0.0.1    localhost                                      
::1             localhost
127.0.1.1       "$hostname" " > /etc/hosts

#Root Password
passwd

#Bootloader
pacman -Syy
pacman -S grub efibootmgr os-prober
mkdir /boot/efi
mount /dev/"$efipart" /boot/efi
grub-install --target=x86_64-efi --bootloader-id=ARCH --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg

#XORG
pacman -S xorg

#Desktop Environment
pacman -S gnome

#Gnome Patches
pacman -S nautilus-sendto

#ZSH
sudo pacman -S zsh zsh-history-substring-search zsh-syntax-highlighting zsh-autosuggestions zsh-theme-powerlevel10k  --noconfirm

#Intel Drivers
sudo pacman -S libva-utils intel-media-driver libva-intel-driver libva-mesa-driver  --noconfirm

#Fonts
pacman -S --noconfirm ttf-droid ttf-bitstream-vera evolution-data-server ttf-liberation noto-fonts noto-fonts-cjk

#Gnome-Extras
pacman -S gnome-tweaks chrome-gnome-shell --noconfirm

#Remove Gnome Bloat
sudo pacman -R gnome-photos gnome-maps gnome-books epiphany gnome-music gnome-boxes

#Enable Gnome Services
systemctl enable gdm.service
systemctl enable NetworkManager.service
systemctl enable bluetooth.service

#Set Up SWAP Hibernate
VAL="\"quiet vt.global_cursor_default=0 rd.loglevel=0 systemd.show_status=false rd.udev.log-priority=0 udev.log-priority=0 \""
sed -i "s/^\(GRUB_CMDLINE_LINUX_DEFAULT\s*=\s*\).*\$/\1$VAL/" /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

#Create New User
useradd --create-home "$uSernAme"
passwd "$uSernAme"
usermod --append --groups wheel "$uSernAme"
sudo sed --in-place 's/^#\s*\(%wheel\s\+ALL=(ALL)\s\+ALL\)/\1/' /etc/sudoers


#Exit Script
rm -r /script2.sh
exit
