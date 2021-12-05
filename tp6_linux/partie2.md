## Partie 2 : Setup du serveur NFS sur backup.tp6.linux

- Préparer les dossiers à partager

```bash
# création du dossier sur la machine backup.tp6.linux
[roxanne@backup backup]$ sudo mkdir web.tp6.linux
[sudo] password for roxanne:
[roxanne@backup backup]$ ls
lost+found  web.tp6.linux
```

```bash
[roxanne@backup backup]$ sudo mkdir db.tp6.linux
[roxanne@backup backup]$ ls
db.tp6.linux  lost+found  web.tp6.linux
```

- Install du serveur NFS 

```bash
# installation du paquet nfs-utils
[roxanne@backup ~]$ sudo dnf install nfs-utils
Rocky Linux 8 - AppStream                                               5.6 kB/s | 4.8 kB     00:00
Rocky Linux 8 - AppStream                                               462 kB/s | 8.3 MB     00:18
Rocky Linux 8 - BaseOS                                                  6.9 kB/s | 4.3 kB     00:00
Rocky Linux 8 - BaseOS                                                  283 kB/s | 3.5 MB     00:12
Rocky Linux 8 - Extras                                                  4.0 kB/s | 3.5 kB     00:00
Rocky Linux 8 - Extras                                                   12 kB/s |  10 kB     00:00
Dependencies resolved.
[...]

Installed:
  gssproxy-0.8.0-19.el8.x86_64     keyutils-1.5.10-9.el8.x86_64  libverto-libevent-0.3.0-5.el8.x86_64
  nfs-utils-1:2.3.3-46.el8.x86_64  rpcbind-1.2.5-8.el8.x86_64

Complete!
```

- Conf du serveur NFS

```bash
# on configure le fichier de conf
[roxanne@backup ~]$ sudo nano /etc/idmapd.conf
[roxanne@backup ~]$ cat /etc/idmapd.conf
[General]
#Verbosity = 0
# The following should be set to the local NFSv4 domain name
# The default is the host's DNS domain name.
Domain = tp6.linux
[...]
```

```bash
# on ajoute les dossiers à partager en autorisant les machines web.tp6.linux et db.tp6.linux à y accéder
# rw spécofie que le répertoire partagé sont en lecture/écriture
#no_root_squash spécifie que le root de la machine sur laquelle le répertoire est monté a les droits de root sur le répertoire
[roxanne@backup ~]$ sudo nano /etc/exports
[roxanne@backup ~]$ sudo cat /etc/exports
/backup/web.tp6.linux/  10.5.1.11/24(rw,no_root_squash)
/backup/db.tp6.linux/   10.5.1.12/24(rw,no_root_squash)
```

- Démarrer le service

```bash
# on démarre le service
[roxanne@backup ~]$ sudo systemctl start nfs-server
[sudo] password for roxanne:

# on vérifie que le service a demarré
[roxanne@backup ~]$ systemctl status nfs-server
● nfs-server.service - NFS server and services
   Loaded: loaded (/usr/lib/systemd/system/nfs-server.service; disabled; vendor preset: disabled)
   Active: active (exited) since Sun 2021-12-05 13:22:22 CET; 9s ago
  Process: 4910 ExecStart=/bin/sh -c if systemctl -q is-active gssproxy; then systemctl reload gssproxy>
  Process: 4898 ExecStart=/usr/sbin/rpc.nfsd (code=exited, status=0/SUCCESS)
  Process: 4897 ExecStartPre=/usr/sbin/exportfs -r (code=exited, status=0/SUCCESS)
 Main PID: 4910 (code=exited, status=0/SUCCESS)

Dec 05 13:22:22 backup.tp6.linux systemd[1]: Starting NFS server and services...
Dec 05 13:22:22 backup.tp6.linux systemd[1]: Started NFS server and services.

# on fait en sorte que le service se lance dès le démarrage
[roxanne@backup ~]$ sudo systemctl enable nfs-server
Created symlink /etc/systemd/system/multi-user.target.wants/nfs-server.service → /usr/lib/systemd/system/nfs-server.service.
```

- Firewall

```bash
# on ouvre le port 2049
[roxanne@backup ~]$ sudo firewall-cmd --add-port=2049/tcp --permanent
[sudo] password for roxanne:
success

# la machine écoute sur le port 2049
[roxanne@backup ~]$ sudo ss -lptn | grep 2049
LISTEN 0      64           0.0.0.0:2049       0.0.0.0:*
LISTEN 0      64              [::]:2049          [::]:*
```