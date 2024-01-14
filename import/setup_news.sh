#!/bin/bash

mkdir ~/data
wget -O ~/data/news.ndjson.gz "https://formationdataaccount.blob.core.windows.net/formationdata/Latest_News.ndjson.gz"
gunzip ~/data/news.ndjson.gz

docker run --rm \
  --network host \
  --env-file ../.env \
  -e XPACK_MONITORING_ENABLED=false \
  -v ~/data:/data \
  -v ./logstash-news-v1.conf:/usr/share/logstash/logstash-news-v1.conf \
  docker.elastic.co/logstash/logstash:8.9.2 \
  -f /usr/share/logstash/logstash-news-v1.conf
