#!/bin/bash

WORK_DIR=$(dirname $(readlink -f $0))
TOKEN_FILE=token_secret
REPO_FILE=repository_secret

# must expand to something like this: "fulldrive.img:/dev/sda" (see below)
PBS_BACKUP_TARGET="fulldrive.img:"

OPT_NAMESPACE=""
PBS_NAMESPACE=""

MY_BACKUPID="RESC_"$(hostname -I | awk '{print $1}')

# do not edit below this line

print_help() {
    echo Clones the full drive to Proxmox Backup Server.
    echo To function properly the files \'$TOKEN_FILE\' and \'$REPO_FILE\' must exist in $WORK_DIR
    echo
    echo Usage:
    echo -e "$(basename $0) -h               \t  - prints this help text."
    echo -e "$(basename $0) [options] device \t  - clones <device> to the Proxmox Backup Server."
    echo
    echo -e "Parameters:"
    echo -e "<drive> \t  - specifies the block storage device to clone."
    echo -e "        \t    Use 'lsblk' to identify the correct drive (e.g. /dev/sda)"
    echo
    echo -e "Options:"
    echo -e "-h             \t  - Prints help information."
    echo -e "-i <backup-id> \t  - Specifies a custom Backup-ID. If not provided 'RESC_<IP address>' will be used."
    echo -e "-n <namespace> \t  - Specifies a custom Namespace on PBS. If not provided the Root-Namespace will be used."
}

# check if mandatory files are present
if [ ! -f $WORK_DIR/$TOKEN_FILE ] || [ ! -f $WORK_DIR/$REPO_FILE ] ; then
    echo -e "Missing File(s)!\n"
    print_help
    exit 1
fi

export PBS_PASSWORD_FILE=$WORK_DIR/$TOKEN_FILE
source $WORK_DIR/$REPO_FILE
export PBS_REPOSITORY

while getopts "hi:n:" opt; do
    case $opt in
        h)
            print_help
            exit 0
            ;;
        i)
            MY_BACKUPID=$OPTARG
            ;;
        n)
            OPT_NAMESPACE=--ns
            PBS_NAMESPACE=$OPTARG
            ;;
        *)
            print_help
            exit 1
            ;;
    esac
done

shift $((OPTIND - 1))

if [ $# -eq 0 ]; then
    # block device missing!
    echo -e "Missing Parameter <drive>!\n"
    print_help
    exit 1
fi

if [ ! -b $1 ]; then
    # not a valid block device!
    echo -e $1 "is no valid block device!\n"
    print_help
    exit 1

fi

PBS_BACKUP_NAME="$PBS_BACKUP_TARGET"$1

LOG=$0.log
date > $LOG

echo "proxmox-backup-client backup "$PBS_BACKUP_NAME" --backup-id "$MY_BACKUPID $OPT_NAMESPACE $PBS_NAMESPACE >> $LOG
proxmox-backup-client backup $PBS_BACKUP_NAME --backup-id $MY_BACKUPID $OPT_NAMESPACE $PBS_NAMESPACE >> $LOG 2>&1

date >> $LOG
