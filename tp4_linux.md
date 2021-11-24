# TP 4 : Une distribution orientée serveur

## I : Intro

Lu.

## II : Checklist

- Choisir et définir une IP à la VM
```bash
[roxanne@localhost network-scripts]$ cat ifcfg-enp0s8
# on configure l'interface host-only
NAME=enp0s8
BOOTPROTO=static
DEVICE=enp0s8
ONBOOT=yes
IPADDR=10.250.1.4
NETMASK=255.255.255.0
```

```bash
[roxanne@localhost ~]$ ip a
# vérification des changements
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:b0:07:b5 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic noprefixroute enp0s3
       valid_lft 85561sec preferred_lft 85561sec
    inet6 fe80::a00:27ff:feb0:7b5/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:a0:be:cd brd ff:ff:ff:ff:ff:ff
    inet 10.250.1.4/24 brd 10.250.1.255 scope global noprefixroute enp0s8
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fea0:becd/64 scope link
       valid_lft forever preferred_lft forever
```

- Connexion SSH fonctionelle 
```bash
[roxanne@localhost /]$ systemctl status sshd
● sshd.service - OpenSSH server daemon
   Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; vendor preset: enabled)
   Active: active (running) since Tue 2021-11-23 16:29:44 CET; 22min ago
     Docs: man:sshd(8)
           man:sshd_config(5)
 Main PID: 857 (sshd)
    Tasks: 1 (limit: 4947)
   Memory: 4.2M
   CGroup: /system.slice/sshd.service
           └─857 /usr/sbin/sshd -D -oCiphers=aes256-gcm@openssh.com,chacha20-poly1305@openssh.com,aes25>
Nov 23 16:29:44 localhost.localdomain sshd[857]: Server listening on :: port 22.
Nov 23 16:29:44 localhost.localdomain systemd[1]: Started OpenSSH server daemon.
[...]
```

```bash
PS C:\Users\33785> @echo off
# on consulte la clef shh
type C:\Users\33785\.ssh\id_rsa.pub

ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDF2V/OJ64APf3cceJfBw8lqBDpmzSHqhuWJaGJKp4YSYKYgbZwJr0yWRxHAJDLWC0OdyS+bvlCzF2nv2SyOhaUT3LNjoLv980JLaVP5kGguITf7/IJc3fY4pQZrIGQ2BzVTn3uTIHBiv5pvOD9ZOpMQD3hkGEsuGaivWosmL6nleZSHtWs+XUNhQYlhvmW3fXssit/pHtDk3hImeuFUa8LkJAv7c2ULr+PICm8xY98xJj5oG8Ate68jnG0bKLy04ArIwpqURg+V81U34iZqBRnLJkvuL1uL6bYgHEudvgJY0pmv0g9Wtpr6AfM1fGhqfKzIpT0m1LqPjZm/j4nchBeDXV3QnV8rOxHkLJ8exnuT8fbsYPOPvtXNaBmIY5Bm3GYBnZCj2YkJI2NcRK1giHFhifv3iTQw3goW9coxs4IRe6ZFMRHoO+JKhGyBvQuxZBWln4NnRPenVp30ADdGAF1qzL1KgFJNLHCbA61kkrkAH5/SacvN3NROeQ19XYm1LwBJto7yRbOEzlodSk4B6YwnrS0C8J2fzIJyZB4RmEvUVXYaTSSWKGSc0G+BzPXWPZtCnIrVwDXXzkCdOs8mOoSJNdJAIUfkHpfgAayrP7cM63Q5UT61n7RCTQx2FhcZUXLVlL36JQlANEfGL6EmmjCcjb3vSFnS9Y/CvujyLkJ+w== 33785@LAPTOP-1M7RKAHP

```

