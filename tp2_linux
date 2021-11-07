# TP2 : Explorer et manipuler le système

## Intro

### Changer le nom de la machine

```bash
roxanne@roxanne-VirtualBox:~$ sudo hostname NODE1.TP2.LINUX
# déco/reco
roxanne@roxanne-VirtualBox:~$ sudo nano /etc/hostname
# modification du fichier
roxanne@NODE1:~$ cat /etc/hostname
NODE1.TP2.LINUX
```

### Config réseau fonctionnelle

- ping 1.1.1.1
```
roxanne@NODE1:~$ ping 1.1.1.1 -c 4
# on envoie 4 ping au lieu de 56 par défaut

PING 1.1.1.1 (1.1.1.1) 56(84) bytes of data.
64 octets de 1.1.1.1 : icmp_seq=1 ttl=54 temps=24.2 ms
64 octets de 1.1.1.1 : icmp_seq=2 ttl=54 temps=27.5 ms
64 octets de 1.1.1.1 : icmp_seq=3 ttl=54 temps=28.1 ms
64 octets de 1.1.1.1 : icmp_seq=4 ttl=54 temps=25.2 ms

--- statistiques ping 1.1.1.1 ---
4 paquets transmis, 4 reçus, 0 % paquets perdus, temps 3004 ms
rtt min/avg/max/mdev = 24.160/26.249/28.148/1.640 ms
```

- ping ynov.com
``` 
roxanne@NODE1:~$ ping ynov.com -c 4

PING ynov.com (92.243.16.143) 56(84) bytes of data.
64 octets de xvm-16-143.dc0.ghst.net (92.243.16.143) : icmp_seq=1 ttl=50 temps=24.9 ms
64 octets de xvm-16-143.dc0.ghst.net (92.243.16.143) : icmp_seq=2 ttl=50 temps=25.1 ms
64 octets de xvm-16-143.dc0.ghst.net (92.243.16.143) : icmp_seq=3 ttl=50 temps=23.7 ms
64 octets de xvm-16-143.dc0.ghst.net (92.243.16.143) : icmp_seq=4 ttl=50 temps=23.9 ms

--- statistiques ping ynov.com ---
4 paquets transmis, 4 reçus, 0 % paquets perdus, temps 3006 ms
rtt min/avg/max/mdev = 23.723/24.434/25.136/0.612 ms
```
- ping 198.168.251.10 (IP VM)
```
C:\Users\33785>ping 192.168.251.10

Envoi d’une requête 'Ping'  192.168.251.10 avec 32 octets de données :
Réponse de 192.168.251.10 : octets=32 temps<1ms TTL=64
Réponse de 192.168.251.10 : octets=32 temps<1ms TTL=64
Réponse de 192.168.251.10 : octets=32 temps<1ms TTL=64
Réponse de 192.168.251.10 : octets=32 temps<1ms TTL=64

Statistiques Ping pour 192.168.251.10:
    Paquets : envoyés = 4, reçus = 4, perdus = 0 (perte 0%),
Durée approximative des boucles en millisecondes :
    Minimum = 0ms, Maximum = 0ms, Moyenne = 0ms
```

## Partie 1

### Installation du serveur

- Installer le paquet `open ssh`
```bash
roxanne@NODE1:~$ sudo apt install openssh-server

[sudo] Mot de passe de roxanne :
Lecture des listes de paquets... Fait
Construction de l'arbre des dépendances
Lecture des informations d'état... Fait
openssh-server est déjà la version la plus récente (1:8.2p1-4ubuntu0.3).
0 mis à jour, 0 nouvellement installés, 0 à enlever et 96 non mis à jour.

roxanne@NODE1:~$ ssh
usage: ssh [-46AaCfGgKkMNnqsTtVvXxYy] [-B bind_interface]
           [-b bind_address] [-c cipher_spec] [-D [bind_address:]port]
           [-E log_file] [-e escape_char] [-F configfile] [-I pkcs11]
           [-i identity_file] [-J [user@]host[:port]] [-L address]
           [-l login_name] [-m mac_spec] [-O ctl_cmd] [-o option] [-p port]
           [-Q query_option] [-R address] [-S ctl_path] [-W host:port]
           [-w local_tun[:remote_tun]] destination [command]
roxanne@NODE1:~$ cd /etc/ssh
roxanne@NODE1:/etc/ssh$ ls
moduli        sshd_config         ssh_host_ecdsa_key.pub    ssh_host_rsa_key
ssh_config    sshd_config.d       ssh_host_ed25519_key      ssh_host_rsa_key.pub
ssh_config.d  ssh_host_ecdsa_key  ssh_host_ed25519_key.pub  ssh_import_id
```

