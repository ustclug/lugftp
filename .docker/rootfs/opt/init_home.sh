#!/bin/bash
[[ ! $PAM_USER ]] && exit

PAM_HOME=$(eval echo ~$PAM_USER)
[[ ! $PAM_HOME ]] && exit

if [[ ! -d $PAM_HOME ]]; then
    mkdir -p $PAM_HOME/public_html
    chown -R $PAM_USER:ldap_users $PAM_HOME
    chmod 755 $PAM_HOME
fi
