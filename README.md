# backupper-dockerized

## About
Automaticly, periodically creates a local backup of files that are stored on a
remote server.

## Prerequesites
- docker-compose && docker installed
- remote server configured to allow ssh connections with the key you will be using

## Quick start
- adapt the values inside .env file. You need to adapt:
1) PATH_TO_SSH_DIR to the path where you store the ssh key that has permission to
connect to your remote server.
2) TZ to your timezone. Backups should have to correct timestamps.
3) The rest CAN stay default.
- adapt all the values inside backupper-env file to match the config of your
server
- run docker-compose up -d

## Backup schedule
Backups are initiated using crontabs. The default schedule is daily at 3:50
AM. You can adapt this schedule by:
a) adapt the ./basics/crontab file before you create the image.
b) go inside the container and adapt it there (if you don't want to recreate
it) e.g.
```shell
docker container exec -ti containerIdHere /bin/ash
apk add vim
vim /etc/crontabs/root
```

## Backup structure
- Assumes that the backups on your remote server look something like this
```shell
/path/to/backups/backup-of-today.anyFileFormat
/path/to/backups/backup-of-yesterday.anyFileFormat
/path/to/backups/backup-of-the-day-before-yesterday.anyFileFormat
```
- If you store files instead of compressed files, make sure to adapt the
$MAX_NUMBER_OF_BACKUPS to match the file count.. (consider storing backups
compressed)
