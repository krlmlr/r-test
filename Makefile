all: build

build:
	docker build --rm=false .

ping:
	git commit --allow-empty -m "ping"
	git push
