FROM smartentry/debian:12

MAINTAINER Yifan Gao <docker@yfgao.com>

ADD .docker $ASSETS_DIR

RUN smartentry.sh build

EXPOSE 20-22 80 443 40000-40050
