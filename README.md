## TP1 : Are you dead yet ?

**Méthode 1 :**

```:(){ :|:& };:```

La méthode 1 est un fork bomb, pour créer une multitude de processus pour saturer l'espace disponible dans la table des processus.

**Méthode 2 :**

```sudo mv /bin /dev/null ```


**Méthode 3 :**

```sudo rm -rf su && sudo rm -rf sudo```

La méthode 3 a pour but de supprimer les accès superutilisateurs de linux et donc de fortement compliqué les commandes via le terminal si on a pas les codes d'accès root.

**Méthode 4 :**

```cd /etc/fonts```

On se déplace dans le dossier des polices de l'ordinateur.

```sudo nano fonts.conf ```

Et ensuite on modifie le fichier fonts.conf en effaçant le paragraphe directory list pour qu'il n'y ait plus de caractères qui puissent apparaître.

**Méthode 5 :**

```cd etc```

On se déplace dans le dossier etc.

```sudo nano passwd```

On édite le fichier passwd en supprimant la ligne de notre user qui contient la chaîne de caractères nous permettant de nous connecter et donc supprimer notre utilisateur.

**Méthode 6 :**

```sudo dd if =/dev/urandom of=/dev/sda5```

Ici, on va envoyer des informations incohérentes à la ram de la machine lorsqu'on la lance ce qui l'empêche de démarrer.
