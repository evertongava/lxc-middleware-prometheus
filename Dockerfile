FROM evertongava/core-alpine:3.16.2
LABEL maintainer="Everton Gava <evertongava@mabalus.com>"

ARG PROMETHEUS_VERSION=2.41.0
ARG PROMETHEUS_DIR="/usr/share/prometheus"
ARG PROMETHEUS_SOURCE="/tmp/${ATLAS_DIR}"
ARG PROMETHEUS_PACKAGE="prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz"
ARG PROMETHEUS_REPO="https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/${PROMETHEUS_PACKAGE}"

ENV PROMETHEUS_LOGLEVEL=info
ENV PROMETHEUS_LOGFORMAT=json

WORKDIR /tmp/

COPY assets/prometheus.yml /etc/prometheus/
COPY assets/prometheus_start.sh /usr/bin/

RUN set -ex \
	&& mkdir -p \
		"${PROMETHEUS_DIR}" \
		/etc/prometheus \
		/var/data/prometheus \
	&& wget -q "${PROMETHEUS_REPO}" \
	&& tar zxf "${PROMETHEUS_PACKAGE}" -C "${PROMETHEUS_DIR}" --strip 1 \
	&& rm -f "${PROMETHEUS_PACKAGE}" \
	&& chown -R app:adm \
		"${PROMETHEUS_DIR}" \
		/etc/prometheus \
		/var/data/prometheus \
	&& ln -s "${PROMETHEUS_DIR}"/prometheus /usr/bin/prometheus \
	&& ln -s "${PROMETHEUS_DIR}"/promtool /usr/bin/promtool

USER app

WORKDIR /var/data/prometheus

EXPOSE 9090

CMD [ "prometheus_start.sh" ]