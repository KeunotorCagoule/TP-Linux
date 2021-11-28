## III : Bonus

### 1 : Mettre en place du HTTPS sur le serveur web

```bash
# on vérifie que le paquet mod_ssl est bien installé sur la machine (module permettant de faire du SSL avec Apache)
[roxanne@web ~]$ sudo dnf install mod_ssl
[sudo] password for roxanne:
Last metadata expiration check: 0:17:34 ago on Sun 28 Nov 2021 05:57:19 PM CET.
Package mod_ssl-1:2.4.37-43.module+el8.5.0+714+5ec56ee8.x86_64 is already installed.
Dependencies resolved.
Nothing to do.
Complete!

# on active le module mod_ssl
[roxanne@web ~]$ sudo apachectl restart httpd 

# on vérifie que le mod_ssl est bien activé
[roxanne@web ~]$ apachectl -M | grep ssl
 ssl_module (shared)
```

```bash
# on cherche le port à ouvrir, le port pour HTTPS est 443, ce n'est pas le même que celui pour HTTP car HTTP n'est pas crypté
[roxanne@web ~]$ sudo ss -lptn | grep httpd
LISTEN 0      128                *:80              *:*    users:(("httpd",pid=4314,fd=4),("httpd",pid=4313,fd=4),("httpd",pid=4312,fd=4),("httpd",pid=4309,fd=4))
LISTEN 0      128                *:443             *:*    users:(("httpd",pid=4314,fd=8),("httpd",pid=4313,fd=8),("httpd",pid=4312,fd=8),("httpd",pid=4309,fd=8))

# on ouvre le port 443 et on recharge pour garder les modifications
[roxanne@web ~]$ sudo firewall-cmd --add-port=443/tcp --permanent
[sudo] password for roxanne:
success
[roxanne@web ~]$ sudo firewall-cmd --reload
success
```

```bash
# on copie le fichier de configuration ssl
[roxanne@web conf.d]$ sudo cp ssl.conf ajoutssl.conf

# on modifie le fichier en y ajoutant la configuration du site
[roxanne@web conf.d]$ sudo nano ajoutssl.conf
[...]
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
[...]

# on supprime le fichier ssl.conf pour éviter les conflits sur le même port
[roxanne@web conf.d]$ sudo rm ssl.conf

# on relance le service
[roxanne@web conf.d]$ sudo apachectl restart
[roxanne@web conf.d]$ apachectl status 
● httpd.service - The Apache HTTP Server
   Loaded: loaded (/usr/lib/systemd/system/httpd.service; enabled; vendor preset: disabled)
  Drop-In: /usr/lib/systemd/system/httpd.service.d
           └─php74-php-fpm.conf
   Active: active (running) since Sun 2021-11-28 18:51:26 CET; 4s ago
     Docs: man:httpd.service(8)
 Main PID: 5411 (httpd)
   Status: "Started, listening on: port 443, port 80"
    Tasks: 213 (limit: 4947)
   Memory: 24.8M
   CGroup: /system.slice/httpd.service
           ├─5411 /usr/sbin/httpd -DFOREGROUND
           ├─5413 /usr/sbin/httpd -DFOREGROUND
           ├─5414 /usr/sbin/httpd -DFOREGROUND
           ├─5415 /usr/sbin/httpd -DFOREGROUND
           └─5416 /usr/sbin/httpd -DFOREGROUND

Nov 28 18:51:26 web.tp5.linux systemd[1]: httpd.service: Succeeded.
Nov 28 18:51:26 web.tp5.linux systemd[1]: Stopped The Apache HTTP Server.
Nov 28 18:51:26 web.tp5.linux systemd[1]: Starting The Apache HTTP Server...
Nov 28 18:51:26 web.tp5.linux systemd[1]: Started The Apache HTTP Server.
Nov 28 18:51:26 web.tp5.linux httpd[5411]: Server configured, listening on: port 443, port 80
```

La connexion reste non-sécurisée car il n'y a pas de tiers de confiance.

### 2 : Mettre en place de la répartition de charge

```bash
# on clone la VM web.tp5.linux et on change son nom et son adresse IP

# on modifie le fichier de conf du site pour y avoir accès
[roxanne@deux config]$ sudo nano config.php
[roxanne@deux config]$ sudo cat config.php
<?php
$CONFIG = array (
  'instanceid' => 'ocys2pofssgh',
  'passwordsalt' => 'IWQ1ifxoE3sxyytjJ/5V41kw+Nxe23',
  'secret' => 'sySr0PkibrEAV6nTdYk/OlLElNI3WDgpBDTsEE6sa5Pv7fDk',
  'trusted_domains' =>
  array (
    0 => 'deux.tp5.linux',
  ),
  'datadirectory' => '/var/www/nextcloud/html/data',
  'dbtype' => 'sqlite3',
  'version' => '21.0.1.1',
  'overwrite.cli.url' => 'http://deux.tp5.linux',
  'installed' => true,
);

# on ajoute l'ip et le nom de domaine dans la liste de l'ordinateur qui fait des requêtes

# on crée encore une nouvelle VM qu'on appelle rocky.proxy
```

