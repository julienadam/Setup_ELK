ARG STACK_VERSION=not_set
FROM docker.elastic.co/elasticsearch/elasticsearch:${STACK_VERSION}

# Add a few analysis plugins for asian languages
RUN bin/elasticsearch-plugin install analysis-nori && bin/elasticsearch-plugin install analysis-kuromoji && bin/elasticsearch-plugin install analysis-smartcn && bin/elasticsearch-plugin install analysis-icu

# Add hunspell dictionaries
RUN mkdir -p config/hunspell/fr && mkdir -p config/hunspell/en-GB
ADD --chown=elasticsearch:elasticsearch --chmod=444 https://raw.githubusercontent.com/wooorm/dictionaries/main/dictionaries/fr/index.aff https://raw.githubusercontent.com/wooorm/dictionaries/main/dictionaries/fr/index.dic config/hunspell/fr/
ADD --chown=elasticsearch:elasticsearch --chmod=444 https://raw.githubusercontent.com/wooorm/dictionaries/main/dictionaries/en-GB/index.aff https://raw.githubusercontent.com/wooorm/dictionaries/main/dictionaries/en-GB/index.dic config/hunspell/en-GB/

# Add sample synonym files
RUN mkdir -p config/analysis/synonyms
ADD --chown=elasticsearch:elasticsearch --chmod=660 https://raw.githubusercontent.com/agora-team/elasticsearch-synonyms/master/data/be-ae.synonyms https://raw.githubusercontent.com/agora-team/elasticsearch-synonyms/master/data/medical-terms.synonyms config/analysis/synonyms/

# Add decompounding support files
# ADD --chown=elasticsearch:elasticsearch --chmod=660 https://master.dl.sourceforge.net/project/offo/offo-hyphenation/1.2/offo-hyphenation_v1.2.zip?viasf=1 /tmp/offo-hyphenation_v1.2.zip
RUN curl -o /tmp/offo-hyphenation_v1.2.zip https://master.dl.sourceforge.net/project/offo/offo-hyphenation/1.2/offo-hyphenation_v1.2.zip?viasf=1 && mkdir -p config/analysis/decompounding && unzip /tmp/offo-hyphenation_v1.2.zip -d /tmp && rm /tmp/offo-hyphenation_v1.2.zip && cp /tmp/offo-hyphenation/hyph/*.xml config/analysis/decompounding/ && rm -rf /tmp/offo-hyphenation

# Add lemmatizer plugin and support files
# RUN  bin/elasticsearch-plugin install https://github.com/vhyza/elasticsearch-analysis-lemmagen/releases/download/v8.6.1/elasticsearch-analysis-lemmagen-8.6.1-plugin.zip && mkdir -p config/lemmagen
# ADD --chown=elasticsearch:elasticsearch --chmod=660 https://github.com/vhyza/lemmagen-lexicons/raw/master/free/lexicons/fr.lem https://github.com/vhyza/lemmagen-lexicons/raw/master/free/lexicons/en.lem config/lemmagen/
