#!/bin/bash
export PATH=$PATH:/usr/bin:/usr/local/bin:/bin
: ${MYSQL_DUMP:='dump.sql'}
# Get timestamp
: ${SUFFIX:='%Y-%m-%d-%H-%M-%S'}
: ${BACKUP_SUFFIX:=.$(date +"$SUFFIX")}
readonly tarball=$BACKUP_NAME$BACKUP_SUFFIX.tar.gz

if [[ -n "$MYSQL_DB" ]]; then
    mysqldump -u $MYSQL_USER -p$MYSQL_PASS --single-transaction -B $MYSQL_DB > $MYSQL_DUMP
fi

# Create a gzip compressed tarball with the volume(s)
tar czf $tarball $BACKUP_TAR_OPTION $PATHS_TO_BACKUP $MYSQL_DUMP

# Upload the backup to S3 with timestamp
aws s3 --region $AWS_DEFAULT_REGION cp --storage-class=STANDARD_IA $tarball s3://$S3_BUCKET_NAME/$tarball

# Clean up
rm $tarball
rm $MYSQL_DUMP
