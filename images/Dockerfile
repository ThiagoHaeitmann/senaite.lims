FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=America/Sao_Paulo \
    SENAITE_HOME=/opt/senaite

RUN apt-get update && apt-get install -y \
    ca-certificates curl git build-essential \
    python2.7 python2.7-dev python-pip \
    libffi-dev libssl-dev zlib1g-dev libbz2-dev libsqlite3-dev \
    libxml2-dev libxslt1-dev \
    libcairo2 libpango-1.0-0 libpangocairo-1.0-0 \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p ${SENAITE_HOME} /data \
 && useradd -m -u 1000 senaite \
 && chown -R senaite:senaite ${SENAITE_HOME} /data

WORKDIR ${SENAITE_HOME}
COPY requirements.txt buildout.cfg ./
RUN pip2 install --no-cache-dir -r requirements.txt \
 && buildout -c buildout.cfg

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh \
 && chown -R senaite:senaite ${SENAITE_HOME}

USER senaite
EXPOSE 8080 8100
VOLUME ["/data"]
ENTRYPOINT ["/entrypoint.sh"]
