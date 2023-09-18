#!/bin/bash
export $(grep -v '^#' ../.env | xargs)
echo "Importing template"
curl \
  -k \
  -H "Content-Type: application/json" \
  -u elastic:${ELASTIC_PASSWORD} \
  -XPUT https://localhost:9200/_index_template/dvf_v4_template \
  --data-binary @dvf_v4_template.json

echo Running logstash import for dvf-01-2020.csv
cat ~/data/dvf-01-2020.csv | docker run --rm -i \
  --network host \
  --env-file ../.env \
  -e XPACK_MONITORING_ENABLED=false \
  -v ${PWD}/logstash-dvf-v4.conf:/usr/share/logstash/logstash-dvf-v4.conf \
  docker.elastic.co/logstash/logstash:${STACK_VERSION} \
  -w 1 -f /usr/share/logstash/logstash-dvf-v4.conf

echo Running logstash import for dvf-02-2020.csv
cat ~/data/dvf-02-2020.csv | docker run --rm -i \
  --network host \
  --env-file ../.env \
  -e XPACK_MONITORING_ENABLED=false \
  -v ${PWD}/logstash-dvf-v4.conf:/usr/share/logstash/logstash-dvf-v4.conf \
  docker.elastic.co/logstash/logstash:${STACK_VERSION} \
  -w 1 -f /usr/share/logstash/logstash-dvf-v4.conf