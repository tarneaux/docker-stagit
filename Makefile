build:
	docker build --tag ghcr.io/tarneaux/stagit .

push: build
	docker push ghcr.io/tarneaux/stagit

prepare-test:
	mkdir example/repos && cd example/repos && git clone https://github.com/tarneaux/docker-stagit.git || exit 0 # ignore error if directory already exists

test: build prepare-test
	cd example && docker-compose up
