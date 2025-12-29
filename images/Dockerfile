FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=America/Sao_Paulo \
    SENAITE_HOME=/opt/senaite

RUN apt-get update && apt-get install -y \
    ca-certificates curl git build-essential \
    python2.7 python2.7-dev \
    libffi-dev libssl-dev zlib1g-dev libbz2-dev libsqlite3-dev \
    libxml2-dev libxslt1-dev \
    libcairo2 libpango-1.0-0 libpangocairo-1.0-0 \
 && rm -rf /var/lib/apt/lists/*

# pip para Python 2 (obrigatório)
RUN curl -fsSL https://bootstrap.pypa.io/pip/2.7/get-pip.py -o /tmp/get-pip.py \
 && python2.7 /tmp/get-pip.py "pip<21" setuptools wheel \
 && rm /tmp/get-pip.py

RUN mkdir -p ${SENAITE_HOME} /data \
 && useradd -m -u 1000 senaite \
 && chown -R senaite:senaite ${SENAITE_HOME} /data

WORKDIR ${SENAITE_HOME}
COPY requirements.txt buildout.cfg ./

RUN python2.7 -m pip install --no-cache-dir -r requirements.txt \
 && python2.7 -m pip install zc.buildout \
 && python2.7 -m buildout -c buildout.cfg

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh \
 && chown -R senaite:senaite ${SENAITE_HOME}

USER senaite
EXPOSE 8080 8100
VOLUME ["/data"]
ENTRYPOINT ["/entrypoint.sh"]
