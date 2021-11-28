## III : Bonus


### 1 : Mettre en place du HTTPS sur le serveur web

```bash
# on installe les paquets EPEL et les paquets mod_ssl (module permettant de faire du SSL avec Apache)
[roxanne@web ~]$ sudo dnf install epel-release mod_ssl
[sudo] password for roxanne:
Rocky Linux 8 - AppStream                                               7.4 kB/s | 4.8 kB     00:00
Rocky Linux 8 - BaseOS                                               [...]

Complete!


# on installe le paquet Certbot qui récupère le certificat SSL et automatise son installation et sa configuration
[roxanne@web ~]$ sudo dnf install certbot python3-certbot-apache
[...]
  python3-zope-interface-4.6.0-1.el8.x86_64
  python36-3.6.8-38.module+el8.5.0+671+195e4563.x86_64

Complete!
```

