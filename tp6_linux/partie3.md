## Partie 3 : Setup des clients NFS : web.tp6.linux et db.tp6.linux

- Installation

```bash
# installation du paquet nfs-utils
[roxanne@web ~]$ sudo dnf install nfs-utils
[sudo] password for roxanne:
Rocky Linux 8 - AppStream                                               3.5 kB/s | 4.8 kB     00:01
Rocky Linux 8 - AppStream                                                46 kB/s | 8.3 MB     03:03
Rocky Linux 8 - BaseOS                                               [...]
Installed:
  gssproxy-0.8.0-19.el8.x86_64     keyutils-1.5.10-9.el8.x86_64  libverto-libevent-0.3.0-5.el8.x86_64
  nfs-utils-1:2.3.3-46.el8.x86_64  rpcbind-1.2.5-8.el8.x86_64

Complete!
```

- Configuration

```bash
# création du dossier backup
[roxanne@web ~]$ cd /srv
[roxanne@web srv]$ sudo mkdir backup
[sudo] password for roxanne:
```

```bash
# changement du nom de domaine
[roxanne@web ~]$ sudo nano /etc/idmapd.conf
[roxanne@web ~]$ cat /etc/idmapd.conf
[General]
#Verbosity = 0
# The following should be set to the local NFSv4 domain name
# The default is the host's DNS domain name.
Domain = tp6.linux
[...]
```

- Montage

```bash
# montage du dossier
[roxanne@web ~]$ sudo mount -t nfs 10.5.1.13:/backup/web.tp6.linux/ /srv/backup

# vérification du montage du dossier
[roxanne@web ~]$ df -h | grep back
10.5.1.13:/backup/web.tp6.linux  4.9G   20M  4.6G   1% /srv/backup


[roxanne@web ~]$ ls -l
total 0
drwxr-xr-x. 3 roxanne root 45 Dec  7 10:16 backup
drwxr-xr-x. 2 roxanne root 27 Nov 28 21:36 bin
```

```bash
# modification du fichier
[roxanne@web ~]$ sudo nano /etc/fstab
[roxanne@web ~]$ cat /etc/fstab

#
# /etc/fstab
# Created by anaconda on Tue Nov 23 14:19:30 2021
#
# Accessible filesystems, by reference, are maintained under '/dev/disk/'.
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info.
#
# After editing this file, run 'systemctl daemon-reload' to update systemd
# units generated from this file.
#
/dev/mapper/rl-root     /                       xfs     defaults        0 0
UUID=8b3feda6-3fb4-4087-9e4a-e35644fee3ec /boot                   xfs     defaults        0 0
/dev/mapper/rl-swap     none                    swap    defaults        0 0
10.5.1.13:/backup/web.tp6.linux/        /srv/backup             nfs     defaults        0 0
```

```bash
[roxanne@web ~]$ sudo umount 10.5.1.13:/backup/web.tp6.linux/
[roxanne@web ~]$ sudo mount -av
/                        : ignored
/boot                    : already mounted
none                     : ignored
/srv/backup              : successfully mounted
```

- Répeter les opérations sur ```db.tp6.linux```

```bash
[roxanne@dp ~]$ sudo dnf install nfs-utils
Rocky Linux 8 - AppStream                                                                                                                                                          6.0 kB/s | 4.8 kB     00:00
Rocky Linux 8 - AppStream                                                                                                                                                          447 kB/s | 8.3 MB     00:18
Rocky Linux 8 - BaseOS                                                                                                                                                             5.1 kB/s | 4.3 kB     00:00
Rocky Linux 8 - BaseOS                                                                                                                                                             471 kB/s | 3.5 MB     00:07
Rocky Linux 8 - Extras                                                                                                                                                             6.3 kB/s | 3.5 kB     00:00
Rocky Linux 8 - Extras                                                                                                                                                              11 kB/s |  10 kB     00:00
Dependencies resolved.
[...]
Complete!
```

```bash
[roxanne@dp srv]$ sudo mkdir backup
[roxanne@dp srv]$ ls
backup


[roxanne@dp ~]$ sudo nano /etc/idmapd.conf
[roxanne@dp ~]$ cat /etc/idmapd.conf
[General]
#Verbosity = 0
# The following should be set to the local NFSv4 domain name
# The default is the host's DNS domain name.
Domain = tp6.linux
[...]
```

```
[roxanne@dp ~]$ df -h | grep back
10.5.1.13:/backup/db.tp6.linux  4.9G   20M  4.6G   1% /srv/backup

[roxanne@dp ~]$ sudo mount -av
/                        : ignored
/boot                    : already mounted
none                     : ignoredcd 
/srv/backup              : successfully mounted
```