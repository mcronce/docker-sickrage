FROM alpine:edge
MAINTAINER tim@haak.co

ENV LANG='en_US.UTF-8' \
    LANGUAGE='en_US.UTF-8' \
    TERM='xterm'

RUN apk add --no-cache --virtual .deps ca-certificates py2-pip python py-libxml2 py-lxml unrar tzdata openssl libffi

RUN \
    apk add --no-cache --virtual .build-deps make gcc g++ python-dev openssl-dev libffi-dev && \
    pip --no-cache-dir install --upgrade setuptools && \
    pip --no-cache-dir install --upgrade pyopenssl cheetah requirements && \
    apk del --no-cache .build-deps

RUN \
	apk add --no-cache git && \
	git clone --depth 1 https://github.com/SickRage/SickRage.git /sickrage && \
	rm -Rvf /sickrage/.[a-z]* /sickrage/tests && \
	apk del --no-cache git

ADD ./start.sh /start.sh
RUN chmod u+x  /start.sh

VOLUME ["/config", "/data", "/cache"]

EXPOSE 8081

CMD ["/start.sh"]

