REPO = evertongava
NAME = prometheus
TAG = 2.41.0
IMAGE = $(REPO)/$(NAME):$(TAG)

build:
	docker build --no-cache -t "$(IMAGE)" .

push:
	docker push "$(IMAGE)"