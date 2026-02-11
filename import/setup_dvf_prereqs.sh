#!/bin/bash
mkdir -p ~/data

echo "Downloading DVF data from data.gouv.fr"
for i in {01..95}
do
  url="https://files.data.gouv.fr/geo-dvf/latest/csv/2020/departements/$i.csv.gz"
  echo "Downloading $url"
  wget --no-verbose -O ~/data/$i.csv.gz $url
  gunzip ~/data/$i.csv.gz
  mv ~/data/$i.csv ~/data/dvf-$i-2020.csv
done