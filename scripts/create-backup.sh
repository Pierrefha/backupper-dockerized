#!/bin/sh
#
# Author: Pierre Dahmani
# Created: 04.03.2021
#
# Description: Copies files (compressed backups are assumed) from remote
# server to the local machine. Always keeps a specified amount of max backups.
# Keeps the newest ones when considering the max backups amount.
# cronjobs alpine info: https://devopsheaven.com/cron/docker/alpine/linux/2017/10/30/run-cron-docker-alpine.html

# prints the current time
currtime(){
    echo "$(date "+%d.%m.%Y-%H:%M:%S")"
}


echo "`currtime`: Creating backup.."
# time since 01.01.1970. busybox implementation of date.
TIMESINCE=$(date -D %Y%m%d%H%M%S +%s)

# MAYBE(pierre): use rsync -u || --ignore-existing to only get diffs
# info: https://unix.stackexchange.com/questions/14191/scp-without-replacing-existing-files-in-the-destination

# copies files from remote server to local machine
scp -r -P $SSH_PORT -o stricthostkeychecking=no -i /root/.ssh/$SSH_KEYNAME \
    $SSH_USERNAME@$REMOTE_IP:$SOURCE_PATH/* $TARGET_PATH

# gets number of files/backups that are currently in our backup directory.
NUM_COPIES=$(ls $TARGET_PATH | wc -l)

# deletes backups if the count if higher than our specified max.
if [ $NUM_COPIES -gt $MAX_NUMBER_OF_BACKUPS ]
then
    # finds all files in path, sorts and deletes any that are above our
    # maximum number of backups specified.
    find -P $TARGET_PATH -type f -maxdepth 1 | sort -n | \
	    head -n -$MAX_NUMBER_OF_BACKUPS | xargs rm -f && \
    echo "`currtime`: Deleted obsolete backup. We are only keeping $MAX_NUMBER_OF_BACKUPS copies."
fi

echo "`currtime`: Backup task finished."
