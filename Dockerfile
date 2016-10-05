FROM smartentry/debian:8-0.3.8

MAINTAINER Yifan Gao <docker@yfgao.com>

ADD . $ASSETS_DIR

RUN smartentry.sh build

EXPOSE 20-21 80 40000-40050

ENTRYPOINT ["/sbin/smartentry.sh"]

CMD ["/usr/bin/supervisord"]
