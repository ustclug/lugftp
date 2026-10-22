FROM debian:trixie AS theme

ARG FANCYINDEX_THEME_COMMIT=ee2e73c8dd1584b84ddad0cfcc44fbd903bdccd8

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl \
    && mkdir -p /theme \
    && curl --fail --location --silent --show-error \
        "https://github.com/Naereen/Nginx-Fancyindex-Theme/archive/${FANCYINDEX_THEME_COMMIT}.tar.gz" \
      | tar -xz --strip-components=1 -C /theme

FROM debian:trixie AS yatex

ARG YATEX_VERSION=0.0.2
ARG YATEX_SHA256=1157f9f8e6d7217c61b6bff0dd33260afb5486becdbe7c24cab70ebd23de6653

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl \
    && mkdir -p /yatex \
    && curl --fail --location --silent --show-error \
        --output /tmp/yatex.tar.gz \
        "https://github.com/ustclug/yatex/releases/download/v${YATEX_VERSION}/yatex_${YATEX_VERSION}_linux_amd64.tar.gz" \
    && echo "${YATEX_SHA256}  /tmp/yatex.tar.gz" | sha256sum --check - \
    && tar -xzf /tmp/yatex.tar.gz -C /yatex

FROM debian:trixie

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        gettext-base \
        libnginx-mod-http-fancyindex \
        libnss-ldapd \
        libpam-ldapd \
        libvips42t64 \
        nginx \
        nslcd \
        openssh-server \
        openssl \
        s6 \
        vsftpd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV LANG=C.UTF-8 \
    LANGUAGE=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PUBLIC_PASSWD=ftp \
    PRIVATE_USERNAME=lug \
    PRIVATE_PASSWD=password \
    SERVER_NAME=ftp.lug.ustc.edu.cn \
    PASV_ADDRESS=127.0.0.1 \
    VSFTPD_SSL=YES \
    VSFTPD_ANON_SSL=YES \
    LDAP_URI=ldaps://ldap.lug.ustc.edu.cn \
    LDAP_BASE=dc=lug,dc=ustc,dc=edu,dc=cn

COPY entrypoint.sh /entrypoint.sh
COPY etc /opt/container/etc
COPY --from=theme /theme/Nginx-Fancyindex /usr/share/nginx/fancyindex-theme
COPY --from=theme /theme/LICENSE /usr/share/doc/nginx-fancyindex-theme/copyright
COPY --from=yatex /yatex/yatex /usr/local/bin/yatex
COPY --from=yatex /yatex/config.yml /etc/yatex/config.yml

RUN cp -a /opt/container/etc/. /etc/ \
    && cp -L /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && useradd -M -d /srv/ftp lug \
    && mkdir -p \
        /var/run/sshd \
        /var/run/vsftpd/empty \
        /srv/ftp \
        /srv/ssl \
    && echo "session required    pam_exec.so /etc/init_home.sh" >> /etc/pam.d/common-session

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 20-22 80 443 40000-40050
