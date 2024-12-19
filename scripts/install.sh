#!/bin/bash

sudo apt update && \
sudo apt install -y \
    ldap-utils \
    bind9utils \
    bind9-doc \
    bind9 \
    slapd
    