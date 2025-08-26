#!/bin/bash

PBS_NAMESPACE="Server"
MY_REPOSITORY=REPOSITORY_CONNECT_STRING

# do not edit below this line

export PBS_PASSWORD_FILE="./pbs_token_secret"

print_help() {
    echo Shows the files in a given snapshot.
    echo
    echo Usage:
    echo -e "$(basename $0) --help     \t  - prints this help text"
    echo -e "$(basename $0) <snapshot> \t  - lists all files in <snapshot>"
}

if [ $# -gt 0 ]; then
    # Arguments passed!
    if [ $1 = --help ]; then
        print_help
        exit 0
    else
        # if not 'help' then 1st argument is snapshot
        MY_SNAPSHOT=$1
    fi
else
    # no arguments = error
    echo Fehler! Es wurde kein Snapshot angegeben.
    print_help
    exit 1
fi

# proxmox-backup-catalog dumps to stderr. To make it easier to pipe, it's redirected to stdout
proxmox-backup-client catalog dump $MY_SNAPSHOT --repository $MY_REPOSITORY --ns $PBS_NAMESPACE 2>&1