### Lancement su service ssh

- Lancer le service `ssh`
```bash
roxanne@NODE1:/$ sudo systemctl start ssh
roxanne@NODE1:~$ systemctl status ssh
● ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/lib/systemd/system/ssh.service; enabled; vendor preset: enabled)
     Active: active (running) since Thu 2021-11-04 18:46:16 CET; 2h 18min ago
       Docs: man:sshd(8)
             man:sshd_config(5)
   Main PID: 521 (sshd)
      Tasks: 1 (limit: 1105)
     Memory: 1.9M
     CGroup: /system.slice/ssh.service
             └─521 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups

nov. 04 18:46:16 NODE1.TP2.LINUX systemd[1]: Starting OpenBSD Secure Shell server...
nov. 04 18:46:16 NODE1.TP2.LINUX sshd[521]: Server listening on 0.0.0.0 port 4242.
nov. 04 18:46:16 NODE1.TP2.LINUX sshd[521]: Server listening on :: port 4242.
nov. 04 18:46:16 NODE1.TP2.LINUX systemd[1]: Started OpenBSD Secure Shell server.
nov. 04 18:49:29 NODE1.TP2.LINUX sshd[924]: Accepted password for roxanne from 192.168.251.1 port 54564 ssh2
nov. 04 18:49:29 NODE1.TP2.LINUX sshd[924]: pam_unix(sshd:session): session opened for user roxanne by (uid=0)
nov. 04 19:14:16 NODE1.TP2.LINUX sshd[2488]: Accepted password for roxanne from 192.168.251.1 port 54631 ssh2
nov. 04 19:14:16 NODE1.TP2.LINUX sshd[2488]: pam_unix(sshd:session): session opened for user roxanne by (uid=0)

    
roxanne@NODE1:/$ sudo systemctl enable ssh
Synchronizing state of ssh.service with SysV service script with /lib/systemd/systemd-sysv-install.
Executing: /lib/systemd/systemd-sysv-install enable ssh    
```

### Etude du service SSH

- Analyser le service en cours de fonctionnement 
```bash
roxanne@NODE1:~$ systemctl status ssh
● ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/lib/systemd/system/ssh.service; enabled; vendor preset: enabled)
     Active: active (running) since Thu 2021-11-04 18:46:16 CET; 2h 18min ago
       Docs: man:sshd(8)
             man:sshd_config(5)
   Main PID: 521 (sshd)
      Tasks: 1 (limit: 1105)
     Memory: 1.9M
     CGroup: /system.slice/ssh.service
             └─521 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups

nov. 04 18:46:16 NODE1.TP2.LINUX systemd[1]: Starting OpenBSD Secure Shell server...
nov. 04 18:46:16 NODE1.TP2.LINUX sshd[521]: Server listening on 0.0.0.0 port 4242.
nov. 04 18:46:16 NODE1.TP2.LINUX sshd[521]: Server listening on :: port 4242.
nov. 04 18:46:16 NODE1.TP2.LINUX systemd[1]: Started OpenBSD Secure Shell server.
nov. 04 18:49:29 NODE1.TP2.LINUX sshd[924]: Accepted password for roxanne from 192.168.251.1 port 54564 ssh2
nov. 04 18:49:29 NODE1.TP2.LINUX sshd[924]: pam_unix(sshd:session): session opened for user roxanne by (uid=0)
nov. 04 19:14:16 NODE1.TP2.LINUX sshd[2488]: Accepted password for roxanne from 192.168.251.1 port 54631 ssh2
nov. 04 19:14:16 NODE1.TP2.LINUX sshd[2488]: pam_unix(sshd:session): session opened for user roxanne by (uid=0)
 
roxanne@NODE1:/$ ps -A | grep -F ssh
   1054 ?        00:00:00 ssh-agent
   1849 ?        00:00:00 sshd
   2903 ?        00:00:00 sshd
   2983 ?        00:00:00 sshd
   3469 ?        00:00:00 sshd
   3522 ?        00:00:00 sshd
   
roxanne@NODE1:/$ ss -l | grep -F ssh
u_str   LISTEN   0        4096             /run/user/1000/gnupg/S.gpg-agent.ssh 26117                                           * 0
u_str   LISTEN   0        10                         /run/user/1000/keyring/ssh 26724                                           * 0
u_str   LISTEN   0        128                   /tmp/ssh-6VtGr5BN3bs9/agent.935 26452                                           * 0
tcp     LISTEN   0        128                                           0.0.0.0:ssh                                       0.0.0.0:*
tcp     LISTEN   0        128                                              [::]:ssh                                          [::]:*   

roxanne@NODE1:/var/log$ cat syslog | grep ssh
Oct 21 16:54:44 roxanne-VirtualBox systemd[727]: Listening on GnuPG cryptographic agent (ssh-agent emulation).
Oct 21 16:54:58 roxanne-VirtualBox systemd[807]: Listening on GnuPG cryptographic agent (ssh-agent emulation).
Oct 21 16:55:09 roxanne-VirtualBox systemd[727]: gpg-agent-ssh.socket: Succeeded.
```

