# Preparing Build Environment
## Install packages for live build

```bash
sudo apt update
sudo apt install -y live-build squashfs-tools live-boot live-config xorriso isolinux
sudo apt install -y netselect-apt
```

## Cloning the repository

```bash
git clone https://github.com/anderl1969/PBSLiveRescue.git
```

## Building the iso

```bash
cd <Project folder>

lb clean
lb config
lb build
```


# To Do list

- add `/opt/proxmoxbackupclient` to path
- add `pbs_restore_img-full.sh``
- fix script parameter handling
