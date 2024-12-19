#!/bin/bash

ldapsearch -x -b "dc=myhost,dc=loc" "(objectClass=*)"