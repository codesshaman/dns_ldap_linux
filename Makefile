name = DNX & LDAP Server

NO_COLOR=\033[0m	# Color Reset
COLOR_OFF=\e[0m		# Color Off
OK_COLOR=\033[32;01m	# Green Ok
ERROR_COLOR=\033[31;01m	# Error red
WARN_COLOR=\033[33;01m	# Warning yellow


# git clone github-repo:codesshaman/dns_ldap_linux.git

addgrp:
	@printf "Add new group...\n"
	@bash scripts/addgroup.sh

addusr:
	@printf "Add new user...\n"
	@bash scripts/adduser.sh

all:
	@printf "Launch configuration ${name}...\n"
	$(PYTHON) main.py

check:
	@printf "$(YELLOW)==== Check objects on ldap database... ====$(NO_COLOR)\n"
	@bash scripts/check.sh

env:
	@printf "$(ERROR_COLOR)==== Create environment file for ${name}... ====$(NO_COLOR)\n"
	@if [ -f .env ]; then \
		rm .env; \
	fi; \
	cp .env.example .env

git:
	@printf "$(YELLOW)==== Set user name and email to git for ${name} repo... ====$(NO_COLOR)\n"
	@bash scripts/gituser.sh

help:
	@echo -e "$(OK_COLOR)==== All commands of ${name} configuration ====$(NO_COLOR)"
	@echo -e "$(WARN_COLOR)- make addgrp				: Add new groups"
	@echo -e "$(WARN_COLOR)- make addgrp				: Add new user"
	@echo -e "$(WARN_COLOR)- make check				: Check objects on ldap database"
	@echo -e "$(WARN_COLOR)- make help				: Short manual"
	@echo -e "$(WARN_COLOR)- make				    	: Application launch"
	@echo -e "$(WARN_COLOR)- make push				: Push to the repository"
	@echo -e "$(WARN_COLOR)- make clean				: Clean applicatin cache"
	@echo -e "$(WARN_COLOR)- make fclean				: Remove virtual environment"

install:
	@printf "$(YELLOW)==== Install all packages... ====$(NO_COLOR)\n"
	@bash scripts/install.sh

push:
	@printf "$(YELLOW)==== Push changes to the ${name} repo... ====$(NO_COLOR)\n"
	@bash scripts/push.sh

clean:
	@printf "$(ERROR_COLOR)==== Cleaning cache ${name}... ====$(NO_COLOR)\n"
	@find . -name '*.pyc' -delete
	@find . -name '__pycache__' -type d | xargs rm -fr

fclean: clean
	@printf "$(ERROR_COLOR)==== Cleaning configuration ${name}... ====$(NO_COLOR)\n"
	@rm -rf ${VENV}

.PHONY	: all help make migrate venv vexit clean
