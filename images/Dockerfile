FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=America/Sao_Paulo \
    SENAITE_HOME=/opt/senaite

# Dependências de sistema (compilação + libs runtime comuns do plone/senaite)
RUN apt-get update && apt-get install -y \
    git curl ca-certificates build-essential \
    libbz2-dev zlib1g-dev libssl-dev libsqlite3-dev libffi-dev uuid-dev \
    libnss3-dev libgdbm-dev libgdbm-compat-dev libncursesw5-dev liblzma-dev libreadline-dev \
    libpcre3-dev libcairo2 libpango-1.0-0 libpangocairo-1.0-0 \
    python2.7 python2.7-dev python-pip \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p ${SENAITE_HOME} /data && useradd -m -u 1000 senaite \
    && chown -R senaite:senaite ${SENAITE_HOME} /data

WORKDIR ${SENAITE_HOME}
COPY requirements.txt buildout.cfg ./

# Buildout rodando no build (imagem fica pronta e imutável)
RUN pip2 install --no-cache-dir -r requirements.txt \
 && buildout -c buildout.cfg

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER senaite
EXPOSE 8080 8100
VOLUME ["/data"]

ENTRYPOINT ["/entrypoint.sh"]
