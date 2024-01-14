#!/bin/bash

mkdir ~/data
wget -O ~/data/news.ndjson.gz "https://drive.usercontent.google.com/download?id=1-3A7rU1QDWFbQnt4QTIge_7vfRaDMpKd&export=download&confirm=t&uuid=e9629a77-a24e-449c-a480-a08a546d8ecf"
gunzip ~/data/news.ndjson.gz

docker run --rm \
  --network host \
  --env-file ../.env \
  -e XPACK_MONITORING_ENABLED=false \
  -v ~/data:/data \
  -v ./logstash-news-v1.conf:/usr/share/logstash/logstash-news-v1.conf \
  docker.elastic.co/logstash/logstash:8.9.2 \
  -f /usr/share/logstash/logstash-news-v1.conf
