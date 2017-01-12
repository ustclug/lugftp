#!/bin/bash
[[ ! $PAM_USER ]] && exit

PAM_HOME=$(eval echo ~$PAM_USER)
[[ ! $PAM_HOME ]] && exit

if [[ ! -d $PAM_HOME ]]; then
    mkdir -p $PAM_HOME/public_html
    mkdir -p $PAM_HOME/private
    chown $PAM_USER:ldap_users $PAM_HOME/*
    chmod 555 $PAM_HOME
    chown root:root $PAM_HOME
fi
