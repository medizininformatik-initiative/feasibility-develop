#!/usr/bin/env bash

# Arguments
#   1: docker-compose project token

cd zars

# FHIR ------------------------------------------------------------------------

echo "Starting ZARS FHIR app..."
docker-compose -p $1 up -d dsf-zars-fhir-proxy
echo -n "Waiting for full startup of the DSF ZARS FHIR app..."
( docker-compose -p $1 logs -f dsf-zars-fhir-app & ) | grep -E -q '^.* Server\.doStart.* \| Started.*'
echo "DONE"

# BPE -------------------------------------------------------------------------

echo -n "Setting permissions for ZARS BPE app..."
chmod a+w bpe/app/last_event
echo "DONE"

echo "Starting ZARS BPE app..."
docker-compose -p $1 up -d dsf-zars-bpe-app
echo -n "Waiting for full startup of the DSF ZARS BPE app..."
( docker-compose -p $1 logs -f dsf-zars-bpe-app & ) | grep -E -q '^.* Server\.doStart.* \| Started.*'
echo "DONE"
