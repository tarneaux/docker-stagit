build:
	docker build --tag ghcr.io/tarneaux/stagit .

push: build
	docker push ghcr.io/tarneaux/stagit

test: build
	(cd example; mkdir repos; (cd repos; git clone https://github.com/tarneaux/docker-stagit.git); docker-compose up)
