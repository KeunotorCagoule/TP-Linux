echo -e "Machine name : $(uname -a | cut -d ' ' -f2)\n"
echo -e "Os $(cat /etc/os-release | head -1 | cut -d'"' -f2) and kernel version is $(uname -r)\n"
echo -e "IP : $(hostname -I)\n"
echo -e "Ram : $(bc <<< "scale=2; $(cat /proc/meminfo | grep MemAvailable | awk '{ print $2 }') / 1024 / 1024")Go RAM restante sur $(bc <<< "scale=2; $(cat /proc/meminfo | grep MemTotal | awk '{ print $>
echo -e "Disque : $(df -Pk -BG / | sed 1d | awk '{ print $4 }') space left\n"
echo -e "Top 5 processes by RAM usage :\n$(ps aux --sort=-%mem | head -5 | tail -4 | awk '{ print $11 }') \n$(ps aux --sort=-%mem | head -6 | tail -1 | awk '{ print $12 }')\n"
echo -e "Listening ports: \n$(sudo lsof -i -P -n | grep LISTEN | awk '{ print $2 " : " $1 }')\n"
echo "Here's your random cat : "$(curl -s https://api.thecatapi.com/v1/images/search | grep '"url"' | cut -d'"' -f10)""
