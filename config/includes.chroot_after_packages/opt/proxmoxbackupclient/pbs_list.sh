#!/bin/bash

OPT_NAMESPACE=""
PBS_NAMESPACE=""

MY_REPOSITORY=REPOSITORY_CONNECT_STRING
#MY_BACKUP_GROUP=host/$(hostname)

# do not edit below this line

export PBS_PASSWORD_FILE="/opt/proxmoxbackupclient/pbs_token_secret"

print_help() {
    echo Prints a List of all snapshots.
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
    echo -e "-n <namespace>    \t  - Specifies a custom Namespace on PBS. If not provided the Root-Namespace will be used."

}

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

proxmox-backup-client snapshot list $MY_BACKUP_GROUP --repository $MY_REPOSITORY $OPT_NAMESPACE $PBS_NAMESPACE
