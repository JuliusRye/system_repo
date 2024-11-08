# Prepare USB

1. Download iso file: https://archlinux.org/download/
2. Checksum: `sha256sum archlinux-<date>-x86_64.iso`
3. Locate USB drive: `lsblk`
4. Burn .iso to USB drive: `sudo dd if=Downloads/archlinux-<date>-x86_64.iso of=/dev/<USB drive> bs=16M status=progress oflag=sync` 

# Connect to wifi

https://wiki.archlinux.org/title/Iwd#iwctl
1. `iwctl`
2. `device list`
3. `station <name> scan`
4. `station <name> get-networks`
5. `station <name> connect <SSID>`

# Format disk

1. `lsblk`
2. `cfdisk /dev/<disk>`

**Partitions:**

| Space | Type | name | Format | Mount |
| ----- | ---- | ---- | -------| ----- |
| 1G | **EFI System** | efi_system_partition | `mkfs.fat -F 32 /dev/<efi_system_partition>` | `mount --mkdir /dev/<efi_system_partition> /mnt/boot` |
| 4-16G | **Linux swap** | swap_partition | `mkswap /dev/<swap_partition>` | `swapon /dev/<swap_partition>` |
| Remaining | **Linux filesystem** | root_partition | `mkfs.ext4 /dev/<root_partition>` | `mount /dev/<root_partition> /mnt` |

3. Format partitions
4. Mount partitions (*root_partition before efi_system_partition*)

# Install Arch-Linux

1. Install: `pacstrap /mnt base  base-devel linux linux-firmware neofetch git sudo nano <amd/intel>-ucode networkmanager bluez bluez-utils`
2. Generate the file system: `genfstab -U /mnt >> /mnt/etc/fstab`
3. Jump into the new system: `arch-chroot /mnt`

# Configure the system

1. Set the **root** password: `passwd`
2. Create a user account: `useradd -m -g users -G wheel,storage,power,video,audio -s /bin/bash <user_name>`
3. Set **user** password: `passwd <user_name>`
4. Give user root access: `EDITOR=nano visudo` and uncomment "*%wheel ALL=(All:All) ALL*"
5. Check by switching to the user `su - <user_name>` and running `sudo pacman -Syu`. Exit by typing `exit`
6. Enable network: `systemctl enable NetworkManager`
7. Enable bluetooth: `systemctl enable bluetooth`

# Set ups

1. Set locale tiem: `ln -sf /usr/share/zoneinfo/Region/City /etc/localtime` followed by: `hwclock --systohc`
2. Generate locale: `nano /etc/locale.gen` and uncooment desired locale followed by: `locale-gen`
3. Set system locale: `nano /etc/locale.conf` and type "*LANG=\<locale\>.UTF-8*"
4. Set console keymap: `nano /etc/vconsole.conf` and type "*KEYMAP=\<keymap\>*"
5. Set host name: `nano /etc/hosts` and type:

```
127.0.0.1		localhost
::1			localhost
127.0.1.1		<host-name>.localdomain		<host-name>
```

# Install a bootloader (grub)

1. Install grub: `pacman -S grub efibootmgr dosfstools mtools`
2. Install grub into boot: `grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB`
3. Generate grub config file: `grub-mkconfig -o /boot/grub/grub.cfg`

# Boot into new system

1. Exit installed system: `exit`
2. Un-mount all partitions: `umount -lR /mnt`
3. Shutdown system: `shutdown now`
4. Remove USB-drive and turn the pc back on

# Install yay

https://github.com/Jguer/yay
1. Clone the git repo: `git clone https://aur.archlinux.org/yay.git`
2. Go into the folder: `cd yay`
3. Create the package: `makepkg -si`
