u := $(if $(update),-u)

export GO111MODULE=on

.PHONY: build
build: deps
	go build -ldflags=$(BUILD_LDFLAGS) -o bin/deglacer ./cmd/deglacer

.PHONY: deps
deps:
	go get ${u} -d
	go mod tidy

.PHONY: devel-deps
devel-deps:
	sh -c '\
	tmpdir=$$(mktemp -d); \
	cd $$tmpdir; \
	go get ${u} \
	  golang.org/x/lint/golint \
	  github.com/Songmu/godzil/cmd/godzil; \
	rm -rf $$tmpdir'

.PHONY: test
test:
	go test -race

.PHONY: lint
lint: devel-deps
	golint -set_exit_status

.PHONY: release
release: devel-deps
	godzil release
