#!/bin/bash
#!/usr/bin/php

HERE="/Users/samirboudaoud/Le cnam/NSY103-Linux/projet_cron_jobs/nsy103"
JOBS_SCHEDULED=$(sqlite3 -separator ";" -newline "|" "$HERE"/database.db "SELECT rowid, type, date_completion FROM jobs WHERE type='SCHEDULED' AND date_completion < datetime('now')")

# Separe chaque ligne et la place dans un tableau
IFS='|' read -r -a jobs_array <<< "$JOBS_SCHEDULED"

nb_changes=0
for row in "${jobs_array[@]}"
do
  id=$(echo "$row" | awk -F ";" '{print $1}');
  type=$(echo "$row" | awk -F ";" '{print $2}');
  date_completion=$(echo "$row" | awk -F ";" '{print $3}');

  if [ "$type" == "SCHEDULED" ]
  then
    # c'est un sheduled, on vérifie les dates
    NOW=$(date +%Y-%m-%d\ %H:%M:%S)

    if [ "$date_completion" \< "$NOW" ]
    then
        # la date est passée, on le debloque afin qu'il soit traité
        sqlite3 "$HERE"/database.db "UPDATE jobs SET type='TODO' WHERE rowid = '$id'"
        ((nb_changes++))
    fi
  fi
done

echo '#########################################'
echo "$(date) : Script complété: $nb_changes jobs sont passé au statut: TODO"


