## Partie 4 : Scripts de sauvegarde

### I : Sauvegarde web

- Ecrire un script qui sauvegarde les données de NextCloud

```bash
#!/bin/bash

if [[ "$(id -u)" = "0" ]]
then
        datelog=$(date '+[%y/%m/%d %T]')
        datesauv=$(date '+%y%m%d_%H%M%S')
        name=nextcloud_"$datesauv".tar.gz
        cd /srv/backup
        tar cfz /srv/backup/$name /var/www/nextcloud/html
        echo "$datelog Backup /srv/backup/$name created successfully." >> /var/log/backup
        echo "Backup /srv/backup/$name created successfully."

else
        echo "This script must be run as root."
        exit 1
fi
```