#!/bin/bash
#!/usr/bin/php

nb_success=0;
nb_error=0;
HERE="/Users/samirboudaoud/Le cnam/NSY103-Linux/projet_cron_jobs/nsy103"
# params :
# $1 : le path du job ex: 'jobs/job1.php'
# $2 : id de la row
runJob() {
  result=$(php "$HERE"/"$1")

  case $result in
  "success")
    # 👍 Le programme a été réalisé avec succès
    ((nb_success++))
    # MAJ de l'état en BDD
    sqlite3 "$HERE"/database.db "UPDATE jobs SET state='success', type='DONE' WHERE rowid = '$2'"
    ;;
  "erreur")
    # 💥 Le programme a retourné une erreur
    ((nb_error++))
    # MAJ de l'état en BDD + Log l'erreur avec la date
    NOW=$(date +%Y-%m-%d\ %H:%M:%S)
    sqlite3 "$HERE"/database.db "UPDATE jobs SET state='error', type='DONE' WHERE rowid = '$2'"
    ;;
  *)
    echo "Désolé, je ne comprends pas votre réponse ¯\_(ツ)_/¯"
    ;;
  esac
}

JOBS=$(sqlite3 -separator ";" -newline "|" "$HERE"/database.db "SELECT rowid, type, date_completion, state, job FROM jobs WHERE type='TODO' LIMIT 10")
# Separe chaque ligne et la place dans un tableau
IFS='|' read -r -a jobs_array <<< "$JOBS"

# [@] all values = *
for row in "${jobs_array[@]}"
do
  id=$(echo "$row" | awk -F ";" '{print $1}');
  type=$(echo "$row" | awk -F ";" '{print $2}');
  job=$(echo "$row" | awk -F ";" '{print $5}');

  if [ "$type" == "TODO" ]
  then
    # on traite directement
    runJob $job $id
  fi
done

echo '#########################################'
echo "$(date) - Script complété: $nb_success success, $nb_error erreurs"