```bash
# on installe mod_ssl
[roxanne@rocky ~]$ sudo dnf install mod_ssl
Last metadata expiration check: 0:03:07 ago on Sun 28 Nov 2021 07:46:54 PM CET.
Dependencies resolved.
========================================================================================================
 Package         Architecture   Version                                         Repository         Size
========================================================================================================
Installing:
 mod_ssl         x86_64         1:2.4.37-43.module+el8.5.0+714+5ec56ee8         appstream         135 k

Transaction Summary
========================================================================================================
Install  1 Package

Total download size: 135 k
Installed size: 266 k
[...]

# on relance le service pour appliquer les modifications
[roxanne@rocky ~]$ sudo apachectl restart
[roxanne@rocky ~]$ apachectl status
● httpd.service - The Apache HTTP Server
   Loaded: loaded (/usr/lib/systemd/system/httpd.service; disabled; vendor preset: disabled)
   Active: active (running) since Sun 2021-11-28 19:53:45 CET; 2s ago
     Docs: man:httpd.service(8)
 Main PID: 2353 (httpd)
   Status: "Started, listening on: port 443, port 80"
    Tasks: 213 (limit: 4947)
   Memory: 24.9M
   CGroup: /system.slice/httpd.service
           ├─2353 /usr/sbin/httpd -DFOREGROUND
           ├─2355 /usr/sbin/httpd -DFOREGROUND
           ├─2356 /usr/sbin/httpd -DFOREGROUND
           ├─2357 /usr/sbin/httpd -DFOREGROUND
           └─2358 /usr/sbin/httpd -DFOREGROUND

Nov 28 19:53:45 rocky.proxy systemd[1]: httpd.service: Succeeded.
Nov 28 19:53:45 rocky.proxy systemd[1]: Stopped The Apache HTTP Server.
Nov 28 19:53:45 rocky.proxy systemd[1]: Starting The Apache HTTP Server...
Nov 28 19:53:45 rocky.proxy systemd[1]: Started The Apache HTTP Server.
Nov 28 19:53:45 rocky.proxy httpd[2353]: Server configured, listening on: port 443, port 80
```

```bash
# on ouvre le port 443 pour le HTTPS
[roxanne@rocky ~]$ sudo firewall-cmd --add-port=443/tcp --permanent
success
[roxanne@rocky ~]$ sudo firewall-cmd --reload
success
```

```bash
# on vérifie que les modules du proxy sont déjà installés
[roxanne@rocky ~]$ grep "mod_proxy" /etc/httpd/conf.modules.d/00-proxy.conf
LoadModule proxy_module modules/mod_proxy.so
LoadModule proxy_ajp_module modules/mod_proxy_ajp.so
LoadModule proxy_balancer_module modules/mod_proxy_balancer.so
LoadModule proxy_connect_module modules/mod_proxy_connect.so
LoadModule proxy_express_module modules/mod_proxy_express.so
LoadModule proxy_fcgi_module modules/mod_proxy_fcgi.so
LoadModule proxy_fdpass_module modules/mod_proxy_fdpass.so
LoadModule proxy_ftp_module modules/mod_proxy_ftp.so
LoadModule proxy_http_module modules/mod_proxy_http.so
LoadModule proxy_hcheck_module modules/mod_proxy_hcheck.so
LoadModule proxy_scgi_module modules/mod_proxy_scgi.so
LoadModule proxy_uwsgi_module modules/mod_proxy_uwsgi.so
LoadModule proxy_wstunnel_module modules/mod_proxy_wstunnel.so

# tout ce qui interrogera le "/" va se faire renvoyer sur le serveur ProxyPass ou ProxyPassReverse
[roxanne@rocky ~]$ sudo nano /etc/httpd/conf.d/revers_proxy.conf
[sudo] password for roxanne:
[roxanne@rocky ~]$ cat /etc/httpd/conf.d/revers_proxy.conf
<IfModule mod_proxy.c>
    ProxyRequests Off
    <Proxy *>
        Require all granted
    </Proxy>
    ProxyPass / http://web.tp5.linux/
    ProxyPassReverse / http://web.tp5.linux/
</IfModule>
```

