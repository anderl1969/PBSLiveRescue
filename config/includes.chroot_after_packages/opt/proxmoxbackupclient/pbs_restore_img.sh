#!/bin/bash

WORK_DIR=$(dirname $(readlink -f $0))
TOKEN_FILE=token_secret
REPO_FILE=repository_secret

MY_ARCHIVE=fulldrive.img
TARGET_PATH=-       # stdout

OPT_NAMESPACE=""
PBS_NAMESPACE=""

# do not edit below this line

print_help() {
    echo "Restores a full image back to stdout. Use tools like dd to write it to an disk."
    echo -e "e.g.: $(basename $0) ... | sudo dd of=/dev/nvme0n1 status=progress bs=1M"
    echo To function properly the files \'$TOKEN_FILE\' and \'$REPO_FILE\' must exist in $WORK_DIR
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

proxmox-backup-client restore $MY_SNAPSHOT $MY_ARCHIVE $TARGET_PATH --ns $PBS_NAMESPACE
