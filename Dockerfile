ARG STACK_VERSION=not_set
FROM docker.elastic.co/elasticsearch/elasticsearch:${STACK_VERSION}

# Add a few analysis plugins for asian
RUN bin/elasticsearch-plugin install analysis-nori && bin/elasticsearch-plugin install analysis-kuromoji && bin/elasticsearch-plugin install analysis-smartcn && bin/elasticsearch-plugin install analysis-icu

# Add hunspell dictionaries
RUN mkdir -p config/hunspell/fr && mkdir -p config/hunspell/en-GB
ADD --chown=elasticsearch:elasticsearch --chmod=444 https://raw.githubusercontent.com/wooorm/dictionaries/main/dictionaries/fr/index.aff https://raw.githubusercontent.com/wooorm/dictionaries/main/dictionaries/fr/index.dic config/hunspell/fr/
ADD --chown=elasticsearch:elasticsearch --chmod=444 https://raw.githubusercontent.com/wooorm/dictionaries/main/dictionaries/en-GB/index.aff https://raw.githubusercontent.com/wooorm/dictionaries/main/dictionaries/en-GB/index.dic config/hunspell/en-GB/

# Add sample synonym files
RUN mkdir -p config/analysis/synonyms
ADD --chown=elasticsearch:elasticsearch --chmod=660 https://raw.githubusercontent.com/agora-team/elasticsearch-synonyms/master/data/be-ae.synonyms https://raw.githubusercontent.com/agora-team/elasticsearch-synonyms/master/data/medical-terms.synonyms config/analysis/synonyms/