```bash
[roxanne@localhost .ssh]$ cat authorized_keys
# on affiche les clefs autorisées par la machine
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDF2V/OJ64APf3cceJfBw8lqBDpmzSHqhuWJaGJKp4YSYKYgbZwJr0yWRxHAJDLWC0OdyS+bvlCzF2nv2SyOhaUT3LNjoLv980JLaVP5kGguITf7/IJc3fY4pQZrIGQ2BzVTn3uTIHBiv5pvOD9ZOpMQD3hkGEsuGaivWosmL6nleZSHtWs+XUNhQYlhvmW3fXssit/pHtDk3hImeuFUa8LkJAv7c2ULr+PICm8xY98xJj5oG8Ate68jnG0bKLy04ArIwpqURg+V81U34iZqBRnLJkvuL1uL6bYgHEudvgJY0pmv0g9Wtpr6AfM1fGhqfKzIpT0m1LqPjZm/j4nchBeDXV3QnV8rOxHkLJ8exnuT8fbsYPOPvtXNaBmIY5Bm3GYBnZCj2YkJI2NcRK1giHFhifv3iTQw3goW9coxs4IRe6ZFMRHoO+JKhGyBvQuxZBWln4NnRPenVp30ADdGAF1qzL1KgFJNLHCbA61kkrkAH5/SacvN3NROeQ19XYm1LwBJto7yRbOEzlodSk4B6YwnrS0C8J2fzIJyZB4RmEvUVXYaTSSWKGSc0G+BzPXWPZtCnIrVwDXXzkCdOs8mOoSJNdJAIUfkHpfgAayrP7cM63Q5UT61n7RCTQx2FhcZUXLVlL36JQlANEfGL6EmmjCcjb3vSFnS9Y/CvujyLkJ+w== 33785@LAPTOP-1M7RKAHP 
```

- Accès internet
```bash
[roxanne@localhost ~]$ ping 1.1.1.1 -c 4
PING 1.1.1.1 (1.1.1.1) 56(84) bytes of data.
64 bytes from 1.1.1.1: icmp_seq=1 ttl=54 time=26.6 ms
64 bytes from 1.1.1.1: icmp_seq=2 ttl=54 time=26.9 ms
64 bytes from 1.1.1.1: icmp_seq=3 ttl=54 time=27.1 ms
64 bytes from 1.1.1.1: icmp_seq=4 ttl=54 time=24.7 ms

--- 1.1.1.1 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3005ms
rtt min/avg/max/mdev = 24.724/26.346/27.110/0.974 ms
```

- Résolution de nom
```bash
[roxanne@localhost ~]$ ping ynov.com -c 4
PING ynov.com (92.243.16.143) 56(84) bytes of data.
64 bytes from xvm-16-143.dc0.ghst.net (92.243.16.143): icmp_seq=1 ttl=51 time=22.6 ms
64 bytes from xvm-16-143.dc0.ghst.net (92.243.16.143): icmp_seq=2 ttl=51 time=26.1 ms
64 bytes from xvm-16-143.dc0.ghst.net (92.243.16.143): icmp_seq=3 ttl=51 time=24.6 ms
64 bytes from xvm-16-143.dc0.ghst.net (92.243.16.143): icmp_seq=4 ttl=51 time=22.8 ms

--- ynov.com ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3004ms
rtt min/avg/max/mdev = 22.597/24.029/26.126/1.446 ms
```

- Définir ```node1.tp4.linux``` comme nom à la machine
```bash
[roxanne@node1 ~]$ cat /etc/hostname
# vérification du changement de nom de la machine
node1.tp4.linux
```

```bash
[roxanne@node1 ~]$ hostname
node1.tp4.linux
```

## III : Mettre en place un service

### 1 : Intro NGINX

Lu.

### 2 : Install

```bash
# installation de NGINX
[roxanne@node1 ~]$ sudo dnf install nginx
[sudo] password for roxanne:
Last metadata expiration check: 2:07:12 ago on Tue 23 Nov 2021 03:27:40 PM CET.
Dependencies resolved.

[roxanne@node1 ~]$ sudo systemctl start nginx

[roxanne@node1 ~]$ systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
   Active: active (running) since Tue 2021-11-23 17:37:58 CET; 12s ago
  Process: 4038 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
  Process: 4037 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
  Process: 4035 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
 Main PID: 4040 (nginx)
    Tasks: 2 (limit: 4947)
   Memory: 6.7M
   CGroup: /system.slice/nginx.service
           ├─4040 nginx: master process /usr/sbin/nginx
           └─4041 nginx: worker process
[...]           

[roxanne@node1 ~]$ sudo systemctl enable nginx
Created symlink /etc/systemd/system/multi-user.target.wants/nginx.service → /usr/lib/systemd/system/nginx.service.


```