```bash
# on relance pour appliquer les modifications
[roxanne@rocky ~]$ sudo systemctl restart httpd
[roxanne@rocky ~]$ systemctl status httpd
● httpd.service - The Apache HTTP Server
   Loaded: loaded (/usr/lib/systemd/system/httpd.service; disabled; vendor preset: disabled)
   Active: active (running) since Sun 2021-11-28 20:06:44 CET; 14s ago
     Docs: man:httpd.service(8)
 Main PID: 2625 (httpd)
   Status: "Running, listening on: port 443, port 80"
    Tasks: 213 (limit: 4947)
   Memory: 24.9M
   CGroup: /system.slice/httpd.service
           ├─2625 /usr/sbin/httpd -DFOREGROUND
           ├─2628 /usr/sbin/httpd -DFOREGROUND
           ├─2629 /usr/sbin/httpd -DFOREGROUND
           ├─2630 /usr/sbin/httpd -DFOREGROUND
           └─2631 /usr/sbin/httpd -DFOREGROUND

Nov 28 20:06:43 rocky.proxy systemd[1]: httpd.service: Succeeded.
Nov 28 20:06:43 rocky.proxy systemd[1]: Stopped The Apache HTTP Server.
Nov 28 20:06:43 rocky.proxy systemd[1]: Starting The Apache HTTP Server...
Nov 28 20:06:44 rocky.proxy systemd[1]: Started The Apache HTTP Server.
Nov 28 20:06:44 rocky.proxy httpd[2625]: Server configured, listening on: port 443, port 80
```

```bash
# on modifie la configuration pour rajouter les deux nodes sur lesquels on envoie les requêtes
[roxanne@rocky ~]$ sudo nano /etc/httpd/conf.d/revers_proxy.conf
[roxanne@rocky ~]$ cat /etc/httpd/conf.d/revers_proxy.conf
<IfModule mod_proxy.c>
    ProxyRequests Off
    <Proxy *>
        Require all granted
    </Proxy>
        <proxy balancer://cluster>
                BalancerMember http://web.tp5.linux/ loadfactor=1
                BalancerMember http://deux.tp5.linux/ loadfactor=1
                ProxySet lbmethod=byrequests
        </proxy>
    ProxyPass / "balancer://cluster/"
    ProxyPassReverse / "balancer://cluster/"
</IfModule>

# on relance le service
[roxanne@rocky ~]$ sudo apachectl restart
[roxanne@rocky ~]$ apachectl status
● httpd.service - The Apache HTTP Server
   Loaded: loaded (/usr/lib/systemd/system/httpd.service; disabled; vendor preset: disabled)
   Active: active (running) since Sun 2021-11-28 20:32:53 CET; 22s ago
     Docs: man:httpd.service(8)
 Main PID: 4202 (httpd)
   Status: "Running, listening on: port 443, port 80"
    Tasks: 213 (limit: 4947)
   Memory: 25.0M
   CGroup: /system.slice/httpd.service
           ├─4202 /usr/sbin/httpd -DFOREGROUND
           ├─4203 /usr/sbin/httpd -DFOREGROUND
           ├─4204 /usr/sbin/httpd -DFOREGROUND
           ├─4205 /usr/sbin/httpd -DFOREGROUND
           └─4206 /usr/sbin/httpd -DFOREGROUND

Nov 28 20:32:53 rocky.proxy systemd[1]: Starting The Apache HTTP Server...
Nov 28 20:32:53 rocky.proxy systemd[1]: Started The Apache HTTP Server.
Nov 28 20:32:53 rocky.proxy httpd[4202]: Server configured, listening on: port 443, port 80

# dans les logs on voit que le proxy interroge bien les deux serveurs, par contre la redirection après s'être connecté ne se fait pas très bien.. ):
```

### 3 : Mettre en place une sauvegarde de la base de données

```bash
# on crée un repertoire bin dans lequel on crée le script
[roxanne@web ~]$ sudo mkdir bin
[sudo] password for roxanne:
[roxanne@web ~]$ cd bin/
[roxanne@web bin]$ sudo nano sauvegarde.sh
```

```bash
[roxanne@web bin]$ cat sauvegarde.sh
#!/bin/bash

host=10.5.1.12
user=nextcloud
password=meow
database=nextcloud

mysqldump --user="$user" --password="$password" --databases "$database" -h "$host" > /home/roxanne/backup/backup.sql
```

```bash
[roxanne@web backup]$ cat backup.sql
-- MySQL dump 10.13  Distrib 8.0.26, for Linux (x86_64)
--
-- Host: 10.5.1.12    Database: nextcloud
-- ------------------------------------------------------
-- Server version       5.5.5-10.3.28-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `nextcloud`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `nextcloud` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;

USE `nextcloud`;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-11-28 21:44:01
```
