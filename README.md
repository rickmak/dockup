# Dockup

Docker image to backup your Docker container volumes

Why the name? Docker + Backup = Dockup

# Usage

You have a container running with one or more volumes:

```
$ docker run -d --name mysql rickmak/mysql
```

From executing a `$ docker inspect wordpress` we see that this container has two volumes:

```
"Volumes": {
  "/var/www/html": {}
}
```

## Backup
Launch `dockup` container with the following flags:

```
$ docker run --rm \
--env-file env.txt \
--link mysql
--volumes-from wordpress \
--name dockup rickmak/dockup:latest
```

The contents of `env.txt` being:

```
AWS_ACCESS_KEY_ID=<key_here>
AWS_SECRET_ACCESS_KEY=<secret_here>
AWS_DEFAULT_REGION=us-east-1
BACKUP_NAME=mysql
PATHS_TO_BACKUP=/etc/mysql /var/lib/mysql
S3_BUCKET_NAME=docker-backups.example.com
MYSQL_USER=root
MYSQL_PASS=
MYSQL_DB=db
RESTORE=false
```

`dockup` assume the bucket with name `S3_BUCKET_NAME` already created.
The paths in `PATHS_TO_BACKUP` will be tarballed, gzipped, time-stamped and
uploaded to the S3 bucket.


## Restore
To restore your data simply set the `RESTORE` environment variable to `true`
  - this will restore the latest backup from S3 to your volume.


## A note on Buckets

> [Bucket naming guidelines](http://docs.aws.amazon.com/cli/latest/userguide/using-s3-commands.html):
> "Bucket names must be unique and should be DNS compliant. Bucket names can
> contain lowercase letters, numbers, hyphens and periods. Bucket names can
> only start and end with a letter or number, and cannot contain a period next
> to a hyphen or another period."

These rules are enforced in some regions.


[AWS S3 Regions](http://docs.aws.amazon.com/general/latest/gr/rande.html#s3_region)

| Region name               | Region         |
| ------------------------- | -------------- |
| US Standard               | us-east-1      |
| US West (Oregon)          | us-west-2      |
| US West (N. California)   | us-west-1      |
| EU (Ireland)              | eu-west-1      |
| EU (Frankfurt)            | eu-central-1   |
| Asia Pacific (Singapore)  | ap-southeast-1 |
| Asia Pacific (Sydney)     | ap-southeast-2 |
| Asia Pacific (Tokyo)      | ap-northeast-1 |
| South America (Sao Paulo) | sa-east-1      |

