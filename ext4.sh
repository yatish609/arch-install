mainpart=nvme0n1p3 #Partition where OS is to be installed
swappart=nvme0n1p2 #SWAP Partition
sudo mkswap /dev/"$swappart"
sudo swapon /dev/"$swappart"

mkfs.ext4 /dev/"$mainpart"
mount /dev/"$mainpart" /mnt
pacman -S reflector os-prober
pacstrap /mnt base linux linux-firmware vim nano sudo vi base-devel linux-headers
genfstab -U /mnt >> /mnt/etc/fstab
sudo cp gnome-install.sh /mnt
sudo cp kde-install.sh /mnt
