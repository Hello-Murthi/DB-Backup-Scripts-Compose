FROM ubuntu:20.04

COPY /scripts /scripts

# Install packages
RUN \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y curl unzip vim wget mongo-tools mysql-client lsb-release gnupg

RUN \
  sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list' && \
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
  apt-get update && \
  apt-get install -y postgresql-client-13
  
RUN apt-get install -y cron

# Set environment variables
ENV DEBIAN_FRONTEND noninteractive

#install elasticdump cli
RUN \
  curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
  apt-get install -y nodejs && \
  npm install -y elasticdump -g

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

RUN chmod +x /scripts/ElasticSearch.sh && \
    chmod +x /scripts/MongoDB.sh && \
    chmod +x /scripts/MySQL.sh && \
    chmod +x /scripts/Postgres.sh

# Setup cron job
RUN (crontab -l ; echo "0 0 * * * bash /scripts/ElasticSearch.sh >> /var/log/cron.log") | crontab - && \
    (crontab -l ; echo "0 0 * * * bash /scripts/MongoDB.sh >> /var/log/cron.log") | crontab - && \
    (crontab -l ; echo "0 0 * * * bash /scripts/MySQL.sh >> /var/log/cron.log") | crontab - && \
    (crontab -l ; echo "0 0 * * * bash /scripts/Postgres.sh >> /var/log/cron.log") | crontab -

# Define working directory.
WORKDIR /

ENTRYPOINT cron start && tail -f /var/log/cron.log
