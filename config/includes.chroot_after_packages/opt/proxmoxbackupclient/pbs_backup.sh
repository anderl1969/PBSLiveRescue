#!/bin/bash

PBS_BACKUP_TARGET="root.pxar:/"
PBS_BACKUP_NAME="$PBS_BACKUP_TARGET"

PBS_NAMESPACE="Server"
MY_REPOSITORY=REPOSITORY_CONNECT_STRING

# do not edit below this line

export PBS_PASSWORD_FILE="./pbs_token_secret"

LOG=$0.log
date > $LOG

echo "proxmox-backup-client backup "$PBS_BACKUP_NAME" --repository "$MY_REPOSITORY" --ns "$PBS_NAMESPACE >> $LOG
proxmox-backup-client backup $PBS_BACKUP_NAME --repository $MY_REPOSITORY --ns $PBS_NAMESPACE >> $LOG 2>&1

date >> $LOG
