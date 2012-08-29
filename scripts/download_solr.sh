#!/bin/sh
#TODO Check cache for previous solr download

SOLR_VERSION=3.6.1
SOLR_FILE=apache-solr-$SOLR_VERSION
SOLR_DOWNLOAD=http://mirror.metrocast.net/apache/lucene/solr/$SOLR_VERSION/$SOLR_FILE.zip

mkdir cache
mkdir data
cd cache
wget $SOLR_DOWNLOAD
unzip $SOLR_FILE.zip
cd ..
cp -R cache/$SOLR_FILE/example data/solr
mv data/solr/solr/conf/schema.xml data/solr/solr/conf/schema.xml.orig
cp venv/src/localwiki/install_config/solr_schema.xml data/solr/solr/conf/schema.xml
cp venv/src/localwiki/install_config/daisydiff.war data/solr/webapps/

