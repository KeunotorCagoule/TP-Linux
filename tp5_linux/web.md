## II : Setup Web

### 1 : Install Apache

#### A : Apache

- Installer Apache sur la machine ```web.tp5.linux```

```bash
# on cherche quel paquet installer
[roxanne@web ~]$ dnf provides httpd
Last metadata expiration check: 21:25:25 ago on Thu 25 Nov 2021 05:59:38 PM CET.
httpd-2.4.37-41.module+el8.5.0+695+1fa8055e.x86_64 : Apache HTTP Server
Repo        : appstream
Matched from:
Provide    : httpd = 2.4.37-41.module+el8.5.0+695+1fa8055e

httpd-2.4.37-43.module+el8.5.0+714+5ec56ee8.x86_64 : Apache HTTP Server
Repo        : appstream
Matched from:
Provide    : httpd = 2.4.37-43.module+el8.5.0+714+5ec56ee8

# on installe le service httpd
[roxanne@web ~]$ sudo dnf install httpd
[sudo] password for roxanne:
Last metadata expiration check: 0:43:00 ago on Fri 26 Nov 2021 02:42:23 PM CET.
Dependencies resolved.
[...]
```

- Analyse du service Apache

```bash
# on lance le service httpd
[roxanne@web ~]$ sudo systemctl start httpd
[sudo] password for roxanne:

# on vérifie que le service est bien lancé
[roxanne@web ~]$ systemctl status httpd
● httpd.service - The Apache HTTP Server
   Loaded: loaded (/usr/lib/systemd/system/httpd.service; disabled; vendor preset: disabled)
   Active: active (running) since Fri 2021-11-26 15:31:04 CET; 20s ago
     Docs: man:httpd.service(8)
 Main PID: 2133 (httpd)
   Status: "Running, listening on: port 80"
    Tasks: 213 (limit: 4947)
   Memory: 25.0M
   CGroup: /system.slice/httpd.service
           ├─2133 /usr/sbin/httpd -DFOREGROUND
           ├─2134 /usr/sbin/httpd -DFOREGROUND
           ├─2135 /usr/sbin/httpd -DFOREGROUND
           ├─2136 /usr/sbin/httpd -DFOREGROUND
           └─2137 /usr/sbin/httpd -DFOREGROUND

Nov 26 15:31:04 web.tp5.linux systemd[1]: Starting The Apache HTTP Server...
Nov 26 15:31:04 web.tp5.linux systemd[1]: Started The Apache HTTP Server.
Nov 26 15:31:04 web.tp5.linux httpd[2133]: Server configured, listening on: port 80

# on lance le service au démarrage
[roxanne@web ~]$ sudo systemctl enable httpd
[sudo] password for roxanne:
Created symlink /etc/systemd/system/multi-user.target.wants/httpd.service → /usr/lib/systemd/system/httpd.service.
```

```bash
# le service httpd écoute sur le port 80
[roxanne@web ~]$ sudo ss -lptn | grep httpd
LISTEN 0      128                *:80              *:*    users:(("httpd",pid=2137,fd=4),("httpd",pid=2136,fd=4),("httpd",pid=2135,fd=4),("httpd",pid=2133,fd=4))

# les processus Apache sont lancés sous l'utilisateur Apache
[roxanne@web ~]$ sudo ps -ef | grep httpd
root        2133       1  0 15:31 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache      2134    2133  0 15:31 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache      2135    2133  0 15:31 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache      2136    2133  0 15:31 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache      2137    2133  0 15:31 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
roxanne     2405    1620  0 15:42 pts/0    00:00:00 grep --color=auto httpd
```

- Un premier test

```bash
# on ouvre le port sur lequel Apache écoute
[roxanne@web ~]$ sudo firewall-cmd --add-port=80/tcp --permanent
success

# on applique les changements
[roxanne@web ~]$ sudo firewall-cmd --reload
[sudo] password for roxanne:
success

# on vérifie qu'on a bien accès au site
[roxanne@web ~]$ curl http://10.5.1.11:80
<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>
    <style type="text/css">
      /*<![CDATA[*/

      html {
        height: 100%;
        width: 100%;
      }
 [...]
      <footer class="col-sm-12">
      <a href="https://apache.org">Apache&trade;</a> is a registered trademark of <a href="https://apache.org">the Apache Software Foundation</a> in the United States and/or other countries.<br />
      <a href="https://nginx.org">NGINX&trade;</a> is a registered trademark of <a href="https://">F5 Networks, Inc.</a>.
      </footer>

  </body>
</html>
```

#### B : PHP

- Installer PHP

