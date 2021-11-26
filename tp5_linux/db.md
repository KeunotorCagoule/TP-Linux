## I : Setup DB

### 1 : Install MariaDB

- Installer MariaDB sur la machine ```db.tp5.linux```

```bash
# installation de MariaDB
[roxanne@dp ~]$ sudo dnf install mariadb-server
[sudo] password for roxanne:
Rocky Linux 8 - AppStream                                                               9.6 kB/s | 4.8 kB     00:00
Rocky Linux 8 - AppStream                                                               5.2 MB/s | 8.2 MB     00:01
Rocky Linux 8 - BaseOS                                                                  8.5 kB/s | 4.3 kB     00:00
Rocky Linux 8 - BaseOS                                                                  3.0 MB/s | 3.5 MB     00:01
Rocky Linux 8 - Extras                                                                  7.2 kB/s | 3.5 kB     00:00
Rocky Linux 8 - Extras                                                                   15 kB/s |  10 kB     00:00
Dependencies resolved.
```
- Le service MariaDB

```bash
# lancement du service MariaDB
[roxanne@dp ~]$ sudo systemctl start mariadb

# lancement du service MariaDB au démarrage
[roxanne@dp ~]$ sudo systemctl enable mariadb
Created symlink /etc/systemd/system/mysql.service → /usr/lib/systemd/system/mariadb.service.
Created symlink /etc/systemd/system/mysqld.service → /usr/lib/systemd/system/mariadb.service.
Created symlink /etc/systemd/system/multi-user.target.wants/mariadb.service → /usr/lib/systemd/system/mariadb.service.

# vérification du lancement du service MariaDB
[roxanne@dp ~]$ systemctl status mariadb
● mariadb.service - MariaDB 10.3 database server
   Loaded: loaded (/usr/lib/systemd/system/mariadb.service; disabled; vendor preset: disabled)
   Active: active (running) since Thu 2021-11-25 17:10:40 CET; 12s ago
     Docs: man:mysqld(8)
           https://mariadb.com/kb/en/library/systemd/
  Process: 4763 ExecStartPost=/usr/libexec/mysql-check-upgrade (code=exited, status=0/SUCCESS)
  Process: 4628 ExecStartPre=/usr/libexec/mysql-prepare-db-dir mariadb.service (code=exited, status=0/SUCCESS)
  Process: 4604 ExecStartPre=/usr/libexec/mysql-check-socket (code=exited, status=0/SUCCESS)
 Main PID: 4731 (mysqld)
   Status: "Taking your SQL requests now..."
    Tasks: 30 (limit: 4947)
   Memory: 83.9M
   CGroup: /system.slice/mariadb.service
           └─4731 /usr/libexec/mysqld --basedir=/usr
[...]           
```

```bash
# la base de données écoute sur le port 3306
[roxanne@dp ~]$ sudo ss -lptn
State     Recv-Q    Send-Q        Local Address:Port         Peer Address:Port    Process
[...]
LISTEN    0         80                        *:3306                    *:*        users:(("mysqld",pid=4731,fd=21))
[...]

# le processus associé à MariaDB est lancé par l'utilisateur mysql
[roxanne@dp ~]$ ps -ef | grep mysql
mysql       4731       1  0 17:10 ?        00:00:00 /usr/libexec/mysqld --basedir=/usr
roxanne     4865    1591  0 17:19 pts/0    00:00:00 grep --color=auto mysql
```

- Firewall

```bash
# ouverture du port utilisé par MySQL
[roxanne@dp ~]$ sudo firewall-cmd --add-port=3306/tcp --permanent
success
```

### 2 : Conf MariaDB

- Configuration élémentaire de base

```bash
- Assigner un mot de passe à root ? Oui, on initialise root avec un mot de passe complexe.
- Enlever les utilisateurs anonymes ? Oui, comme ça on connait l'identité de chaque utilisateur et en cas de casse c'est plus facile pour savoir d'où vient l'erreur.
- Enlever la connexion à root à distance ? Oui, comme ça seul les personnes ayant accès à la machine physique peuvent s'y connecter pour plus de sécurité.
- Supprimer la base de données test et y accéder ? Oui, pour que l'accès à la base de données soit restreint.
- Faut-il appliquer immédiatement les changements ? Oui.
```

- Préparation de la base en vue de l'utilisation par NextCloud

```bash
# connexion à la base de données
[roxanne@dp ~]$ sudo mysql -u root -p
[sudo] password for roxanne:
Enter password:
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 21
Server version: 10.3.28-MariaDB MariaDB Server
[...]
```

```sql
MariaDB [(none)]> CREATE USER 'nextcloud'@'10.5.1.11' IDENTIFIED BY 'meow';
Query OK, 0 rows affected (0.001 sec)

MariaDB [(none)]> CREATE DATABASE IF NOT EXISTS nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
Query OK, 1 row affected (0.001 sec)

MariaDB [(none)]> GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'10.5.1.11';
Query OK, 0 rows affected (0.000 sec)

MariaDB [(none)]> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.000 sec)
```

- Installer sur la machine ```web.tp5.linux``` la commande ```mysql```

```bash
[roxanne@web ~]$ dnf provides mysql
Rocky Linux 8 - AppStream                                               5.0 MB/s | 8.2 MB     00:01
Rocky Linux 8 - BaseOS                                                  3.5 MB/s | 3.5 MB     00:00
Rocky Linux 8 - Extras                                                   13 kB/s |  10 kB     00:00
mysql-8.0.26-1.module+el8.4.0+652+6de068a7.x86_64 : MySQL client programs and shared libraries
Repo        : @System
Matched from:
Provide    : mysql = 8.0.26-1.module+el8.4.0+652+6de068a7

mysql-8.0.26-1.module+el8.4.0+652+6de068a7.x86_64 : MySQL client programs and shared libraries
Repo        : appstream
Matched from:
Provide    : mysql = 8.0.26-1.module+el8.4.0+652+6de068a7

[roxanne@web ~]$ sudo dnf install mysql
[sudo] password for roxanne:
Last metadata expiration check: 1:28:49 ago on Thu 25 Nov 2021 04:28:19 PM CET.
[...]
```

- Tester la connexion

```bash
# connexion à la base  de données sous l'utilisateur nextcloud
[roxanne@web ~]$ mysql --host=10.5.1.12 -P 3306 --user=nextcloud -p -D nextcloud
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 11
Server version: 5.5.5-10.3.28-MariaDB MariaDB Server

Copyright (c) 2000, 2021, Oracle and/or its affiliates.
```

```sql
# la base de données est vide
mysql> SHOW TABLES
    ->
    ->
```