# Linux Container Middleware Prometheus
Imagen de Alpine Linux container que contiene la versión de código abierto de Prometheus.

**Índice**
1. Licencia
2. Descripción General
3. Ajustes
	1. Archivos de Configuración
		1. Archivo de Configuración
		2. Archivos de Reglas de Grabación
		3. Archivos de Reglas de Alerta
	2. Variables de Entorno
		1. Formato de Log
		2. Nivel de Log
	3. Almacenamiento de Datos
4. Ejecución
	1. Probando la imagen
	2. Uso de Docker
	3. Uso de Docker Compose
	4. Uso de Kubernetes

## 1. Licencia

Esta imagen está protegida por la licencia AGPL y se puede utilizar en plataformas SaaS.

## 2. Descripción General

Esta imagen contiene Prometheus versión 2.41.0 de código abierto. El nivel de registro se establece en Información y el formato de los mensajes de registro se establece en JSON.

Estructura de directorios:
* /etc/prometheus - directorio de configuración y archivos de reglas
* /usr/share/prometheus - directorio de inicio
* /var/data/prometheus - directorio de almacenamiento de datos

Para obtener más detalles sobre la imagen, consulte **[Dockerfile](./Dockerfile)**

Para obtener más detalles sobre Prometheus, consulte la **[documentación oficial de Prometheus](https://prometheus.io/docs/introduction/overview/)**

## 3. Ajustes

### 3.1. Archivos de configuración

#### 3.1.1. Archivo de Configuración

La **configuración predeterminada** de prometheus se puede cambiar sobrescribiendo el archivo **/etc/prometheus/prometheus.yml**

Para obtener más detalles sobre cómo escribir los archivos **[prometheus.yml](./assets/prometheus.yml)**, consulte la **[documentación oficial de Prometheus](https://prometheus.io/docs/prometheus/2.41/ empezando/)**

#### 3.1.2. Archivos de Reglas de Grabación

Los **archivos de reglas de grabación** deben estar contenidos en **/etc/prometheus/recordings**.

Debe configurar un **volumen** y montarlo en **/etc/prometheus/recordings** para mantener los **archivos de reglas de grabación** externos a su contenedor de forma segura en producción.

#### 3.1.3. Archivos de Reglas de Alerta

Los **archivos de reglas de alerta** deben estar contenidos en **/etc/prometheus/alerts**.

Debe configurar un **volumen** y montarlo en **/etc/prometheus/alerts** para mantener los **archivos de reglas de alerta** fuera de su contenedor de forma segura en producción.

### 3.2. Environment Variables

#### 3.2.1. Formato de Log

El **formato de los mensajes de log** está definido por la variable de entorno **PROMETHEUS_LOGFORMAT**.

Debe definirse usando uno de los valores a continuación:
* FRMTLOG (formato estándar de Prometheus)
*JSON

#### 3.2.2. Nivel de Log

El **nivel de log** está definido por la variable de entorno **PROMETHEUS_LOGLEVEL**.

Debe definirse usando uno de los valores a continuación:
* depurar
* información
* advertir
* error

### 3.3. Almacenamiento de datos

Debe configurar un **volumen** y montarlo en **/var/data/prometheus** para mantener los datos fuera de su contenedor de forma segura en producción.

### 4. Ejecución

#### 4.1. Probando la imagen

El siguiente comando crea y ejecuta el contenedor.

`docker run -it -rm -p 9090:9090 --expose 9090/tcp --name prometheus evertongava/prometheus:2.41.0`

Para ver las métricas, vaya a (http://127.0.0.1:9090/metrics).

Para acceder al panel administrativo, vaya a (http://127.0.0.1:9090/graph).

#### 4.2. Uso de Docker

Cree el directorio de **alertas** en su **área de trabajo** y coloque los **archivos de reglas de alerta** dentro de él.

Cree el directorio de **grabación** en su **espacio de trabajo** y coloque los **archivos de reglas de grabación** dentro de él.

Descargue el **archivo de configuración de ejecución, [prometheus.yml](./assets/prometheus.yml)** en su **área de trabajo**.

Edit the file to configure the **run settings file** as specified in the **[official Prometheus documentation](https://prometheus.io/docs/prometheus/2.41/getting_started/)**

`docker volume create prometheus-data` 

El siguiente comando crea y ejecuta el contenedor.

`docker run -d -e PROMETHEUS_LOGFORMAT=json -e PROMETHEUS_LOGLEVEL=debug --mount type=bind,source="$(pwd)"/prometheus.yml,target=/etc/prometheus/prometheus.yml -v "$(pwd)"/alerting:/etc/prometheus/alerting/ -v "$(pwd)"/recording:/etc/prometheus/recording/ -v prometheus-data:/var/data/prometheus -p 9090:9090 --expose 9090/tcp --name prometheus evertongava/prometheus:2.41.0`

#### 4.3. Uso de Docker Compose

Descargue el archivo [docker-compose.yaml](./docker-compose.yaml) en su **espacio de trabajo**.

Cree el directorio de **alertas** en su espacio de trabajo y coloque los **archivos de reglas de alerta** dentro de él.

Descargue el **archivo de configuración de ejecución, [prometheus.yml](./assets/prometheus.yml)** en su **área de trabajo**.

Edite el archivo para configurar los **archivos de configuración de ejecución** según las especificaciones contenidas en la **[documentación oficial de Prometheus](https://prometheus.io/docs/prometheus/2.41/getting_started/)**

El siguiente comando crea y ejecuta el contenedor.

`docker compose up -d`

#### 4.4. Uso de Kubernetes

Descargue el **archivo comprimido** del **[repositorio](https://github.com/evertongava/lxc-middleware-prometheus/archive/refs/tags/v2.41.0.tar.gz)**

Descomprime el archivo en tu **espacio de trabajo**.

Ejecute el siguiente comando para implementar el mapa de configuración **[configmap-prometheus-settings](./k8s/configmap-prometheus-settings.yaml)** que contiene el archivo de configuración de ejecución de Prometheus.

`kubectl apply -f ./k8s/configmap-prometheus-settings.yaml`

Ejecute el siguiente comando para implementar el mapa de configuración **[configmap-prometheus-alerting](./k8s/configmap-prometheus-alerting.yaml)** que contiene los **archivos de reglas de alerta**.
`kubectl apply -f ./k8s/configmap-prometheus-alerting.yaml`

Ejecute el siguiente comando para implementar el mapa de configuración **[configmap-prometheus-recording](./k8s/configmap-prometheus-recording.yaml)** que contiene los **archivos de reglas de grabación**.

`kubectl apply -f ./k8s/configmap-prometheus-recording.yaml`

Ejecute el siguiente comando para implementar **[statefulset-prometheus-prometheus](./k8s/statefulset-prometheus-prometheus.yaml)**.

`kubectl apply -f ./k8s/statefulset-prometheus-prometheus.yaml`

Ejecute el siguiente comando para implementar **[svc-prometheus](./k8s/svc-prometheus.yaml)**

`kubectl apply -f ./k8s/svc-prometheus.yaml`

Ejecute el siguiente comando para implementar **[ingress-prometheus](./k8s/ingress-prometheus.yaml)**

`kubectl apply -f ./k8s/ingress-prometheus.yaml`

Ejecute el siguiente comando para desplegar la vista de la **dirección IP** de la pantalla de Ingress contenida en el campo **ADDRESS**.

`kubectl get ingress`

Para ver las métricas, vaya a (http://<dirección IP>:9090/metrics).

Para acceder al panel administrativo, vaya a (http://<dirección ip>.1:9090/graph).

**[regresa](./README.md)**