```bash
# on ajoute les dépôts EPEL
[roxanne@web ~]$ sudo dnf install epel-release
[sudo] password for roxanne:
Last metadata expiration check: 1:21:24 ago on Fri 26 Nov 2021 02:42:23 PM CET.
Dependencies resolved.
[...]                                            1/1

Installed:
  epel-release-8-13.el8.noarch

Complete!

# on fait la mise à jour
[roxanne@web ~]$ sudo dnf update
Extra Packages for Enterprise Linux 8 - x86_64                          5.5 MB/s |  11 MB     00:01
Extra Packages for Enterprise Linux Modular 8 - x86_64                  1.3 MB/s | 958 kB     00:00
Dependencies resolved.
Nothing to do.
Complete!

# ajout des dépôts REMI
[roxanne@web ~]$ sudo dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm
[sudo] password for roxanne:
Last metadata expiration check: 0:05:39 ago on Fri 26 Nov 2021 04:05:24 PM CET.
remi-release-8.rpm                                                      133 kB/s |  26 kB     00:00
Dependencies resolved.
[...]
Installed:
  remi-release-8.5-1.el8.remi.noarch

Complete!


[roxanne@web ~]$ sudo dnf module enable php:remi-7.4
Remi's Modular repository for Enterprise Linux 8 - x86_64               2.0 kB/s | 858  B     00:00
Remi's Modular repository for Enterprise Linux 8 - x86_64               3.0 MB/s | 3.1 kB     00:00
Importing GPG key 0x5F11735A:
[...]
Is this ok [y/N]: y
Complete!

# on installe PHP et les librairies requises par NextCloud
[roxanne@web ~]$ sudo dnf install zip unzip libxml2 openssl php74-php php74-php-ctype php74-php-curl php74-php-gd php74-php-iconv php74-php-json php74-php-libxml php74-php-mbstring php74-php-openssl php74-php-posix php74-php-session php74-php-xml php74-php-zip php74-php-zlib php74-php-pdo php74-php-mysqlnd php74-php-intl php74-php-bcmath php74-php-gmp
Last metadata expiration check: 0:01:05 ago on Fri 26 Nov 2021 04:12:33 PM CET.
Package zip-3.0-23.el8.x86_64 is already installed.
Package unzip-6.0-45.el8_4.x86_64 is already installed.
Package libxml2-2.9.7-11.el8.x86_64 is already installed.
Package openssl-1:1.1.1k-4.el8.x86_64 is already installed.
Dependencies resolved.
[...]

Complete!
```

### 2 : Conf Apache

Lu.

- Analyser la conf Apache

```bash
[roxanne@web conf]$ cat httpd.conf
# Load config files in the "/etc/httpd/conf.d" directory, if any.
IncludeOptional conf.d/*.conf
```

- Créer un VIrtualHost qui accueillera NextCloud

```bash
# création et modification du nouveau fichier de conf
[roxanne@web conf.d]$ sudo nano ajout.conf
[roxanne@web conf.d]$ cat ajout.conf
<VirtualHost *:80>
  DocumentRoot /var/www/nextcloud/html/

  ServerName  web.tp5.linux

  <Directory /var/www/nextcloud/html/>
    Require all granted
    AllowOverride All
    Options FollowSymLinks MultiViews

    <IfModule mod_dav.c>
      Dav off
    </IfModule>
  </Directory>
</VirtualHost>
```

- Configurer la racine web

```bash
# création du dossier html
[roxanne@web www]$ sudo mkdir nextcloud
[sudo] password for roxanne:
[roxanne@web www]$ cd nextcloud/
[roxanne@web nextcloud]$ sudo mkdir html
[roxanne@web nextcloud]$ cd html
[roxanne@web html]$

# on fait appartenir le dossier /nextcloud/html à l'utilisateur apache
[roxanne@web www]$ sudo chown apache nextcloud
[roxanne@web www]$ ls -l
total 0
drwxr-xr-x. 2 root   root  6 Nov 15 04:13 cgi-bin
drwxr-xr-x. 2 root   root  6 Nov 15 04:13 html
drwxr-xr-x. 3 apache root 18 Nov 26 16:45 nextcloud
[roxanne@web www]$ cd nextcloud/
[roxanne@web nextcloud]$ ls -l
total 0
drwxr-xr-x. 2 root root 6 Nov 26 16:45 html
[roxanne@web nextcloud]$ sudo chown apache html
[roxanne@web nextcloud]$ ls -l
total 0
drwxr-xr-x. 2 apache root 6 Nov 26 16:45 html
```

- Configurer PHP

```bash
# on récupère le fuseau horaire
[roxanne@web nextcloud]$ timedatectl
               Local time: Fri 2021-11-26 16:52:27 CET
           Universal time: Fri 2021-11-26 15:52:27 UTC
                 RTC time: Fri 2021-11-26 15:52:27
                Time zone: Europe/Paris (CET, +0100)
System clock synchronized: no
              NTP service: inactive
          RTC in local TZ: no

# on modifie la date dans le fichier en précisant notre fuseau horaire
[roxanne@web php74]$ sudo nano php.ini
[sudo] password for roxanne:

# on vérifie la modification
[roxanne@web php74]$ grep "date.timezone" php.ini
; http://php.net/date.timezone
date.timezone = "Europe/Paris"
```

### 3 : Install NextCloud

- Récupérer NextCloud

```bash
# on récupère NextCloud
[roxanne@web php74]$ cd
[roxanne@web ~]$ curl -SLO https://download.nextcloud.com/server/releases/nextcloud-21.0.1.zip
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  148M  100  148M    0     0  15.5M      0  0:00:09  0:00:09 --:--:-- 19.5M
[roxanne@web ~]$ ls
nextcloud-21.0.1.zip
```

