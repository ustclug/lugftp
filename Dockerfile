FROM smartentry/debian:8-0.3.2

MAINTAINER Yifan Gao <docker@yfgao.com>

ADD .docker $ASSETS_DIR

RUN smartentry.sh build

EXPOSE 20-21 80 40000-40050

ENTRYPOINT ["/sbin/smartentry.sh"]

CMD ["exec", "/usr/bin/supervisord"]
