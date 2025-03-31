# Simple one-container Docker instance of HotCRP

Uses the instructions from https://github.com/kohler/hotcrp/blob/master/README.md

# Requirements

```shell
sudo apt-get update && sudo apt-get install -y docker-compose-v2
```

# Usage

First, build the HotCRP image:

```shell
docker build -t hotcrp-image .
```

Edit `docker-compose.yml` to set secrets and settings.
Edit `options.php` and `msmtprc` as needed.

Run ONCE to create the database volume:

```shell
docker volume create hotcrp_data
```

Then run to bring everything up:

```shell
docker compose up -d
```

# Setup

Run these commands ONCE to initialize the database.

```shell
# Easier: one-command method
docker exec -it hotcrp-docker-hotcrp-1 sh -c "cd /opt/hotcrp && cat src/schema.sql | mysql -u\$MARIADB_USER -p\$MARIADB_PASSWORD --host=\$MARIADB_HOST hotcrp"

# or alternatively manually
docker exec -it hotcrp-docker-hotcrp-1 /bin/bash
cd /opt/hotcrp
./lib/createdb.sh --dbuser="$MARIADB_USER,$MARIADB_PASSWORD" --host=$MARIADB_HOST --user=root --password=$MYSQL_ROOT_PASSWORD --force $MARIADB_DBNAME
```

# Debugging

```shell
docker exec -it hotcrp-docker-hotcrp-1 /bin/bash
vim /var/log/nginx/error.log
```
