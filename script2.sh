#!/bin/bash

efipart=nvme0n1p1 #EFI Partition
swappart=nvme0n1p3
uSernAme=yatish
hostname=yatish-arch
echo "Installing ARCH Linux"                                                                             
timedatectl set-timezone Asia/Kolkata
sudo sed --in-place 's/^#\s*\(en_IN\s\+UTF-8\)/\1/' /etc/locale.gen
locale-gen
echo LANG=en_IN.UTF-8 > /etc/locale.conf
export LANG=en_IN.UTF-8
echo "$hostname" > /etc/hostname
touch /etc/hosts
echo "127.0.0.1    localhost                                      
::1             localhost
127.0.1.1       "$hostname" " > /etc/hosts
passwd
pacman -Syy
pacman -S grub efibootmgr os-prober
mkdir /boot/efi
mount /dev/"$efipart" /boot/efi
grub-install --target=x86_64-efi --bootloader-id=ARCH --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg
pacman -S xorg
pacman -S gnome
pacman -S nautilus-sendto
pacman -S wget git curl
sudo pacman -S zsh zsh-history-substring-search zsh-syntax-highlighting zsh-autosuggestions zsh-theme-powerlevel10k  --noconfirm
sudo pacman -S libva-utils intel-media-driver libva-intel-driver libva-mesa-driver  --noconfirm
#Fonts
pacman -S --noconfirm ttf-droid ttf-bitstream-vera evolution-data-server ttf-liberation noto-fonts noto-fonts-cjk
pacman -S gnome-tweaks chrome-gnome-shell --noconfirm
#systemctl start gdm.service
systemctl enable gdm.service
systemctl enable NetworkManager.service
systemctl enable bluetooth.service
#echo "udev_log=3" >> /etc/udev/udev.conf
HUK="(base udev autodetect modconf block filesystems keyboard keymap resume)"
sed -i "s/^\(HOOKS\s*=\s*\).*\$/\1$HUK/" /etc/mkinitcpio.conf
mkinitcpio -p linux
VAL="\"quiet vt.global_cursor_default=0 rd.loglevel=0 systemd.show_status=false rd.udev.log-priority=0 udev.log-priority=0 resume=UUID=$(lsblk -no UUID /dev/"$swappart")\""
sed -i "s/^\(GRUB_CMDLINE_LINUX_DEFAULT\s*=\s*\).*\$/\1$VAL/" /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg
useradd --create-home "$uSernAme"
passwd "$uSernAme"
usermod --append --groups wheel "$uSernAme"
sudo sed --in-place 's/^#\s*\(%wheel\s\+ALL=(ALL)\s\+ALL\)/\1/' /etc/sudoers
sudo pacman -R gnome-photos gnome-maps gnome-books epiphany gnome-music gnome-boxes
exit
