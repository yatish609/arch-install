mainpart=sdb2 #Partition where OS is to be installed
swappart=sda2 #SWAP Partition
sudo mkswap /dev/"$swappart"
sudo swapon /dev/"$swappart"

mkfs.ext4 /dev/"$mainpart"
mount /dev/"$mainpart" /mnt
cp mirrorlist /etc/pacman.d/mirrorlist
pacman -Syy
pacman -S reflector os-prober
pacstrap /mnt base linux linux-firmware vim nano sudo vi base-devel linux-headers
genfstab -U /mnt >> /mnt/etc/fstab
sudo cp script2.sh /mnt