- Connectez vous au serveur 
```bash
C:\Users\33785>ssh roxanne@192.168.251.10
roxanne@192.168.251.10's password:
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.11.0-38-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

96 mises à jour peuvent être appliquées immédiatement.
39 de ces mises à jour sont des mises à jour de sécurité.
Pour afficher ces mises à jour supplémentaires, exécuter : apt list --upgradable

Your Hardware Enablement Stack (HWE) is supported until April 2025.
Last login: Mon Oct 25 16:24:39 2021 from 192.168.251.1
```

### Modification de la configuration du serveur

- Modifier le comportement du service
```bash
roxanne@NODE1:/etc/ssh$ sudo nano sshd_config
Include /etc/ssh/sshd_config.d/*.conf

roxanne@NODE1:/etc/ssh$ cat sshd_config
[...]
Port 4242
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::
[...]

roxanne@NODE1:~$ ss -l | grep 4242

tcp     LISTEN   0        128                                           0.0.0.0:4242                                      0.0.0.0:*                             

tcp     LISTEN   0        128                                              [::]:4242                                         [::]:*                             

```

- Connectez vous sur le nouveau port choisi

```bash
roxanne@roxanne-VirtualBox:~$ ssh -p 4242 roxanne@192.168.251.14
roxanne@192.168.251.14's password: 

Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.11.0-38-generic x86_64)
```

## Partie 2

### Installation du serveur

- Installer le paquet ```vsftpd```

```bash
roxanne@NODE1:~$ sudo apt-get install vsftpd
[sudo] Mot de passe de roxanne : 

Lecture des listes de paquets... Fait

Construction de l'arbre des dépendances       

Lecture des informations d'état... Fait

Les NOUVEAUX paquets suivants seront installés :

  vsftpd

0 mis à jour, 1 nouvellement installés, 0 à enlever et 96 non mis à jour.

Il est nécessaire de prendre 115 ko dans les archives.

Après cette opération, 338 ko d'espace disque supplémentaires seront utilisés.

Réception de :1 http://fr.archive.ubuntu.com/ubuntu focal/main amd64 vsftpd amd64 3.0.3-12 [115 kB]

115 ko réceptionnés en 0s (584 ko/s)

Préconfiguration des paquets...

[...]

Traitement des actions différées (« triggers ») pour systemd (245.4-4ubuntu3.11) ...
```

### Lancement du service FTP