- Ranger la chambre

```bash
# on extrait le contenu du fichier NextCloud
[roxanne@web nextcloud]$ unzip nextcloud-21.0.1.zip

# on déplace le contenu dans la racine web
[roxanne@web ~]$ sudo mv nextcloud/* /var/www/nextcloud/html/
[roxanne@web nextcloud]$ sudo mv .htaccess /var/www/nextcloud/html/
[roxanne@web nextcloud]$ ls -a
.  ..  .user.ini
[roxanne@web nextcloud]$ sudo mv .user.ini /var/www/nextcloud/html/
[roxanne@web nextcloud]$ ls -a
.  ..

# on modifie les permissions des fichiers pour qu'ils appartiennent à l'utilisateur et au groupe apache
[roxanne@web httpd]$ sudo chown apache:apache -R /var/www/nextcloud/html/
[sudo] password for roxanne:
[roxanne@web httpd]$ ls -al /var/www/nextcloud/html/
total 128
drwxr-xr-x. 13 apache apache  4096 Nov 26 17:17 .
drwxr-xr-x.  3 apache root      18 Nov 26 16:45 ..
drwxr-xr-x. 43 apache apache  4096 Apr  8  2021 3rdparty
drwxr-xr-x. 47 apache apache  4096 Apr  8  2021 apps
-rw-r--r--.  1 apache apache 17900 Apr  8  2021 AUTHORS
drwxr-xr-x.  2 apache apache    67 Apr  8  2021 config
-rw-r--r--.  1 apache apache  3900 Apr  8  2021 console.php
-rw-r--r--.  1 apache apache 34520 Apr  8  2021 COPYING
drwxr-xr-x. 22 apache apache  4096 Apr  8  2021 core
-rw-r--r--.  1 apache apache  5122 Apr  8  2021 cron.php
-rw-r--r--.  1 apache apache  2734 Apr  8  2021 .htaccess
-rw-r--r--.  1 apache apache   156 Apr  8  2021 index.html
-rw-r--r--.  1 apache apache  2960 Apr  8  2021 index.php
drwxr-xr-x.  6 apache apache   125 Apr  8  2021 lib
-rw-r--r--.  1 apache apache   283 Apr  8  2021 occ
drwxr-xr-x.  2 apache apache    23 Apr  8  2021 ocm-provider
drwxr-xr-x.  2 apache apache    55 Apr  8  2021 ocs
drwxr-xr-x.  2 apache apache    23 Apr  8  2021 ocs-provider
-rw-r--r--.  1 apache apache  3144 Apr  8  2021 public.php
-rw-r--r--.  1 apache apache  5341 Apr  8  2021 remote.php
drwxr-xr-x.  4 apache apache   133 Apr  8  2021 resources
-rw-r--r--.  1 apache apache    26 Apr  8  2021 robots.txt
-rw-r--r--.  1 apache apache  2446 Apr  8  2021 status.php
drwxr-xr-x.  3 apache apache    35 Apr  8  2021 themes
drwxr-xr-x.  2 apache apache    43 Apr  8  2021 updater
-rw-r--r--.  1 apache apache   101 Apr  8  2021 .user.ini
-rw-r--r--.  1 apache apache   382 Apr  8  2021 version.php

# on supprime les archives de fichier
[roxanne@web ~]$ rm -rf nextcloud
[roxanne@web ~]$ rm nextcloud-21.0.1.zip
[roxanne@web ~]$ ls
```

### 4 : Test

- Modifier le fichier ```hosts``` de votre PC

```bash
#on modifie le fichier hosts sur windows

# on relance le service httpd après toutes les modifications
[roxanne@web httpd]$ sudo systemctl restart httpd
```

- Tester l'accès à NextCloud et finaliser son installation

```bash
# on vérifie que le site fonctionne et que NextCloud est bien installé dessus
[roxanne@web httpd]$ curl http://web.tp5.linux
<!DOCTYPE html>
<html class="ng-csp" data-placeholder-focus="false" lang="en" data-locale="en" >
        <head
 data-requesttoken="HLZLSzYxCvYmi8SMlH/s1gTb/n345NdOb7MRP7NWKlQ=:XZ0PIEQEYsZX/pblzQefuXWrpkiQk6YjRNpJVYEyZx4=">
                <meta charset="utf-8">
                <title>
                Nextcloud               </title>
                <meta http-equiv="X-UA-Compatible" content="IE=edge">
                <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0">
                                <meta name="apple-itunes-app" content="app-id=1125420102">
                                <meta name="theme-color" content="#0082c9">
                <link rel="icon" href="/core/img/favicon.ico">
                <link rel="apple-touch-icon" href="/core/img/favicon-touch.png">
                <link rel="mask-icon" sizes="any" href="/core/img/favicon-mask.svg" color="#0082c9">
                <link rel="manifest" href="/core/img/manifest.json">
                <link rel="stylesheet" href="/core/css/guest.css?v=ba222ded25d957b900c03bef914333cd">
[...]                
```

