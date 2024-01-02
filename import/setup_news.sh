#!/bin/bash

mkdir ~/data
echo "Dowloading news file"
wget -O ~/data/Latest_News.zip https://newsdata.io/files/datasets/latest-news
echo "Unzipping file"
unzip ~/data/Latest_News.zip -d ~/data
echo "Converting to NDJSON"
jq -c '.[]' ~/data/Latest_News/Latest_News.json > ~/data/Latest_News/Latest_News.ndjson

docker run --rm \
  --network host \
  --env-file ../.env \
  -e XPACK_MONITORING_ENABLED=false \
  -v ~/data/Latest_News/Latest_News.ndjson:/data/news.ndjson \
  -v ./logstash-news-v1.conf:/usr/share/logstash/logstash-news-v1.conf \
  docker.elastic.co/logstash/logstash:8.9.2 \
  -f /usr/share/logstash/logstash-news-v1.conf