- Analyser le service en cours de fonctionnement
```bash
roxanne@NODE1:~$ systemctl status vsftpd
● vsftpd.service - vsftpd FTP server

     Loaded: loaded (/lib/systemd/system/vsftpd.service; enabled; vendor preset>

     Active: active (running) since Mon 2021-11-01 17:32:53 CET; 2min 43s ago

   Main PID: 1920 (vsftpd)

      Tasks: 1 (limit: 1105)

     Memory: 528.0K

     CGroup: /system.slice/vsftpd.service

             └─1920 /usr/sbin/vsftpd /etc/vsftpd.conf
nov. 01 17:32:53 NODE1.TP2.LINUX systemd[1]: Starting vsftpd FTP server...
nov. 01 17:32:53 NODE1.TP2.LINUX systemd[1]: Started vsftpd FTP server.

roxanne@NODE1:~$ ps axuf | grep ftp
roxanne    16493  0.0  0.0  19400   668 pts/1    S+   17:37   0:00              \_ grep --color=auto ftp

root        1920  0.0  0.2   6816  3000 ?        Ss   17:32   0:00 /usr/sbin/vsftpd /etc/vsftpd.conf

roxanne@NODE1:~$ ss -l | grep ftp

tcp     LISTEN   0        32                                                  *:ftp                                             *:*                             

roxanne@NODE1:~$ grep ftp /etc/services
[...]
ftp		21/tcp
[...]

roxanne@NODE1:/$ journalctl -xe -u vsftpd
-- Logs begin at Thu 2021-10-21 16:54:32 CEST, end at Mon 2021-11-01 17:54:50 CET. --

nov. 01 17:32:53 NODE1.TP2.LINUX systemd[1]: Starting vsftpd FTP server...

-- Subject: L'unité (unit) vsftpd.service a commencé à démarrer

-- Defined-By: systemd

-- Support: http://www.ubuntu.com/support

-- 
[...]

roxanne@NODE1:/var/log$ sudo less vsftpd.log 
Mon Nov  1 18:07:55 2021 [pid 16620] CONNECT: Client "::ffff:192.168.251.1"

Mon Nov  1 18:08:08 2021 [pid 16619] [roxanne] OK LOGIN: Client "::ffff:192.168.251.1"

Mon Nov  1 18:09:10 2021 [pid 16625] CONNECT: Client "::ffff:192.168.251.1"

Mon Nov  1 18:09:14 2021 [pid 16624] [roxanne] OK LOGIN: Client "::ffff:192.168.251.1"
```

- Connectez vous au serveur
```bash
roxanne@NODE1:/var/log$ sudo less vsftpd.log
[...]
Thu Nov  4 18:53:58 2021 [pid 2369] [roxanne] OK LOGIN: Client "::ffff:192.168.251.1"
Thu Nov  4 18:53:59 2021 [pid 2371] [roxanne] OK DOWNLOAD: Client "::ffff:192.168.251.1", "/home/roxanne/Documents/tur", 5 bytes, 0.52Kbyte/sec
[...]
```

- Visualiser les logs

```bash
roxanne@NODE1:/etc$ sudo nano vsftpd.conf
[...]
# Uncomment this to enable any form of FTP write command.
write_enable=YES
[...]
roxanne@NODE1:/etc$ systemctl reload vsftpd

roxanne@NODE1:/var/log$ sudo less vsftpd.log 
Thu Nov  4 19:07:21 2021 [pid 2468] [roxanne] OK LOGIN: Client "::ffff:192.168.251.1"
Thu Nov  4 19:07:21 2021 [pid 2470] [roxanne] OK UPLOAD: Client "::ffff:192.168.251.1", "/home/roxanne/Bureau/tutu", 6 bytes, 1.14Kbyte/sec


```

### Modification de la configuration d'un serveur

- Modifier le comportement d'un service
```bash
roxanne@NODE1:/etc$ sudo nano vsftpd.conf 
roxanne@NODE1:/etc$ sudo cat vsftpd.conf 
listen_port=1234

roxanne@NODE1:/$ systemctl restart vsftpd

==== AUTHENTICATING FOR org.freedesktop.systemd1.manage-units ===

Authentification requise pour redémarrer « vsftpd.service ».

Authenticating as: roxanne,,, (roxanne)

Password: 

==== AUTHENTICATION COMPLETE ===

roxanne@NODE1:/$ systemctl status vsftpd

● vsftpd.service - vsftpd FTP server

     Loaded: loaded (/lib/systemd/system/vsftpd.service; enabled; vendor preset: enabled)

     Active: active (running) since Thu 2021-11-04 19:28:59 CET; 19s ago

    Process: 2619 ExecStartPre=/bin/mkdir -p /var/run/vsftpd/empty (code=exited, status=0/SUCCE>

   Main PID: 2620 (vsftpd)

      Tasks: 1 (limit: 1105)

     Memory: 536.0K

     CGroup: /system.slice/vsftpd.service

             └─2620 /usr/sbin/vsftpd /etc/vsftpd.conf



nov. 04 19:28:59 NODE1.TP2.LINUX systemd[1]: Starting vsftpd FTP server...

nov. 04 19:28:59 NODE1.TP2.LINUX systemd[1]: Started vsftpd FTP server.

roxanne@NODE1:/$ ss -l | grep 1234

tcp     LISTEN   0        32                                                  *:1234                                            *:*                             
```

