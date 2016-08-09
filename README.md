# dev-dotdeb

## What is this image intended for?

This image goes to all the php developers that want a developmnent testing environment set up in no time.

It is out of the box usable on linux hosts with a docker version >= 1.3

The image prepares apache2, php and mysql and wraps around your local codebase.

* baseimage: debian:latest (wheezy)
* apache 2.4 with libapache_mod-fcgid
* php 5.4.36 from the famous dotdeb repository
* mysql 5.6 from the famous dotdeb repository
* [webgrind][1]
* [composer][2]

## How to use this image

now you can use the docker to use this folder as vufind base and wrap the runtime environment around

    docker run --name dev-dotdeb -d -v /path/to/my/project:/app -p 127.0.0.1:80:80 smoebody/dev-dotdeb

this starts the container named _dev-dotdeb_ and sets up all the components with its default values. you should now be able
to reach the your project folder at

http://127.0.0.1/

## How to debug

By default php is configured up to start a debugging session indicated by request parameters. this comes in handy to use
with several browser-addons (e.g. [xdebug-helper for chrome][3]). Therefore the IDE should be configured to accept remotely
started debugging sessions.

## How to to profile

Also xdebug is able to profile script runs. The trace protocols can be used to determine potential performance issues.
A tool that analyses that protocols is [webgrind][1] which is integrated in the docker image and reachable here

http://127.0.0.1/webgrind

## how to test mail send

This utilises the docker-image [smoebody/mailcollect][5] which acts as smtp-server and catches all sent emails in one inbox,
regardless where its sent.

to use it in conjunction with this docker-image you should start a container first. after its up and running you have
to link this container to the dev-dotdeb container by adding the _--link_ option to the run-command above

    docker run --name dev-dotdeb -d -v /path/to/my/project:/app -p 127.0.0.1:80:80 --link=mailcollect:smtp smoebody/dev-dotdeb

The dev-dotdeb container is now connected to the mailcollect container and all mail that is sent by it ends in the
mailcollects inbox. see [smoebody/mailcollect][5] for further details.

## run a interactive console in the container

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
* `SHIB_HOSTNAME=https://services.ub.uni-leipzig.de:443`<br/>
defines the hostname, port and scheme that is used to create the metadata for SP-registration (schema and port are taken from the request, not from this configuration!)
* `SHIB_HANDLER_URL=/Shibboleth.sso`<br/>
defines the shibboleth handler location
* `SHIB_SP_ENTITY_ID=https://hub.docker.com/r/smoebody/dev-dotdeb`<br/>
defines the sp's entity id
* `SHIB_IDP_DISCOVERY_URL=https://wayf.aai.dfn.de/DFN-AAI-Test/wayf`<br/>
defines the discovery url. you can also define a distinct IDP by providing the variable `SHIB_IDP_ENTITY_ID` instead

for now only DFN-Test-IDP Metadata is supported.

## To do

* outsource database utilisation


  [1]: https://code.google.com/p/webgrind/
  [2]: https://getcomposer.org/
  [3]: https://github.com/mac-cain13/xdebug-helper-for-chrome
  [4]: http://www.phing.info/
  [5]: https://registry.hub.docker.com/u/smoebody/mailcollect/