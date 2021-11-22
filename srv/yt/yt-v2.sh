#!/bin/bash  

for i in "$@"; do
  case $i in
    -o=*)
      DOSSIER="${i#*=}"
      shift # past argument=value
      ;;
    -h)
      echo "$0 -o : préciser un dossier autre que /srv/yt/downloads, -h : afficher l'usage"
      exit 0
      ;;
    *)
      echo "Option inconnue"
      echo "$0 -o : préciser un dossier autre que /srv/yt/downloads, -h : afficher l'usage"
      exit 0
      ;;
  esac
done

if [[ -z $DOSSIER ]]
then
	DOSSIER=/srv/yt/downloads
fi


while i=0

do

        while read -r line  

        do

         if [[ $line == https://www.youtube.com/watch?v=* ]]

         then

                if [ -d "$DOSSIER" ] && [ -d /var/log/yt ]

                then

                        cd "$DOSSIER"

                        video_url=$line

                        title="$(youtube-dl -e --skip-download "$video_url")"
                        
                        mkdir "$title"

                        cd "$title"

                        youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]' "$video_url" 2>&1 > /dev/null

                        echo "Video $video_url was downloaded."

                        chemin="$(find $(cd ..; pwd) -name "$title")"

                        echo "File path :$(find $(cd ..; pwd) -name "$title")"

                        mkdir description

                        cd description

                        youtube-dl --skip-download --get-description "$video_url" > description.txt

                        datelog=$(date '+[%y/%m/%d %T]')

                        echo "$datelog Video $video_url was downloaded. File path : $chemin" >> /var/log/yt/download.log

                        sed -i '1d' /srv/yt/urlvideo

                else

                        echo "Répertoire manquant."

                        exit 0

                fi

        else

                echo "non valide" > /var/log/yt/download.log

                sed -i '1d' /srv/yt/urlvideo

        fi

        done < /srv/yt/urlvideo

        sleep 5

done
