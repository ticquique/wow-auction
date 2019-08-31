FROM ubuntu:latest as base
LABEL maintainer="ticquique@gmail.com"

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    cron \
    curl \
    jq \
    vim \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /home/results

# Create the log file to be able to run tail
RUN touch /var/log/cron.log
COPY dockerd-entrypoint.sh /usr/local/bin/dockerd-entrypoint.sh

RUN chmod +x /usr/local/bin/dockerd-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/dockerd-entrypoint.sh"]

CMD ["serve"]
FROM base as build

COPY ./retriever.sh home/retriever.sh