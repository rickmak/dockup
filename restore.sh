#!/bin/bash
: ${MYSQL_DUMP:='dump.sql'}

# Find last backup file
: ${LAST_BACKUP:=$(aws s3 ls s3://$S3_BUCKET_NAME | awk -F " " '{print $4}' | grep ^$BACKUP_NAME | sort -r | head -n1)}

# Download backup from S3
aws s3 cp s3://$S3_BUCKET_NAME/$LAST_BACKUP $LAST_BACKUP

# Extract backup
tar xzf $LAST_BACKUP $RESTORE_TAR_OPTION

# Restoring mysql dump
if [[ -n "$MYSQL_DB" ]]; then
    mysql -u $MYSQL_USER -p$MYSQL_PASS < $MYSQL_DUMP
fi
