# TP 3 : A little script

## I : Script carte d'identité

- Script : [/srv/idcard/idcard.sh](https://github.com/KeunotorCagoule/TP-Linux/blob/main/srv/idcard/idcard.sh)

```bash
roxanne@roxanne-VirtualBox:/srv/idcard$ sudo bash idcard.sh

Machine name : roxanne-VirtualBox

Os Ubuntu and kernel version is 5.11.0-38-generic

IP : 10.0.2.15 

Ram : 1.15Go RAM restante sur 1.93Go RAM totale 

Disque : 10G space left

Top 5 processes by RAM usage :
/usr/bin/gnome-shell
/usr/libexec/gnome-terminal-server
gjs
/usr/libexec/evolution-data-server/evolution-alarm-notify 
--gapplication-service

Listening ports: 
520 : systemd-r
22775 : cupsd
22775 : cupsd

Here's your random cat : https://cdn2.thecatapi.com/images/9f9.jpg
```
## II : Script youtube-dl 

- Script : [/srv/yt/yt.sh](https://github.com/KeunotorCagoule/TP-Linux/blob/main/srv/yt/yt.sh)

- Fichier de log : [/var/log/yt/download.log](https://github.com/KeunotorCagoule/TP-Linux/blob/main/var/log/yt/download.log)


```bash
roxanne@roxanne-VirtualBox:~/TP-Linux/srv/yt$ sudo bash yt.sh https://www.youtube.com/watch?v=AZylpfF3nY0

Video https://www.youtube.com/watch?v=AZylpfF3nY0 was downloaded.
File path :/home/roxanne/TP-Linux/srv/yt/downloads/I’m ash from pallet town
```

## III : MAKE IT A SERVICE

- Script : [/srv/yt/yt-v2.sh](https://github.com/KeunotorCagoule/TP-Linux/blob/main/srv/yt/yt-v2.sh)

- Fichier : [/etc/systemd/system/yt.service](https://github.com/KeunotorCagoule/TP-Linux/blob/main/etc/systemd/system/yt.service)

```bash
roxanne@roxanne-VirtualBox:/etc/systemd/system$ sudo systemctl start yt
roxanne@roxanne-VirtualBox:/etc/systemd/system$ systemctl status yt
● yt.service - Youtube Download (TP3)
     Loaded: loaded (/etc/systemd/system/yt.service; disabled; vendor preset: enabled)
     Active: active (running) since Mon 2021-11-22 22:52:40 CET; 15s ago
   Main PID: 27952 (yt-v2.sh)
      Tasks: 2 (limit: 2295)
     Memory: 572.0K
     CGroup: /system.slice/yt.service
             ├─27952 /bin/bash /srv/yt/yt-v2.sh
             └─27957 sleep 5



nov. 22 22:52:40 roxanne-VirtualBox systemd[1]: Started Youtube Download (TP3).
nov. 22 22:52:45 roxanne-VirtualBox yt-v2.sh[27952]: + i=0
nov. 22 22:52:45 roxanne-VirtualBox yt-v2.sh[27952]: + read -r line
nov. 22 22:52:45 roxanne-VirtualBox yt-v2.sh[27952]: + sleep 5
nov. 22 22:52:50 roxanne-VirtualBox yt-v2.sh[27952]: + i=0
nov. 22 22:52:50 roxanne-VirtualBox yt-v2.sh[27952]: + read -r line
nov. 22 22:52:50 roxanne-VirtualBox yt-v2.sh[27952]: + sleep 5
nov. 22 22:52:55 roxanne-VirtualBox yt-v2.sh[27952]: + i=0
nov. 22 22:52:55 roxanne-VirtualBox yt-v2.sh[27952]: + read -r line
nov. 22 22:52:55 roxanne-VirtualBox yt-v2.sh[27952]: + sleep 5
```

```bash
roxanne@roxanne-VirtualBox:/etc/systemd/system$ journalctl -xe -u yt
nov. 22 22:55:00 roxanne-VirtualBox yt-v2.sh[27952]: + sleep 5
nov. 22 22:55:05 roxanne-VirtualBox yt-v2.sh[27952]: + i=0
nov. 22 22:55:05 roxanne-VirtualBox yt-v2.sh[27952]: + read -r line
nov. 22 22:55:05 roxanne-VirtualBox yt-v2.sh[27952]: + [[ https://www.youtube.com/watch?v=AZylpfF3nY0 == https://www.youtube.com/watch?v=* ]]
nov. 22 22:55:05 roxanne-VirtualBox yt-v2.sh[27952]: + '[' -d /srv/yt/downloads ']'
nov. 22 22:55:05 roxanne-VirtualBox yt-v2.sh[27952]: + '[' -d /var/log/yt ']'
nov. 22 22:55:05 roxanne-VirtualBox yt-v2.sh[27952]: + cd /srv/yt/downloads
nov. 22 22:55:05 roxanne-VirtualBox yt-v2.sh[27952]: + video_url='https://www.youtube.com/watch?v=AZylpfF3nY0'
nov. 22 22:55:05 roxanne-VirtualBox yt-v2.sh[27990]: ++ youtube-dl -e --skip-download 'https://www.youtube.com/watch?v=AZylpfF3nY0'
```

```bash
roxanne@roxanne-VirtualBox:/etc/systemd/system$ sudo systemctl enable yt
[sudo] Mot de passe de roxanne : 
Created symlink /etc/systemd/system/multi-user.target.wants/yt.service → /etc/systemd/system/yt.service.
```

## IV : Bonus

- en accord avec ShellCheck (yt-v2.sh)
- fonction usage (-h et -o)
