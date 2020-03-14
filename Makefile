GOCMD=go
GOBUILD=$(GOCMD) build
GORUN=$(GOCMD) run
GOINSTALL=$(GOCMD) install
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test
DOCKER=docker
DBUILD=$(DOCKER) build
DTAG= $(DOCKER) tag
DPUSH= $(DOCKER) push

DOCKER_HUB_REPO=bikertales
BINARY_NAME=tcpbin
BINARY_VERSION=$(shell git rev-parse HEAD)
BINARY_UNIX=$(BINARY_NAME)
TAG_LOCAL = $(BINARY_NAME):$(BINARY_VERSION)
TAG_HUB = $(DOCKER_HUB_REPO)/$(BINARY_NAME):$(BINARY_VERSION)

.PHONY: build # - Builds linux arch go binary
build:
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 $(GOBUILD) -o $(BINARY_UNIX) -v

.PHONY: install  # - Installs go service 
install:
	$(GOBUILD) -o $(BINARY_UNIX) -v ./...

.PHONY: run # - Runs the service
run:
	$(GORUN) main.go

.PHONY: dbuild  # - Builds docker image
dbuild: build
	$(DBUILD) . -t $(TAG_LOCAL)

.PHONY: dtag # - Tags local image to docker hub tag
dtag: dbuild
	$(DTAG) $(TAG_LOCAL) $(TAG_HUB)

.PHONY: dpush # - Pushes tag to docker hub
dpush: dtag
	$(DPUSH) $(TAG_HUB)

.PHONY: tasks
tasks:
	@grep '^.PHONY: .* #' Makefile | sed 's/\.PHONY: \(.*\) # \(.*\)/\1 \2/' | expand -t20