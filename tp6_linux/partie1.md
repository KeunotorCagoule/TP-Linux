## Partie 1 : Préparation de la machine backup.tp6.linux

### I : Ajout de disque

- Ajouter un disque dur de 5Go à la VM ```backup.tp6.linux```

```bash
# on utilise grep pour trouver le disque dur de 5Giga
[roxanne@backup ~]$ lsblk | grep 5G
sdb           8:16   0    5G  0 disk
```

### II : Partitioning

- Partitionner le disque à l'aide de LVM

```bash
# on ajoute le disque en tant que PV
[roxanne@backup ~]$ sudo pvcreate /dev/sdb
[sudo] password for roxanne:
  Physical volume "/dev/sdb" successfully created.


# on vérifie que le disque a bien été ajouté
[roxanne@backup ~]$ sudo pvcreate /dev/sdb
[sudo] password for roxanne:
  Physical volume "/dev/sdb" successfully created.
[roxanne@backup ~]$ sudo pvs
  PV         VG Fmt  Attr PSize  PFree
  /dev/sda2  rl lvm2 a--  <7.00g    0
  /dev/sdb      lvm2 ---   5.00g 5.00g
[roxanne@backup ~]$ sudo pvdisplay
  --- Physical volume ---
  PV Name               /dev/sda2
  VG Name               rl
  PV Size               <7.00 GiB / not usable 3.00 MiB
  Allocatable           yes (but full)
  PE Size               4.00 MiB
  Total PE              1791
  Free PE               0
  Allocated PE          1791
  PV UUID               y7pJpY-oEqj-srF6-NG9F-mDMY-o6nY-IIF7kP

  "/dev/sdb" is a new physical volume of "5.00 GiB"
  --- NEW Physical volume ---
  PV Name               /dev/sdb
  VG Name
  PV Size               5.00 GiB
  Allocatable           NO
  PE Size               0
  Total PE              0
  Free PE               0
  Allocated PE          0
  PV UUID               Ue5qlX-te9L-AhGq-R3Lj-ywo7-KiHz-C7Jhef  
```

```bash
# création du VG 
[roxanne@backup ~]$ sudo vgcreate backup /dev/sdb
  Volume group "backup" successfully created


# vérification de la création du Volume Group
[roxanne@backup ~]$ sudo vgcreate backup /dev/sdb
  Volume group "backup" successfully created
[roxanne@backup ~]$ sudo vgs
[sudo] password for roxanne:
  VG     #PV #LV #SN Attr   VSize  VFree
  backup   1   0   0 wz--n- <5.00g <5.00g
  rl       1   2   0 wz--n- <7.00g     0
[roxanne@backup ~]$ sudo vgdisplay
  --- Volume group ---
  VG Name               backup
  System ID
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  1
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                0
  Open LV               0
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               <5.00 GiB
  PE Size               4.00 MiB
  Total PE              1279
  Alloc PE / Size       0 / 0
  Free  PE / Size       1279 / <5.00 GiB
  VG UUID               d06jua-5CoC-lSTE-aPPX-PfdN-dIAa-oKqnC5

[...]
```

```bash
# création du LV
[roxanne@backup ~]$ sudo lvcreate -l 100%FREE backup -n last_data
[sudo] password for roxanne:
  Logical volume "last_data" created.


# vérification de la création du LV
[roxanne@backup ~]$ sudo lvs
  LV        VG     Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  last_data backup -wi-a-----  <5.00g
  root      rl     -wi-ao----  <6.20g
  swap      rl     -wi-ao---- 820.00m
[roxanne@backup ~]$ sudo lvdisplay
  --- Logical volume ---
  LV Path                /dev/backup/last_data
  LV Name                last_data
  VG Name                backup
  LV UUID                yhuUW4-NQNo-jL83-RxQi-hytD-nHzD-awVR1e
  LV Write Access        read/write
  LV Creation host, time backup.tp6.linux, 2021-12-03 16:37:23 +0100
  LV Status              available
  # open                 0
  LV Size                <5.00 GiB
  Current LE             1279
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     8192
  Block device           253:2

[...]
```

- Formater la partition 

```bash
[roxanne@backup ~]$ mkfs -t ext4 /dev/backup/last_data
mke2fs 1.45.6 (20-Mar-2020)
Could not open /dev/backup/last_data: Permission denied
[roxanne@backup ~]$ sudo mkfs -t ext4 /dev/backup/last_data
mke2fs 1.45.6 (20-Mar-2020)
Creating filesystem with 1309696 4k blocks and 327680 inodes
Filesystem UUID: f2190fd1-782a-4b2c-b91c-2ae6e305487b
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736

Allocating group tables: done
Writing inode tables: done
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done
```

- Monter la partition

```bash
# montage de la partition
[roxanne@backup /]$ sudo mount /dev/backup/last_data /backup


# on vérifie que le montage a bien été fait
[roxanne@backup /]$ df -h | grep backup
/dev/mapper/backup-last_data  4.9G   20M  4.6G   1% /backup
```

```bash
# on déclare la partition dans fstab pour pouvoir la monter automatiquement
[roxanne@backup ~]$ sudo nano /etc/fstab
[sudo] password for roxanne:
[roxanne@backup ~]$ cat /etc/fstab

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
/dev/backup/last_data   /backup                 ext4    defaults        0 0
```

```bash
# on vérifie le montage automatique, on a une erreur
[roxanne@backup ~]$ sudo mount -av
/                        : ignored
/boot                    : already mounted
none                     : ignored
mount: /backup does not contain SELinux labels.
       You just mounted an file system that supports labels which does not
       contain labels, onto an SELinux box. It is likely that confined
       applications will generate AVC messages and not be allowed access to
       this file system.  For more details see restorecon(8) and mount(8).
/backup                  : successfully mounted

# on réinitialise le contexte
[roxanne@backup ~]$ sudo restorecon -R /backup

# on démonte la partition
[roxanne@backup ~]$ sudo umount /backup

# on remonte la partition, il n'y a plus d'erreur
[roxanne@backup ~]$ sudo mount -av
/                        : ignored
/boot                    : already mounted
none                     : ignored
/backup                  : successfully mounted
```


