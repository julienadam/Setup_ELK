ARG STACK_VERSION=not_set
FROM docker.elastic.co/elasticsearch/elasticsearch:${STACK_VERSION}

RUN bin/elasticsearch-plugin install analysis-nori
RUN bin/elasticsearch-plugin install analysis-kuromoji
RUN bin/elasticsearch-plugin install analysis-smartcn
RUN bin/elasticsearch-plugin install analysis-icu