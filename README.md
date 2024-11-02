# Prepare USB

1. Download iso file: https://archlinux.org/download/
2. Checksum: `sha256sum archlinux-<date>-x86_64.iso`
3. Locate USB drive: `lsblk`
4. Burn .iso to USB drive: `sudo dd if=Downloads/archlinux-<date>-x86_64.iso of=/dev/<USB drive> bs=16M status=progress oflag=sync` 
