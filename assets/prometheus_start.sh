#!/bin/sh

prometheus \
	--config.file="/etc/prometheus/prometheus.yml" \
	--web.cors.origin=".*" \
	--storage.tsdb.path="/var/data/prometheus" \
	--log.level="${PROMETHEUS_LOGLEVEL}" \
	--log.format="${PROMETHEUS_LOGFORMAT}"