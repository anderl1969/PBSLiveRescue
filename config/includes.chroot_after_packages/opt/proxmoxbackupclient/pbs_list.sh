#!/bin/bash

WORK_DIR=$(dirname $(readlink -f $0))
TOKEN_FILE=token_secret
REPO_FILE=repository_secret

OPT_NAMESPACE=""
PBS_NAMESPACE=""

# do not edit below this line

print_help() {
    echo Prints a List of all snapshots.
    echo To function properly the files \'$TOKEN_FILE\' and \'$REPO_FILE\' must exist in $WORK_DIR
    echo
    echo Usage:
    echo -e "$(basename $0) -h        \t  - prints this help text."
    echo -e "$(basename $0) [options] \t  - list all snapshots."
    echo
    echo -e "Parameters:"
    echo
    echo -e "Options:"
    echo -e "-h                \t  - Prints help information."
    echo -e "-g <group>        \t  - Lists snapshots of <group>. If not provided, all snapshots are listed."
    echo -e "                  \t    If you want to show snapshots of the current machine, use '-g host/\$(hostname)'"
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

while getopts "hg:n:" opt; do
    case $opt in
        h)
            print_help
            exit 0
            ;;
        g)
            MY_BACKUP_GROUP=$OPTARG
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

if [ $# -gt 0 ]; then
    # unexpected arguments!
    echo -e "No more arguments expected. Given '$1'!\n"
    print_help
    exit 1
fi

proxmox-backup-client snapshot list $MY_BACKUP_GROUP $OPT_NAMESPACE $PBS_NAMESPACE