- Connectez vous sur le nouveau port choisi

```bash
roxanne@NODE1:/var/log$ sudo less vsftpd.log 
Thu Nov  4 19:32:28 2021 [pid 2639] [roxanne] OK LOGIN: Client "::ffff:192.168.251.1"
Thu Nov  4 19:32:28 2021 [pid 2641] [roxanne] OK UPLOAD: Client "::ffff:192.168.251.1", "/home/roxanne/Documents/yes", 6 bytes, 2.55Kbyte/sec
Thu Nov  4 19:32:42 2021 [pid 2637] [roxanne] OK RENAME: Client "::ffff:192.168.251.1", "/home/roxanne/Documents/yes /home/roxanne/Documents/tropcool"
Thu Nov  4 19:32:47 2021 [pid 2644] CONNECT: Client "::ffff:192.168.251.1"
Thu Nov  4 19:32:47 2021 [pid 2643] [roxanne] OK LOGIN: Client "::ffff:192.168.251.1"
Thu Nov  4 19:32:47 2021 [pid 2645] [roxanne] OK DOWNLOAD: Client "::ffff:192.168.251.1", "/home/roxanne/Documents/tropcool", 6 bytes, 5.20Kbyte/sec
```

## Partie 3

### Jouer avec netcat

- Donnez les deux commandes pour établir ce petit chat avec ```netcat```

```bash
roxanne@NODE1:/$ nc -l 2345
roxanne@roxanne-VirtualBox:~$ echo salut | nc 192.168.251.14 2345

roxanne@NODE1:/$ nc -l 2345
salut

roxanne@NODE1:/$ nc -l 2345
salut
gggg

roxanne@roxanne-VirtualBox:~$ echo salut | nc 192.168.251.14 2345
gggg
```

- Utiliser ```netcat``` pour stocker les données échangées dans un fichier

```bash
roxanne@NODE1:~$ nc -l 2345 >> coucou

roxanne@roxanne-VirtualBox:~$ nc 192.168.251.14 2345
salut

roxanne@NODE1:~$ cat coucou
salut
```

### Créer le service

- Créer un nouveau service

```bash
roxanne@NODE1:/etc/systemd/system$ sudo nano chat_tp2.service
roxanne@NODE1:/etc/systemd/system$ sudo chmod 777 chat_tp2.service
roxanne@NODE1:/etc/systemd/system$ cat chat_tp2.service
[Unit]
Description=Little chat service (TP2)

[Service]
ExecStart=/usr/bin/nc -l 2345

[Install]
WantedBy=multi-user.target


roxanne@NODE1:/etc/systemd/system$ sudo systemctl daemon-reload
```

- Tester le nouveau service

```bash
roxanne@NODE1:/etc/systemd/system$ sudo systemctl start chat_tp2
roxanne@NODE1:/etc/systemd/system$ sudo systemctl status chat_tp2
● chat_tp2.service - Little chat service (TP2)
     Loaded: loaded (/etc/systemd/system/chat_tp2.service; disabled; vendor preset: enabled)
     Active: active (running) since Thu 2021-11-04 20:42:26 CET; 5s ago
   Main PID: 3225 (nc)
      Tasks: 1 (limit: 1105)
     Memory: 192.0K
     CGroup: /system.slice/chat_tp2.service
             └─3225 /usr/bin/nc -l 2345

nov. 04 20:42:26 NODE1.TP2.LINUX systemd[1]: Started Little chat service (TP2).
roxanne@NODE1:/etc/systemd/system$ ss -l | grep 2345
tcp     LISTEN   0        1                                             0.0.0.0:2345                                      0.0.0.0:*                             

roxanne@roxanne-VirtualBox:~$ nc 192.168.251.14 2345
salut
coucou

roxanne@NODE1:/etc/systemd/system$ journalctl -xe -u chat_tp2 -f
-- Logs begin at Thu 2021-10-21 16:54:32 CEST. --
nov. 04 20:37:50 NODE1.TP2.LINUX systemd[1]: Started Little chat service (TP2).
[...]
-- L'unité (unit) chat_tp2.service a terminé son démarrage, avec le résultat done.
nov. 04 20:44:52 NODE1.TP2.LINUX nc[3225]: salut
nov. 04 20:44:58 NODE1.TP2.LINUX nc[3225]: coucou
```
