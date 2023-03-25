build:
	docker build --tag ghcr.io/tarneaux/stagit .

push: build
	docker push ghcr.io/tarneaux/stagit
