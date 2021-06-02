# docker-dev-dotdeb

[![](https://images.microbadger.com/badges/version/useltmann/dev-dotdeb.svg)](http://microbadger.com/images/useltmann/dev-dotdeb "Get your own version badge on microbadger.com")

## What is this image intended for?

This image goes to all the php developers that want a developmnent testing environment set up in no time.

It is out of the box usable on linux hosts with a docker version >= 1.3

The image prepares apache2, php and mysql and wraps around your local codebase.

the following tools next to apache2, php 7.2 (depending on the label) and mysql are at your service:

* xdebug
* phpinfo


## How to use this image

Now you can use the docker to use this folder as vufind base and wrap the runtime environment around

    docker run --name dev-dotdeb -d -v /path/to/my/project:/app -p 127.0.0.1:80:80 useltmann/dev-dotdeb

This starts the container named _dev-dotdeb_ and sets up all the components with its default values. You should now be able
to reach the your project folder at

http://127.0.0.1/

## How to debug

By default php is configured up to start a debugging session indicated by request parameters. This comes in handy to use
with several browser-addons (e.g. [xdebug-helper for chrome][3]). Therefore the IDE should be configured to accept remotely
started debugging sessions.

## PHPINFO

Look at the PHP-configuration at http://127.0.0.1/phpinfo

## How to test mail send

This utilises the docker-image [useltmann/mailcollect][5] which acts as smtp-server and catches all sent emails in one inbox,
regardless where its sent.

To use it in conjunction with this docker-image you should start a container first. After container is running you have
to link this container to the dev-dotdeb container by adding the _--link_ option to the run-command above

    docker run --name dev-dotdeb -d -v /path/to/my/project:/app -p 127.0.0.1:80:80 --link=mailcollect:smtp -e SMTP_HOST=smtp docker.io/useltmann/dev-dotdeb

The dev-dotdeb container is now connected to the mailcollect container and all mail that is sent by it ends in the mailcollects inbox. See [useltmann/mailcollect][5] for further details.

## Run an interactive console in the container

    docker exec -ti dev-dotdeb /bin/bash

## Advanced configuration

the following environment variables can be set when creating (run) a new container.
the values given here are the default values.

* `APP_HOME=/app`<br/>
defines the application folder, normally where your application resides. there are some rare cases where strange software needs to
be configured to reside in a special place
* `APP_USER=dev`<br/>
defines the user php is running with
* `FCGID_MAX_REQUEST_LEN=16384000`<br/>
defines the maximum request length that the webserver (apache2) is passing to the fcgi daemon (php)
* `TIME_ZONE=Europe/Berlin`
defines the timezone php is working in
* `SHIB_HOSTNAME=https://localhost`<br/>
defines the hostname, port and scheme that is used to create the metadata for SP-registration (schema and port are taken from the request, not from this configuration!)
* `SHIB_HANDLER_URL=/Shibboleth.sso`<br/>
defines the shibboleth handler location
* `SHIB_SP_ENTITY_ID=https://hub.docker.com/r/useltmann/dev-dotdeb`<br/>
defines the sp's entity id. **be aware that you have to specify a different entityId in order to enable shibboleth support. if you leave the default entityId, shibboleth will not start**
* `SHIB_IDP_DISCOVERY_URL=https://wayf.aai.dfn.de/DFN-AAI-Test/wayf`<br/>
defines the discovery url. you can also define a distinct IDP by providing the variable `SHIB_IDP_ENTITY_ID` instead
* `SHIB_STATUS_ACL`<br />
defines the ip from where shibboleth status requests are allowed. normally this is your public ip
* `SHIB_ATTRIBUTE_MAP`<br />
defines simple attribute mappings in style `name=id` and seperate multiple definitions with comma, i.e. if you want to define a new Attribute with name "urn:oid:1.3.6.1.4.1.5923.1.1.1.9" and id "affiliation" you should do as follows' `SHIB_ATTRIBUTE_MAP="urn:oid:1.3.6.1.4.1.5923.1.1.1.9=affiliation"
* `SQL_MODE`<br />
defines the sql_mode that mysqld is running with. I.e. `SQL_MODE="STRICT_TRANS_TABLES"`
* `SMTP_HOST`<br />
defines the smtp host that takes mails sent by php. if none is provided the php default values take place
* `SMTP_NAME=dev-dotdeb`<br />
defines the host name as which the container sents his emails
* `SMTP_PORT=25`<br />
defines the port on which the container trys to connect to the smtp host

At the moment only DFN-Test-IDP Metadata is supported.


  [1]: https://code.google.com/p/webgrind/
  [2]: https://getcomposer.org/
  [3]: https://github.com/mac-cain13/xdebug-helper-for-chrome
  [4]: http://www.phing.info/
  [5]: https://registry.hub.docker.com/u/useltmann/mailcollect/
