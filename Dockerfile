FROM smartentry/debian:9-0.4.0

MAINTAINER Yifan Gao <docker@yfgao.com>

ADD .docker $ASSETS_DIR

RUN smartentry.sh build

EXPOSE 20-21 80 443 40000-40050
