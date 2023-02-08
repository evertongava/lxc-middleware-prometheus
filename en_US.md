# Linux Container Middleware Prometheus
Alpine Linux container image containing the open source Prometheus version.

**Summary**
1. License
2. Overview
3. Settings
	1. Settings Files
		1. Configuration File
		2. Recording Rules Files
		3. Alerting Rules Files
	2. Environment Variables
		1. Log Format
		2. Log Level
	3. Data Storage
4. Run
	1. Testing the image
	2. Using Docker
	3. Using Docker Compose
	4. Using Kubernetes

## 1. License

This image is protected by the AGPL license and can be used on SaaS platforms.

## 2. Overview

This image contains Prometheus version 2.41.0 open source. Log level set to Info and format of log messages set to JSON.

Directory structure:
* /etc/prometheus - directory of settings and rules files
* /usr/share/prometheus - home directory
* /var/data/prometheus - data storage directory

For more details about the image, see the **[Dockerfile](./Dockerfile)**.

For more details about Prometheus, see the **[Prometheus official documentation](https://prometheus.io/docs/introduction/overview/)**

## 3. Settings

### 3.1. Settings Files

#### 3.1.1. Configuration File

The **default settings** of prometheus can be changed by overwriting the file **/etc/prometheus/prometheus.yml**

For more details on writing the **[prometheus.yml](./assets/prometheus.yml)** files, see the **[Prometheus official documentation](https://prometheus.io/docs/prometheus/2.41/getting_started/)**

#### 3.1.2. Recording Rules Files

The **recording rule files** must be contained in **/etc/prometheus/recordings**.

You should set up a **volume** and mount it in **/etc/prometheus/recordings** to keep the **recording rules files** external to your container safely in production

#### 3.1.3. Alerting Rules Files

The **alert rules files** must be contained in **/etc/prometheus/alerts**.

You should set up a **volume** and mount it in **/etc/prometheus/alerts** to keep the **alert rules files** outside your container safely in production

### 3.2. Environment Variables

#### 3.2.1. Log Format

The **format of log messages** is defined by the environment variable **PROMETHEUS_LOGFORMAT**.

Must be defined using one of the values ​​below:
* FRMTLOG (Prometheus Standard Format)
* JSON

#### 3.2.2. Log Level

The **log level** is defined by the **PROMETHEUS_LOGLEVEL** environment variable.

Must be defined using one of the values ​​below:
* debug
* info
* warn
* error

### 3.3. Data Storage

You should set up a **volume** and mount at **/var/data/prometheus** to keep data outside your container safely in production

### 4. Run

#### 4.1. Testing the image

The command below creates and runs the container.

`docker run -it -rm -p 9090:9090 --expose 9090/tcp --name prometheus evertongava/prometheus:2.41.0`

To view metrics, go to (http://127.0.0.1:9090/metrics).

To access the administrative panel, go to (http://127.0.0.1:9090/graph).

#### 4.2. Using Docker

Create the **alerting** directory in your **workspace** and place the **alert rules files** inside it.

Create the **recording** directory in your **workspace** and place the **recording rules files** inside it.

Download the **run settings file, [prometheus.yml](./assets/prometheus.yml)** to your **workspace**.

Edit the file to configure the **run settings file** as specified in the **[official Prometheus documentation](https://prometheus.io/docs/prometheus/2.41/getting_started/)**

The command below creates the prometheus-data volume to store metrics data outside the container.

`docker volume create prometheus-data` 

The command below creates and runs the container.

`docker run -d -e PROMETHEUS_LOGFORMAT=json -e PROMETHEUS_LOGLEVEL=debug --mount type=bind,source="$(pwd)"/prometheus.yml,target=/etc/prometheus/prometheus.yml -v "$(pwd)"/alerting:/etc/prometheus/alerting/ -v "$(pwd)"/recording:/etc/prometheus/recording/ -v prometheus-data:/var/data/prometheus -p 9090:9090 --expose 9090/tcp --name prometheus evertongava/prometheus:2.41.0`

#### 4.3. Using Docker Compose

Download the [docker-compose.yaml](./docker-compose.yaml) file to your **workspace**.

Create the **alerting** directory in your workspace and place the **alert rules files** inside it.

Download the **run settings file, [prometheus.yml](./assets/prometheus.yml)** to your **workspace**.

Edit the file to configure the **run settings files** as per the specifications contained in the **[official Prometheus documentation](https://prometheus.io/docs/prometheus/2.41/getting_started/)**

The command below creates and runs the container.

`docker compose up -d`

#### 4.4. Using Kubernetes

Download the **zipped archive** from **[repository](https://github.com/evertongava/lxc-middleware-prometheus/archive/refs/tags/v2.41.0.tar.gz)**

Unzip the file in your **workspace**.

Run the command below to deploy the configmap **[configmap-prometheus-settings](./k8s/configmap-prometheus-settings.yaml)** containing the Prometheus run settings file.

`kubectl apply -f ./k8s/configmap-prometheus-settings.yaml`

Run the command below to deploy the configmap **[configmap-prometheus-alerting](./k8s/configmap-prometheus-alerting.yaml)** containing the **alert rules files**.

`kubectl apply -f ./k8s/configmap-prometheus-alerting.yaml`

Run the command below to deploy the configmap **[configmap-prometheus-recording](./k8s/configmap-prometheus-recording.yaml)** containing the **recording rules files**.

`kubectl apply -f ./k8s/configmap-prometheus-recording.yaml`

Run the command below to deploy **[statefulset-prometheus](./k8s/statefulset-prometheus.yaml)**.

`kubectl apply -f ./k8s/statefulset-prometheus.yaml`

Run the command below to deploy **[svc-prometheus](./k8s/svc-prometheus.yaml)**.

`kubectl apply -f ./k8s/svc-prometheus.yaml`

Run the command below to deploy **[ingress-prometheus](./k8s/ingress-prometheus.yaml)**.

`kubectl apply -f ./k8s/ingress-prometheus.yaml`

Run the command below to deploy view the **ip address** of the Ingress display contained in the **ADDRESS** field.

`kubectl get ingress`

To view metrics, go to (http://<ip address>:9090/metrics).

To access the administrative panel, go to (http://<ip address>.1:9090/graph).

**[<- go back](./README.md)**