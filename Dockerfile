### install debian ###
FROM debian:jessie
MAINTAINER ulf.seltmann@metaccount.de
EXPOSE 80 443 3306
VOLUME ["/var/lib/mysql", "/var/run/mysqld", "/app", "/var/lib/xdebug"]
ENTRYPOINT ["/docker/init"]
CMD ["run"]

# adding dot-deb repository
RUN apt-get update \
 && apt-get -y dist-upgrade \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y wget less vim supervisor nullmailer graphviz locales ssh rsync graphicsmagick-imagemagick-compat libapache2-mod-shib2

RUN echo "deb http://packages.dotdeb.org jessie all" >/etc/apt/sources.list.d/dotdeb.list \
 && wget -O - http://www.dotdeb.org/dotdeb.gpg | apt-key add - \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y openssl ca-certificates apache2-mpm-worker apache2-suexec libapache2-mod-fcgid \
        php5-cgi php5-cli php-pear php5-curl php5-gd php5-intl php5-ldap php5-readline php5-mcrypt php5-mysqlnd php5-sqlite php5-xcache php5-xdebug php5-xsl php5-xhprof php5-dev \
        make mysql-client mysql-server unzip

ENV APP_HOME=/app \
 APP_USER=dev \
 FCGID_MAX_REQUEST_LEN=16384000 \
 TIME_ZONE=Europe/Berlin \
 WEBGRIND_ARCHIVE=1.1.0 \
 WEBGRIND_FORK=rovangju \
 SHIB_HOSTNAME=https://localhost:443 \
 SHIB_HANDLER_URL=/Shibboleth.sso \
 SHIB_SP_ENTITY_ID=https://hub.docker.com/r/smoebody/dev-dotdeb \
 SHIB_IDP_DISCOVERY_URL=https://wayf.aai.dfn.de/DFN-AAI-Test/wayf \
 SQL_MODE="" \
 SMTP_HOST="" \
 SMTP_NAME=dev-dotdeb \
 SMTP_PORT=25

COPY assets/build /docker/build
RUN chmod 755 /docker/build/init \
 && /docker/build/init

COPY assets/setup /docker/setup
COPY assets/init /docker/init
RUN chmod 755 /docker/init