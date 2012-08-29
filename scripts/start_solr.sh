#!/bin/sh
if ! lsof -i :8080; then
    echo Starting Solr
    cd data/solr/
    java -Djetty.port=8080 -jar start.jar &
    sleep 10
else
   echo Solr is already running on port 8080
fi
