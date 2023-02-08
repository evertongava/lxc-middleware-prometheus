# Linux Container Middleware Prometheus
Imagem Linux Conteiner em Alpine contendo o Prometheus versão open source.

**Sumário**
1. Licença
2. Visão Geral
3. Configurações
	1. Arquivos de configurações
		1. Arquivo de configuração
		2. Arquivos de Regras de Gravação
		3. Arquivos de Regras de Alerta
	2. Variáveis de Ambiente
		1. Formato de Log
		2. Nível de Log
	3. Armazenamento de Dados
4. Execução
	1. Testando a imagem
	2. Usando o Docker
	3. Usando o Docker Compose
	4. Usando o Kubernetes

## 1. Licença
Esta imagem está protegida pela licença AGPL e pode ser utilizada em plataformas SaaS.

## 2. Visão Geral
Esta imagem contém o Prometheus versão 2.41.0 open source. O nível de log definido como Info e o formato das mensagens de log definido como JSON.

Estrutura de diretórios:
* /etc/prometheus - diretório de arquivos de configurações e regras
* /usr/share/prometheus - diretório home
* /var/data/prometheus - diretório de armazenamento dos dados

Para mais detalhes sobre a imagem, veja o **[Dockerfile](./Dockerfile)**.

Para mais detalhes sobre o prometheus, consultar a **[documentação oficial do Prometheus](https://prometheus.io/docs/introduction/overview/)**

## 3. Configurações

### 3.1. Arquivos de configurações

#### 3.1.1. Arquivo de configuração

As **configurações padrões** do prometheus podem ser alteradas sobreescrevendo o arquivo **/etc/prometheus/prometheus.yml**

Para mais detalhes sobre escrever o arquivo **[prometheus.yml](./assets/prometheus.yml)**, consultar a **[documentação oficial do Prometheus](https://prometheus.io/docs/prometheus/2.41/getting_started/)**

#### 3.1.2. Arquivos de Regras de Gravação

Os **arquivos de regras de gravação** devem estar contidos em **/etc/prometheus/recordings**. 

Você deve configurar um **volume** e montar em **/etc/prometheus/recordings** para manter os **arquivos de regras de gravação** externo ao seu conteiner de maneira segura em produção

#### 3.1.3. Arquivos de Regras de Alerta

Os **arquivos de regras de alerta** devem estar contidos em **/etc/prometheus/alerts**. 

Você deve configurar um **volume** e montar em **/etc/prometheus/alerts** para manter os **arquivos de regras de alerta** externo ao seu conteiner de maneira segura em produção

### 3.2. Variáveis de Ambiente

#### 3.2.1. Formato de Log

O **formato das mensagens de log** é configurável pela variável de ambiente **PROMETHEUS_LOGFORMAT**.

Deve ser configurada usando um dos valores abaixo:
* FRMTLOG (Formato Padrão Prometheus)
* JSON

#### 3.2.2. Nível de Log

O **nível de log** é configurável pela variável de ambiente **PROMETHEUS_LOGLEVEL**.

Deve ser configurada usando um dos valores abaixo:
* debug
* info
* warn
* error

### 3.3. Armazenamento de Dados

Você deve configurar um **volume** e montar em **/var/data/prometheus** para manter os dados fora do seu conteiner de maneira segura em produção

### 4. Execução

#### 4.1. Testando a imagem

O comando abaixo cria e executa o conteiner.

`docker run -it -rm -p 9090:9090 --expose 9090/tcp --name prometheus evertongava/prometheus:2.41.0`

Para visualizar as métricas, acesse (http://127.0.0.1:9090/metrics).

Para acessar o painel administrativo, acesse (http://127.0.0.1:9090/graph).

#### 4.2. Usando o Docker

Crie o diretório **alerting** em sua **área de trabalho** e insira os **arquivos de regras de alerta** dentro dele.

Crie o diretório **recording** em sua **área de trabalho** e insira os **arquivos de regras de gravação** dentro dele.

Faça o download do **arquivo de configurações de execução, [prometheus.yml](./assets/prometheus.yml)** para sua **área de trabalho**.

Edite o arquivo para configurar o **arquivo de configurações de execução**, conforme as especificações contidas na **[documentação oficial do Prometheus](https://prometheus.io/docs/prometheus/2.41/getting_started/)**

O comando abaixo cria o volume prometheus-data para fazer o armazenamento dos dados de métricas externamente do conteiner.

`docker volume create prometheus-data` 

O comando abaixo cria e executa o conteiner.

`docker run -d -e PROMETHEUS_LOGFORMAT=json -e PROMETHEUS_LOGLEVEL=debug --mount type=bind,source="$(pwd)"/prometheus.yml,target=/etc/prometheus/prometheus.yml -v "$(pwd)"/alerting:/etc/prometheus/alerting/ -v "$(pwd)"/recording:/etc/prometheus/recording/ -v prometheus-data:/var/data/prometheus -p 9090:9090 --expose 9090/tcp --name prometheus evertongava/prometheus:2.41.0`

#### 4.3. Usando o Docker Compose

Faça download do arquivo [docker-compose.yaml](./docker-compose.yaml) para sua **área de trabalho**.

Crie o diretório **alerting** em sua **área de trabalho** e insira os **arquivos de regras de alerta** dentro dele.

Crie o diretório **recording** em sua **área de trabalho** e insira os **arquivos de regras de gravação** dentro dele.

Faça download do **arquivo de configurações de execução, [prometheus.yml](./assets/prometheus.yml)** para sua **área de trabalho**.

Edite o arquivo para configurar os **arquivos de configurações de execução**, conforme as especificações contidas na **[documentação oficial do Prometheus](https://prometheus.io/docs/prometheus/2.41/getting_started/)**

O comando abaixo cria e executa o conteiner.

`docker compose up -d`

#### 4.4. Usando o Kubernetes

Baixe o **arquivo compactado** do **[repositório](https://github.com/evertongava/lxc-middleware-prometheus/archive/refs/tags/v2.41.0.tar.gz)**

Descompacte o arquivo no sua **área de trabalho**.

Execute o comando baixo para implantar o configmap **[configmap-prometheus-settings](./k8s/configmap-prometheus-settings.yaml)** contendo o arquivo de configurações de execução do Prometheus.

`kubectl apply -f ./k8s/configmap-prometheus-settings.yaml`

Execute o comando baixo para implantar o configmap **[configmap-prometheus-alerting](./k8s/configmap-prometheus-alerting.yaml)** contendo os **arquivos de regras de alerta**.

`kubectl apply -f ./k8s/configmap-prometheus-alerting.yaml`

Execute o comando baixo para implantar o configmap **[configmap-prometheus-recording](./k8s/configmap-prometheus-recording.yaml)** contendo os **arquivos de regras de gravação**.

`kubectl apply -f ./k8s/configmap-prometheus-recording.yaml`

Execute o comando baixo para implantar o **[statefulset-prometheus](./k8s/statefulset-prometheus.yaml)**.

`kubectl apply -f ./k8s/statefulset.yaml`

Execute o comando baixo para implantar o **[svc-prometheus](./k8s/svc-prometheus.yaml)**.

`kubectl apply -f ./k8s/svc-prometheus.yaml`

Execute o comando baixo para implantar o **[ingress-prometheus](./k8s/ingress-prometheus.yaml)**.

`kubectl apply -f ./k8s/ingress-prometheus.yaml`

Execute o comando baixo para implantar visualizar o **endereço ip** da exposição do Ingress, contindo no campo **ADDRESS**.

`kubectl get ingress`

Para visualizar as métricas, acesse (http://<endereço ip>:9090/metrics).

Para acessar o painel administrativo, acesse (http://<endereço ip>.1:9090/graph).


**[voltar](./README.md)**