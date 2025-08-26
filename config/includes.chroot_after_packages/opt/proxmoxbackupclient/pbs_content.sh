#!/bin/bash

PBS_NAMESPACE="Server"
MY_REPOSITORY=REPOSITORY_CONNECT_STRING

# do not edit below this line

export PBS_PASSWORD_FILE="./pbs_token_secret"

print_help() {
    echo Lists the content of an archive using the index.json file of the repository.
    echo
    echo Usage:
    echo -e "$(basename $0) --help     \t  - prints this help text"
    echo -e "$(basename $0) <snapshot> \t  - lists the content of <snapshot>"
}

if [ $# -gt 0 ]; then
    # Arguments passed!
    if [ $1 = --help ]; then
        print_help
        exit 0
    else
        # if not 'help' then 1st argument is backup-group
        MY_SNAPSHOT=$1
    fi
else
    # no arguments = error
    echo Fehler! Es wurde kein Snapshot angegeben.
    print_help
    exit 1
fi

proxmox-backup-client restore $MY_SNAPSHOT index.json - --repository $MY_REPOSITORY --ns $PBS_NAMESPACE
