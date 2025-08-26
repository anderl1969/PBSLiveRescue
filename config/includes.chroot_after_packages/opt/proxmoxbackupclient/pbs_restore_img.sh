#!/bin/bash

# snapshot: host/debBackupTest/2025-08-23T14:32:45Z
# archive:  sda1.img.fidx
MY_ARCHIVE=fulldrive.img
TARGET_PATH=-

OPT_NAMESPACE=""
PBS_NAMESPACE=""

MY_REPOSITORY=REPOSITORY_CONNECT_STRING

# do not edit below this line

export PBS_PASSWORD_FILE="/opt/proxmoxbackupclient/pbs_token_secret"

print_help() {
    echo "Restores a full image back to stdout. Use tools like dd to write it to an disk."
    echo -e "e.g.: $(basename $0) ... | sudo dd of=/dev/nvme0n1 status=progress bs=1M"
    echo
    echo Usage:
    echo -e "$(basename $0) -h                 \t  - prints this help text."
    echo -e "$(basename $0) [options] snapshot \t  - restores <snbapshot> from Proxmox Backup Server to stdout."
    echo
    echo -e "Parameters:"
    echo -e "<snapshot> \t  - specifies the snapshot to restore."
    echo -e "           \t    Use 'pbs_list.sh' to identify."
    echo
    echo -e "Options:"
    echo -e "-h             \t  - Prints help information."
    #echo -e "-i <backup-id> \t  - Specifies a custom Backup-ID. If not provided 'RESC_<IP address>' will be used."
    echo -e "-n <namespace> \t  - Specifies a custom Namespace on PBS. If not provided the Root-Namespace will be used."
}

while getopts "hn:" opt; do
    case $opt in
        h)
            print_help
            exit 0
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
    # snapshot device missing!
    echo -e "Missing Parameter <snapshot>!\n"
    print_help
    exit 1
fi

MY_SNAPSHOT=$1

proxmox-backup-client restore $MY_SNAPSHOT $MY_ARCHIVE $TARGET_PATH --repository $MY_REPOSITORY --ns $PBS_NAMESPACE
