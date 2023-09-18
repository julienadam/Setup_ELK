#!/bin/bash
mkdir -p ~/data

if [[ -f ~/data/all-cards-20230424091518.ndjson ]] 
then 
  echo "Card database already downloaded and extracted" 
else 
  echo "Download card data from google drive"
  wget -O ~/data/all-cards-20230424091518.ndjson.gz "https://drive.google.com/uc?id=1KOpEVtqbVrKPnzAjeE5nR1nKXHuv1S-_&export=download&confirm=t&uuid=1b8625fb-98cb-4707-a18d-e395fe7a486a"

  echo "Decompressing card data"
  gunzip ~/data/all-cards-20230424091518.ndjson.gz
fi

echo "Running v1 import"
docker run --rm \
  --network host \
  --env-file ../.env \
  -e XPACK_MONITORING_ENABLED=false \
  -v ~/data/all-cards-20230424091518.ndjson:/data/all-cards.ndjson \
  -v ${PWD}/logstash-mtg-v1.conf:/usr/share/logstash/logstash-mtg-v1.conf \
  docker.elastic.co/logstash/logstash:${STACK_VERSION} \
  -f /usr/share/logstash/logstash-mtg-v1.conf

echo "Setting env values from .env"
export $(grep -v '^#' ../.env | xargs)

echo "Creating mtg v1 to v2 pipeline"
curl \
  -k \
  -H "Content-Type: application/json" \
  -u elastic:${ELASTIC_PASSWORD} \
  -XPUT https://localhost:9200/_ingest/pipeline/mtg_v1_to_v2 \
  --data-binary @pipeline_v1_to_v2.json

echo "Creating mtg v2 template"
curl \
  -k \
  -H "Content-Type: application/json" \
  -u elastic:${ELASTIC_PASSWORD} \
  -XPUT https://localhost:9200/_index_template/mtg_v2_template \
  --data-binary @mtg_v2_template.json 

echo "Reindexing mtg v1 into v2"
curl \
  -k \
  -H "Content-Type: application/json" \
  -u elastic:${ELASTIC_PASSWORD} \
  -XPOST https://localhost:9200/_reindex?wait_for_completion=false \
  --data-binary @reindex_mtg_v1_v2.json
