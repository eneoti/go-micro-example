
GOPATH:=$(shell go env GOPATH)

all: build

.PHONY: proto
proto:
	protoc --proto_path=${GOPATH}/src:. --micro_out=. --go_out=. proto/helloworld.proto

.PHONY: build
build: 

	go build -o helloworld ./main.go

.PHONY: test
test:
	go test -v ./... -cover

.PHONY: docker
docker:
	docker build . -t helloworld-srv:latest
