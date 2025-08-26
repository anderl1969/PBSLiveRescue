#!/bin/bash

PBS_NAMESPACE="Server"
MY_REPOSITORY=REPOSITORY_CONNECT_STRING
MY_BACKUP_GROUP=host/$(hostname)

# do not edit below this line

#export PBS_PASSWORD_FILE="/opt/scripts/pbs_token_secret"
export PBS_PASSWORD_FILE="./pbs_token_secret"

print_help() {
    echo Lists all snapshots of a certain backup group.
    echo
    echo Usage:
    echo -e "$(basename $0) --help    \t  - prints this help text"
    echo -e "$(basename $0)           \t  - lists all snapshots of $MY_BACKUP_GROUP"
    echo -e "$(basename $0) [<group>] \t  - lists all snapshots of <group>"
}

if [ $# -gt 0 ]; then
    # Arguments passed!
    if [ $1 = --help ]; then
        print_help
        exit 0
    else
        # if not 'help' then 1st argument is backup-group
        MY_BACKUP_GROUP=$1
    fi
fi

# Specifying no backup-group lists all snapshots in the namespace
proxmox-backup-client snapshot list $MY_BACKUP_GROUP --repository $MY_REPOSITORY --ns $PBS_NAMESPACE
