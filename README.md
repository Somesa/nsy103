# nsy103 - Linux
### Gestion d’une file d’attente

Le script permet de gérer une liste de tâches en attente, celles-ci sont enregistrées dans une base de données, certaines sont programmées pour être exécutées à un certaine moment, d’autres directement. Une fois exécutée, elle retournera un résultat, nous mettrons à jour notre base de données en indiquant celui-ci afin de garder une trace.

Notre script répond à un problème que nous allons tenter de résoudre: réduire au maximum le temps de traitement d’un script php. 