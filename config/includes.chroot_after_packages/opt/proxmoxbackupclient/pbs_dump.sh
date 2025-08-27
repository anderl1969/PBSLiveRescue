#!/bin/bash

WORK_DIR=$(dirname $(readlink -f $0))
TOKEN_FILE=token_secret
REPO_FILE=repository_secret

OPT_NAMESPACE=""
PBS_NAMESPACE=""

# do not edit below this line

print_help() {
    echo Lists all files catalogued in the file archive of a backup specified by the snapshot.
    echo To function properly the files \'$TOKEN_FILE\' and \'$REPO_FILE\' must exist in $WORK_DIR
    echo
    echo Usage:
    echo -e "$(basename $0) -h                 \t  - prints this help text."
    echo -e "$(basename $0) [options] snapshot \t  - lists all files of <snapshot>"
    echo
    echo -e "Parameters:"
    echo -e "snapshot          \t  - Specifies the snapshot. Use 'pbs_list.sh' to identify the proper snapshot."
    echo
    echo -e "Options:"
    echo -e "-h                \t  - Prints help information."
    echo -e "-n <namespace>    \t  - Specifies a custom Namespace on PBS. If not provided the Root-Namespace will be used."
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
    # missing arguments!
    echo -e "Error: Missing argument <snapshot>!\n"
    print_help
    exit 1
fi

MY_SNAPSHOT=$1

# proxmox-backup-catalog dumps to stderr. To make it easier to pipe, it's redirected to stdout
proxmox-backup-client catalog dump $MY_SNAPSHOT $OPT_NAMESPACE $PBS_NAMESPACE 2>&1
