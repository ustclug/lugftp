#!/bin/sh

set -eu

template_vars='${LDAP_BASE} ${LDAP_URI} ${PASV_ADDRESS} ${PRIVATE_USERNAME} ${SERVER_NAME} ${VSFTPD_ANON_SSL} ${VSFTPD_SSL}'
for config in \
    ldap/ldap.conf \
    nginx/sites-available/default \
    nslcd.conf \
    ssh/sshd_config \
    vsftpd/vsftpd.conf
do
    envsubst "$template_vars" \
        < "/opt/container/etc/$config" \
        > "/etc/$config"
done

case "$PRIVATE_USERNAME" in
    ''|*[!a-zA-Z0-9_-]*|-*)
        echo "Invalid PRIVATE_USERNAME: $PRIVATE_USERNAME" >&2
        exit 1
        ;;
esac

if ! id "$PRIVATE_USERNAME" >/dev/null 2>&1; then
    useradd -M -d /srv/ftp "$PRIVATE_USERNAME"
fi
gpasswd -a "$PRIVATE_USERNAME" ftp >/dev/null
gpasswd -a ftp ftp >/dev/null
printf '%s:%s\n' ftp "$PUBLIC_PASSWD" | chpasswd
printf '%s:%s\n' "$PRIVATE_USERNAME" "$PRIVATE_PASSWD" | chpasswd

mkdir -p /var/log/nginx /var/run/sshd /var/run/vsftpd/empty /srv/ftp /srv/ssl
ssh-keygen -A
if [ ! -s /srv/ssl/server.crt ] || [ ! -s /srv/ssl/server.key ]; then
    openssl req -quiet -x509 -newkey rsa:2048 -nodes -days 3650 \
        -subj "/CN=$SERVER_NAME" \
        -keyout /srv/ssl/server.key \
        -out /srv/ssl/server.crt
fi

if [ -d /opt/scripts ]; then
    run-parts --verbose --exit-on-error /opt/scripts
fi

nginx -t
exec /usr/bin/s6-svscan /etc/s6
