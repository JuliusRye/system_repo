# Prepare USB

1. Download iso file: https://archlinux.org/download/
2. Checksum: `sha256sum archlinux-<date>-x86_64.iso`
3. Locate USB drive: `lsblk`
4. Burn .iso to USB drive: `sudo dd if=Downloads/archlinux-<date>-x86_64.iso of=/dev/<USB drive> bs=16M status=progress oflag=sync` 

# Connect to wifi

https://wiki.archlinux.org/title/Iwd#iwctl
1. `iwctl`
2. `device list`
3. `station name scan`
4. `station name get-networks`
5. `station name connect SSID`

# Format disk

1. `lsblk`
2. `cfdisk /dev/<disk>`

**Partitions:**

| Space | Type | name | Format | Mount |
| ----- | ---- | ---- | -------| ----- |
| 1G | **EFI System** | efi_system_partition | `mkfs.fat -F 32 /dev/efi_system_partition` | `mount --mkdir /dev/efi_system_partition /mnt/boot` |
| 4-16G | **Linux swap** | swap_partition | `mkswap /dev/swap_partition` | `swapon /dev/swap_partition` |
| Remaining | **Linux filesystem** | root_partition | `mkfs.ext4 /dev/root_partition` | `mount /dev/root_partition /mnt` |

# Install Arch-Linux

1. Install: `pacstrap /mnt base  base-devel linux linux-firmware neofetch git sudo nano amd-ucode networkmanager bluez bluez-utils`
2. Enable network: `systemctl enable NetworkManager`
3. Enable bluetooth: `systemctl enable bluetooth`

# Configure the system

1. Generate the file system: `genfstab -U /mnt >> /mnt/etc/fstab`
2. Jump into the new system: `arch-chroot /mnt`
3. Set the **root** password: `passwd`
4. Create a user account: `useradd -m -g users -G wheel,storage,power,video,audio -s /bin/bash <user_name>`
5. Set **user** password: `passwd <user_name>`
6. Give user root access: `EDITOR=nano visudo`
7. Uncomment "*%wheel ALL=(All:All) ALL*"
8. Check by switching to the user `su - <user_name>` and running `sudo pacman -Syu`. Exit by typing `exit`

# Set ups


