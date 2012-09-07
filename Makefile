WD := $(shell pwd)
CACHE_DIR := $(WD)/cache
VENV := $(WD)/venv
PY := $(VENV)/bin/python
PIP := $(VENV)/bin/pip

# localwiki variables
LOCALWIKI_INSTANCE := $(VENV)/share/localwiki
LOCALWIKI_SETTINGS := $(LOCALWIKI_INSTANCE)/conf/localsettings.py
LOCALWIKI_MANAGE := $(VENV)/bin/localwiki-manage

# solr variables
SOLR_DIR := $(WD)/solr
SOLR_PORT := 8080
SOLR_VERSION := 3.6.1
SOLR_FILE := apache-solr-$(SOLR_VERSION)
SOLR_ZIP := $(SOLR_FILE).zip
SOLR_DOWNLOAD=http://mirror.metrocast.net/apache/lucene/solr/$(SOLR_VERSION)/$(SOLR_ZIP)


# Installation (Downloads, venv creation, venv initilization)
.PHONY: install_dev
install_dev: install_system_packages create_venv download_solr setup_venv_dev apply_django_postgis_adapter_2_patch

.PHONY: install_system_packages
install_system_packages:
	sudo apt-get update
	cat dep-pkg-list | xargs sudo apt-get -y install


# Setup
.PHONY: setup_dev
setup_dev: install_solr setup_localwiki_dev

.PHONY: reset_dev
reset_dev: reset_solr reset_localwiki_dev


# localwiki
.PHONY: setup_localwiki
setup_localwiki:
	$(LOCALWIKI_MANAGE) setup_all

.PHONY: setup_localwiki_dev
setup_localwiki_dev: start_solr setup_localwiki stop_solr

.PHONY: clean_localwiki_dev
clean_localwiki_dev: clean_database
	rm -rf $(LOCALWIKI_INSTANCE)

.PHONY: reset_localwiki_dev
reset_localwiki_dev: clean_localwiki_dev setup_localwiki_dev


# Run
.PHONY: run_server_dev
run_server_dev: start_solr run_localwiki

.PHONY: run_localwiki
run_localwiki:
	$(LOCALWIKI_MANAGE) runserver


# Cache
.PHONY: create_cache
create_cache:
	mkdir -p $(CACHE_DIR)

.PHONY: clean_cache
clean_cache:
	rm -rf $(CACHE_DIR)


# Database
.PHONY: clean_database
clean_database: clean_database_db clean_database_user

.PHONY: clean_database_db
clean_database_db:
	psql -h localhost -U postgres -c "DROP DATABASE IF EXISTS localwiki"

.PHONY: clean_database_user
clean_database_user:
	psql -h localhost -U postgres -c "DROP USER IF EXISTS  localwiki"


# Virtualenv
.PHONY: create_venv
create_venv:
	virtualenv -p python2.7 --distribute --no-site-packages $(VENV)

.PHONY: setup_venv_dev
setup_venv_dev:
	$(PIP) install -r requirements_dev.txt

.PHONY: clean_venv
clean_venv:
	rm -rf $(VENV)

.PHONY: reset_venv
reset_venv: clean_venv create_venv setup_venv_dev


# Patches to fix various things
# Fixes https://code.djangoproject.com/ticket/16778
.PHONY: apply_django_postgis_adapter_2_patch
apply_django_postgis_adapter_2_patch:
	wget -O $(CACHE_DIR)/postgis-adapter-2.patch https://code.djangoproject.com/raw-attachment/ticket/16778/postgis-adapter-2.patch
	patch $(VENV)/lib/python2.7/site-packages/django/contrib/gis/db/backends/postgis/adapter.py $(CACHE_DIR)/postgis-adapter-2.patch


# Solr
.PHONY: download_solr
download_solr: create_cache
	wget -O $(CACHE_DIR)/$(SOLR_ZIP) $(SOLR_DOWNLOAD)
	unzip -q $(CACHE_DIR)/$(SOLR_ZIP) -d $(CACHE_DIR)/

.PHONY: install_solr
install_solr: 
	cp -R $(CACHE_DIR)/$(SOLR_FILE)/example $(SOLR_DIR)
	mv $(SOLR_DIR)/solr/conf/schema.xml $(SOLR_DIR)/solr/conf/schema.xml.orig
	cp $(VENV)/src/localwiki/install_config/solr_schema.xml $(SOLR_DIR)/solr/conf/schema.xml
	cp $(VENV)/src/localwiki/install_config/daisydiff.war $(SOLR_DIR)/webapps/

.PHONY: start_solr
start_solr:
	if ! lsof -i :$(SOLR_PORT); then \
	echo Starting Solr on port $(SOLR_PORT); \
	cd $(SOLR_DIR); java -Djetty.port=$(SOLR_PORT) -jar $(SOLR_DIR)/start.jar & \
	sleep 10; \
	else \
	echo Solr is already running on port $(SOLR_PORT); \
	fi

.PHONY: stop_solr
stop_solr:
	jps -l | grep start.jar | cut -d ' ' -f 1 | xargs -rn1 kill; \
	sleep 5;

.PHONY: clean_solr_data
clean_solr_data: stop_solr
	rm -rf $(SOLR_DIR)

.PHONY: clean_solr
clean_solr: clean_solr_data
	rm -f $(CACHE_DIR)/$(SOLR_ZIP)
	rm -rf $(CACHE_DIR)/$(SOLR_FILE)

.PHONY: reset_solr
reset_solr: clean_solr_data install_solr


# Importers
.PHONY: install_importers
install_importers: 
	$(PIP) install --upgrade --force-reinstall -r requirements_importers.txt
	sed -ie 's/LOCAL_INSTALLED_APPS = ()/LOCAL_INSTALLED_APPS = ("importers",)/g' $(LOCALWIKI_SETTINGS)

.PHONY: run_importer_mediawiki
run_importer_mediawiki: start_solr
	$(LOCALWIKI_MANAGE) import_mediawiki


# Cleaning
.PHONY: clean_all
clean_all: clean_venv clean_solr clean_cache clean_database

