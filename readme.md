# Installation

## Commands to install live build

```bash
sudo apt update
sudo apt install -y live-build squashfs-tools live-boot live-config xorriso isolinux
sudo apt install -y netselect-apt
```

## Configure Build Environment

### Create Project Folder

```bash
mkdir -p Project-Folder/auto
cd Project-Folder/auto
touch build clean config
```

### Auto scripts

#### Build script

```bash
#!/bin/sh

set -e

lb build noauto "${@}" 2>&1 | tee build.log
```

#### Clean script

```bash
#!/bin/sh

set -e

lb clean noauto "${@}"
rm -f config/binary config/bootstrap config/chroot config/common config/source
rm -f build.log
```

#### Config script

```bash
#!/bin/sh

set -e

lb config noauto \
    --mode debian \
    --architectures amd64 \
    --distribution trixie \
    --debian-installer none \
    --archive-areas "main contrib" \
    --bootappend-live "boot=live components locales=de_DE.UTF-8 keyboard-layouts=de timezone=Europe/Berlin hostname=PBClive username=debian" \
    --memtest none \
    "${@}"
```




# To Do list

- add `/opt/proxmoxbackupclient` to path
- add `pbs_restore_img-full.sh``
- fix script parameter handling
