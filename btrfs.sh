mainpart=nvme0n1p3
swappart=nvme0n1p2 #SWAP Partition
mkfs.btrfs -f /dev/"$mainpart"
mount /dev/"$mainpart" /mnt
btrfs su cr /mnt/@root
btrfs su cr /mnt/@home
btrfs su cr /mnt/@.snapshots

sudo mkswap /dev/"$swappart"
sudo swapon /dev/"$swappart"
umount /mnt
mount -o compress=lzo,subvol=@root /dev/"$mainpart"  /mnt
mkdir /mnt/{home,.snapshots}
mount -o compress=lzo,subvol=@home /dev/"$mainpart" /mnt/home
mount -o compress=lzo,subvol=@.snapshots /dev/"$mainpart"  /mnt/.snapshots
cp mirrorlist /etc/pacman.d/mirrorlist
pacman -Syy
pacman -S reflector os-prober
pacstrap /mnt base linux linux-firmware vim nano sudo vi base-devel linux-headers
genfstab -U /mnt >> /mnt/etc/fstab
sudo cp gnome-install.sh /mnt
sudo cp kde-install.sh /mnt