### 3 : Analyse

- Analyser le service NGINX

```bash
[roxanne@node1 ~]$ ps -ef | grep nginx
# le processus NGINX tourne sous root
root        4040       1  0 17:37 ?        00:00:00 nginx: master process /usr/sbin/nginx
nginx       4041    4040  0 17:37 ?        00:00:00 nginx: worker process
roxanne     4128    1463  0 17:51 pts/0    00:00:00 grep --color=auto nginx

[roxanne@node1 ~]$ sudo ss -lntp | grep nginx
# le serveur web écoute derrière le port 80
LISTEN 0      128          0.0.0.0:80        0.0.0.0:*    users:(("nginx",pid=4041,fd=8),("nginx",pid=4040,fd=8))
LISTEN 0      128             [::]:80           [::]:*    users:(("nginx",pid=4041,fd=9),("nginx",pid=4040,fd=9))
```

```bash
# la racine du site web se trouve dans /usr/share/nginx/html/
[roxanne@node1 /]$ cd usr/share/nginx/html/
[roxanne@node1 html]$ ls
404.html  50x.html  index.html  nginx-logo.png  poweredby.png
```

```bash
[roxanne@node1 html]$ ls -l
# les fichiers sont bien accessibles en lecture
total 20
-rw-r--r--. 1 root root 3332 Jun 10 11:09 404.html
-rw-r--r--. 1 root root 3404 Jun 10 11:09 50x.html
-rw-r--r--. 1 root root 3429 Jun 10 11:09 index.html
-rw-r--r--. 1 root root  368 Jun 10 11:09 nginx-logo.png
-rw-r--r--. 1 root root 1800 Jun 10 11:09 poweredby.png
```

### 4 : Visite du service web

```bash
# configuration du firewall du site web
[roxanne@node1 ~]$ sudo firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: enp0s3 enp0s8
  sources:
  services: cockpit dhcpv6-client http https ssh
  ports:
  protocols:
  forward: no
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:
  
[roxanne@node1 ~]$ sudo firewall-cmd --add-port=80/tcp --permanent
success

[roxanne@node1 ~]$ sudo firewall-cmd --reload
success
```

- Tester le bon fonctionnement du service
```bash
[roxanne@node1 ~]$ curl http://10.250.1.4:80
# on a bien accès au site web
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
  <head>
    <title>Test Page for the Nginx HTTP Server on Rocky Linux</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <style type="text/css">
      /*<![CDATA[*/
      body {
        background-color: #fff;
        color: #000;
        font-size: 0.9em;
        font-family: sans-serif, helvetica;
        margin: 0;
        padding: 0;
        }
[...]
      <div class="logos">
        <a href="http://nginx.net/"
          ><img
            src="nginx-logo.png"
            alt="[ Powered by nginx ]"
            width="121"
            height="32"
        /></a>
        <a href="http://www.rockylinux.org/"><img
            src="poweredby.png"
            alt="[ Powered by Rocky Linux ]"
            width="88" height="31" /></a>

      </div>
    </div>
  </body>
</html>
```

### 5 : Modification de la configuration du serveur web

- Changer le port d'écoute

