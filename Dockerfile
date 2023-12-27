ARG STACK_VERSION=not_set
FROM docker.elastic.co/elasticsearch/elasticsearch:${STACK_VERSION}

RUN bin/elasticsearch-plugin install analysis-nori && bin/elasticsearch-plugin install analysis-kuromoji && bin/elasticsearch-plugin install analysis-smartcn && bin/elasticsearch-plugin install analysis-icu
RUN mkdir config/hunspell && mkdir config/hunspell/fr && mkdir config/hunspell/en-GB
ADD --chown=elasticsearch:elasticsearch --chmod=444 https://raw.githubusercontent.com/wooorm/dictionaries/main/dictionaries/fr/index.aff https://raw.githubusercontent.com/wooorm/dictionaries/main/dictionaries/fr/index.dic config/hunspell/fr/
ADD --chown=elasticsearch:elasticsearch --chmod=444 https://raw.githubusercontent.com/wooorm/dictionaries/main/dictionaries/en-GB/index.aff https://raw.githubusercontent.com/wooorm/dictionaries/main/dictionaries/en-GB/index.dic config/hunspell/en-GB/