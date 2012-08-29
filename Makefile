WD := $(shell pwd)
SCRIPTS := $(WD)/scripts
SOLR := $(WD)/solr/example/start.jar
PY := venv/bin/python
PIP := venv/bin/pip


# Installation
.PHONY: install_dev
install_dev: initialize_data initialize_cache create_venv initialize_venv_dev download_solr


# Setup (First run)
.PHONY: setup_all
setup_all: start_solr setup_localwiki

.PHONY: setup_localwiki
setup_localwiki:
	localwiki-manage setup_all 


# Run
.PHONY: run_server
run_server: start_solr run_localwiki

.PHONY: run_localwiki
run_localwiki:
	localwiki-manage runserver


# Data
.PHONY: initialize_data
initialize_data:
	mkdir data

.PHONY: clean_data
clean_data:
	rm -rf data


# Cache
.PHONY: initialize_cache
initialize_cache:
	mkdir cache

.PHONY: clean_cache
clean_cache:
	rm -rf cache


# Databse
.PHONY: clean_database
clean_database:
	dropdb -h localhost -U postgres localwiki

.PHONY: clean_database_user
clean_database_user:
	dropuser -h localhost -U postgres localwiki


# Virtualenv
.PHONY: create_venv
create_venv:
	virtualenv -p python2.7 --distribute --no-site-packages venv

.PHONY: initialize_venv_dev
initialize_venv_dev:
	$(PIP) install -r requirements_dev.txt

.PHONY: clean_venv
clean_venv:
	rm -rf venv


# Solr
.PHONY: download_solr
download_solr:
	$(SCRIPTS)/download_solr.sh

.PHONY: start_solr
start_solr:
	$(SCRIPTS)/start_solr.sh

.PHONY: stop_solr
stop_solr:
	$(SCRIPTS)/stop_solr.sh


# Cleaning
.PHONY: clean_all
clean_all: clean_venv clean_build clean_cache clean_data clean_database clean_database_user

.PHONY: clean_build
clean_build:
	rm -rf venv/build