```bash
[roxanne@node1 nginx]$ sudo nano nginx.conf
# modification du port en port 8080

[roxanne@node1 nginx]$ sudo systemctl restart nginx
# application des modifications

[roxanne@node1 nginx]$ systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; vendor preset: disabled)
   Active: active (running) since Wed 2021-11-24 16:31:54 CET; 11s ago
  Process: 1677 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
  Process: 1675 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
  Process: 1673 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
 Main PID: 1679 (nginx)
    Tasks: 2 (limit: 4947)
   Memory: 3.7M
   CGroup: /system.slice/nginx.service
           ├─1679 nginx: master process /usr/sbin/nginx
           └─1680 nginx: worker process
[...]

[roxanne@node1 nginx]$ sudo ss -lntp | grep nginx
# le port est bien modifié en 8080
LISTEN 0      128          0.0.0.0:8080      0.0.0.0:*    users:(("nginx",pid=1680,fd=8),("nginx",pid=1679,fd=8))
LISTEN 0      128             [::]:8080         [::]:*    users:(("nginx",pid=1680,fd=9),("nginx",pid=1679,fd=9))

[roxanne@node1 nginx]$ sudo firewall-cmd --remove-port=80/tcp --permanent
# on ferme le port 80
success

[roxanne@node1 nginx]$ sudo firewall-cmd --add-port=8080/tcp --permanent
# on ouvre le port 8080
success

[roxanne@node1 nginx]$ sudo firewall-cmd --reload
# on applique les modifications
success

[roxanne@node1 nginx]$ curl http://10.250.1.4:8080
# on a bien accès au site web à partir du port 8080
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
  <head>
    <title>Test Page for the Nginx HTTP Server on Rocky Linux</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <style type="text/css">
      /*<![CDATA[*/
      body {
        background-color: #fff;
        color: #000;
        font-size: 0.9em;
        font-family: sans-serif, helvetica;
        margin: 0;
        padding: 0;
      }
[...]
        <a href="http://www.rockylinux.org/"><img
            src="poweredby.png"
            alt="[ Powered by Rocky Linux ]"
            width="88" height="31" /></a>

      </div>
    </div>
  </body>
</html>
```

- Changer l'utilisateur qui lance le service
```bash
[roxanne@node1 nginx]$ sudo useradd web
# on ajoute l'utilisateur web
[sudo] password for roxanne:

[roxanne@node1 nginx]$ sudo passwd web
# on ajoute un mot de passe à l'utilisateur web
Changing password for user web.
New password:
Retype new password:
passwd: all authentication tokens updated successfully.

[roxanne@node1 etc]$ cat passwd
# le homedir de web est bien /home/web
[...]
web:x:1001:1001::/home/web:/bin/bash

[roxanne@node1 nginx]$ sudo nano nginx.conf
# modification du fichier de conf
[sudo] password for roxanne:
[roxanne@node1 nginx]$ [roxanne@node1 nginx]$ sudo systemctl restart nginx
# on relance NGINX
[roxanne@node1 nginx]$ cat nginx.conf
# For more information on configuration, see:
#   * Official English Documentation: http://nginx.org/en/docs/
#   * Official Russian Documentation: http://nginx.org/ru/docs/

user web;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;
[...]

[roxanne@node1 /]$ ps -ef | grep nginx
# le processus tourne bien sous l'utilisateur web
root        1953       1  0 18:59 ?        00:00:00 nginx: master process /usr/sbin/nginx
web         1954    1953  0 18:59 ?        00:00:00 nginx: worker process
roxanne     1989    1497  0 19:09 pts/0    00:00:00 grep --color=auto nginx
```

- Changer l'emplacement de la racine web
```bash
# création des dossiers et du fichier
[roxanne@node1 var]$ sudo mkdir www
[sudo] password for roxanne:
[roxanne@node1 var]$ cd www/
[roxanne@node1 www]$ ls
[roxanne@node1 www]$ sudo mkdir super_site_web
[roxanne@node1 www]$ cd super_site_web/
[roxanne@node1 super_site_web]$ sudo nano index.html

# on ajoute le propriétaire web
[roxanne@node1 www]$ sudo chown web super_site_web
[roxanne@node1 super_site_web]$ sudo chown web index.html
[roxanne@node1 super_site_web]$ ls -l
total 4
-rw-r--r--. 1 web root 55 Nov 24 19:17 index.html

[roxanne@node1 nginx]$ sudo nano nginx.conf
# on modifie le fichier conf
[roxanne@node1 nginx]$ cat nginx.conf
[...]
    server {
        listen       8080 default_server;
        listen       [::]:8080 default_server;
        server_name  _;
        root         /var/www/super_site_web;
[...]

[roxanne@node1 nginx]$ sudo systemctl restart nginx

[roxanne@node1 nginx]$ curl http://10.250.1.4:8080
<h1>toto</h1>
<h2>coucouuuuuu</h2>
<h3>sympaaaaaa</h3>
```
