### install debian ###
FROM debian:stretch
LABEL authors="Ulf Seltmann <ulf.seltmann@metaccount.de>, Frank Morgner <morgnerf@ub.uni-leipzig.de>"
EXPOSE 80 443 3306
VOLUME ["/var/lib/mysql", "/var/run/mysqld", "/app", "/var/lib/xdebug"]
ENTRYPOINT ["/docker/entrypoint"]
CMD ["run"]


RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y wget less vim supervisor nullmailer graphviz locales ssh rsync graphicsmagick-imagemagick-compat libapache2-mod-shib2 git gnupg2 lsb-release openssl ca-certificates apt-transport-https \
 && echo "deb http://packages.dotdeb.org stretch all" > /etc/apt/sources.list.d/dotdeb.list \
 && wget -O - http://www.dotdeb.org/dotdeb.gpg | apt-key add - \
 && echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list \
 && wget -O - https://packages.sury.org/php/apt.gpg | apt-key add - \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y apache2 libapache2-mod-fcgid \
        php7.2-fpm php7.2-cli php-pear php7.2-curl php7.2-gd php7.2-intl php7.2-ldap php7.2-readline php7.2-mysqlnd php7.2-sqlite php7.2-xdebug php7.2-xsl php7.2-mbstring php7.2-dev \
        make mysql-client mysql-server unzip \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /var/cache/apt/archives/*

ENV APP_HOME=/app \
 APP_USER=dev \
 FCGID_MAX_REQUEST_LEN=16384000 \
 TIME_ZONE=Europe/Berlin \
 WEBGRIND_ARCHIVE=v1.6.1 \
 WEBGRIND_FORK=jokkedk \
 SHIB_HOSTNAME=https://localhost \
 SHIB_HANDLER_URL=/Shibboleth.sso \
 SHIB_SP_ENTITY_ID=https://hub.docker.com/r/smoebody/dev-dotdeb \
 SHIB_IDP_DISCOVERY_URL=https://wayf.aai.dfn.de/DFN-AAI-Test/wayf \
 SHIB_ATTRIBUTE_MAP="" \
 SQL_MODE="" \
 SMTP_HOST="" \
 SMTP_NAME=dev-dotdeb \
 SMTP_PORT=25

COPY assets/init /docker/init
COPY assets/build /docker/build
RUN chmod 755 /docker/init \
 && /docker/init \
 && rm -rf /docker/build

COPY assets/setup /docker/setup
COPY assets/entrypoint /docker/entrypoint
RUN chmod 755 /docker/entrypoint
