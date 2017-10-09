SHELL = /bin/bash -o pipefail

BUMP_VERSION := $(GOPATH)/bin/bump_version
MEGACHECK := $(GOPATH)/bin/megacheck

BAZEL_VERSION := 0.6.1
BAZEL_DEB := bazel_$(BAZEL_VERSION)_amd64.deb

IGNORES := 'github.com/kevinburke/ssh_config/config.go:U1000 github.com/kevinburke/ssh_config/config.go:S1002 github.com/kevinburke/ssh_config/token.go:U1000'

$(MEGACHECK):
	go get honnef.co/go/tools/cmd/megacheck

lint: $(MEGACHECK)
	go vet ./...
	$(MEGACHECK) --ignore=$(IGNORES) ./...

test: lint
	@# the timeout helps guard against infinite recursion
	bazel test --test_output=errors '//:all'

race-test:
	bazel test --test_output=errors --features=race //...

$(BUMP_VERSION):
	go get github.com/Shyp/bump_version

release: $(BUMP_VERSION)
	$(BUMP_VERSION) minor config.go

install-travis:
	wget "https://storage.googleapis.com/bazel-apt/pool/jdk1.8/b/bazel/$(BAZEL_DEB)"
	sudo dpkg --force-all -i $(BAZEL_DEB)
	sudo apt-get install moreutils -y

ci:
	set -o pipefail && bazel --batch --host_jvm_args=-Dbazel.DigestFunction=SHA1 test \
		--experimental_repository_cache="$$HOME/.bzrepos" \
		--spawn_strategy=remote \
		--test_output=errors \
		--strategy=Javac=remote \
		--noshow_progress \
		--noshow_loading_progress \
		--features=race //... 2>&1 | ts '[%Y-%m-%d %H:%M:%.S]'
