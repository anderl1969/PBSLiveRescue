# Preparing Build Environment
## Install packages for live build

```bash
sudo apt update
sudo apt install -y live-build squashfs-tools live-boot live-config xorriso isolinux
sudo apt install -y netselect-apt
```

## Cloning the repository

```bash
git clone https://github.com/anderl1969/PBSLiveRescue
```

## Building the iso

```bash
cd PBSLiveRescue

sudo lb clean
lb config
sudo lb build
```

Note:
> `lb config` will drop a **WARNING** and `sudo lb build` even an **ERROR** because of some missing secret files, which are mandatory for the additional backup scripts to work properly.
> However, for a first run it's absolutely fine to ignore these and tell `sudo lb build` to proceed anyway.
> You should end with a working ISO image with a preinstalled **Proxmox Backup Client**
`
# Customizing
## Built in Backup-Scripts
In `config/includes.chroot_after_packages/opt/proxmoxbackupclient/` you find some usefull backup scripts you may want to use:

```bash
pbs_backup_file.sh
pbs_backup_img.sh
pbs_content.sh
pbs_dump.sh
pbs_list.sh
pbs_restore_img.sh
repository_secret.README
token_secret.README
```

## Secret Files
These scripts require two secret files to connect and authorize to the Proxmox Backup Server. Understandably, these two files are not part of the repository.
But there are two templates to get you started:

### token_secret
`config/includes.chroot_after_packages/opt/proxmoxbackupclient/token_secret`

```
aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee
```
Insert a valid API token of the proxmox backup server.

### repository_secret
`config/includes.chroot_after_packages/opt/proxmoxbackupclient/repository_secret`

```bash
PBS_REPOSITORY=user@pbs!token@host:store
```
For details look here:
[https://pbs.proxmox.com/docs/backup-client.html#backup-repository-locations](https://pbs.proxmox.com/docs/backup-client.html#backup-repository-locations)

