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

1. Install: `pacstrap /mnt base  base-devel linux linux-firmware neofetch git sudo nano bat <amd/intel>-ucode networkmanager bluez bluez-utils pulseaudio`
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
8. Enable pulseaudio: `systemctl --user enable pulseaudio`

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
5. Connect to the internet with `nmtui`

# Install yay

https://github.com/Jguer/yay
1. Clone the git repo: `git clone https://aur.archlinux.org/yay.git`
2. Go into the folder: `cd yay`
3. Create the package: `makepkg -si`
4. Add color: `sudo nano /etc/pacman.conf` and comment out `Color`

# Create a system snapshot with timeshift

1. Install timeshift: `yay -S timeshift`
2. Create a snapshot with `sudo timeshift --create --comment "<your comment>"`

# Install Hyprland and contiguring the look

1. Get dotfiles: `git clone https://github.com/JuliusRye/system_repo.git`
2. Install symlink tool: `yay -S stow`
3. Go into the dotfiles directory: `cd system_repo/dotfiles` and type: `stow . --target=../../.config`
4. Install the hypr-eco-system: `yay -S hyprland hypridle hyperlock hyprpaper hyprpicker hyprshot`
5. Install waybar apps: `yay -S pamixer pavucontrol btop ncdu network-manager-applet blueman swaync`
6. Install needed programs: `yay -S kitty nemo wofi firefox waybar starship bitwarden polkit-gnome fzf`
7. Install needed fonts: `yay -S ttf-font-awesome ttf-nerd-fonts-symbols-mono ttf-cascadia-code-nerd`
8. Make terminal look pretty: `sudo nano .bashrc` and add `eval "$(starship init bash)"` at the end of the file
9. Verify that it works by starting hyprland: `Hyprland`

# Change/add system theme

1. Use `nwg-look` to change themes with a UI. Install it with `yay -S nwg-look`
2. Find themes by installing them from the AUR or downloading them from places like this: https://www.gnome-look.org
    - Used theme: [Orchis gtk theme](https://www.gnome-look.org/p/1357889) `.themes`
    - Used icons: [BeautyLine](https://www.gnome-look.org/p/1425426) `.icons`
    - Used cursor: [Sweet cursors](https://www.gnome-look.org/p/1393084) `.icons`
4. Unpack files with `tar -xvzf <file-name>.tar.gz` or `tar -xvJf <file-name>.tar.xz`
5. Place the unpacked files in `.themes` or `.icons` depending on the file.

May be usefull: https://github.com/MathisP75/Hyprland-Multi-Theme

# Install vscode

1. Get vscode: `yay -S visual-studio-code-bin`
2. Configure to show icons by adding the following to `>Open user settings` with `ctrl+shift+P`:
```
{
    "editor.fontFamily": "'Droid Sans Mono','Symbols Nerd Font Mono', 'JetBrains Mono', monospace",
    "editor.fontLigatures": true,
    "editor.fontSize": 18,
    "terminal.integrated.fontFamily": "'Droid Sans Mono','Symbols Nerd Font Mono', 'JetBrains Mono', monospace"
}
```
