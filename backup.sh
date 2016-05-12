#!/bin/bash
export PATH=$PATH:/usr/bin:/usr/local/bin:/bin
# Get timestamp
: ${SUFFIX:='%Y-%m-%d-%H-%M-%S'}
: ${BACKUP_SUFFIX:=.$(date +"$SUFFIX")}
readonly tarball=$BACKUP_NAME$BACKUP_SUFFIX.tar.gz

# Create a gzip compressed tarball with the volume(s)
tar czf $tarball $BACKUP_TAR_OPTION $PATHS_TO_BACKUP

# Upload the backup to S3 with timestamp
aws s3 --region $AWS_DEFAULT_REGION cp --storage-class=STANDARD_IA $tarball s3://$S3_BUCKET_NAME/$tarball

# Clean up
rm $tarball
