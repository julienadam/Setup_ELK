#!/bin/bash

echo "Setting env values from .env"
export $(grep -v '^#' ../.env | xargs)

mkdir ~/data
wget --no-verbose -O ~/data/news.ndjson.gz "https://formation-arcodia.s3.fr-par.scw.cloud/Latest_News.ndjson.gz"
gunzip ~/data/news.ndjson.gz

docker run --rm \
  --network host \
  --env-file ../.env \
  -e XPACK_MONITORING_ENABLED=false \
  -v ~/data:/data \
  -v ./logstash-news-v1.conf:/usr/share/logstash/logstash-news-v1.conf \
  docker.elastic.co/logstash/logstash:${STACK_VERSION} \
  -f /usr/share/logstash/logstash-news-v1.conf
