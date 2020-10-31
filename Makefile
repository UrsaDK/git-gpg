.PHONY: lib targets tests fixtures release clean \
				linux-x86_64 darwin-x86_64
ARCH := $(shell uname -s | tr '[:upper:]' '[:lower:]')-$(shell uname -m)
RECIPIENT := git-gpg-dev@ursa.dk

all: tests debug
lib: shard.lock
debug: targets garbage-collect
release: shard.lock $(ARCH) garbage-collect
test: tests

# Test and development tools
# --------------------------

targets: shard.lock
	@shards build --progress --debug

tests: shard.lock
	./bin/ameba --all
	@echo
	crystal spec --progress --order rand

shard.lock: shard.yml
	@shards install
	@shards prune
	@touch shard.lock

fixtures:
	gpg --encrypt --quiet --batch --no-tty \
		--recipient $(RECIPIENT) \
		--output ./spec/fixtures/encrypted.bin ./spec/fixtures/decrypted.txt

# Build the release
# -----------------

linux-x86_64:
	@shards --production build --release --no-debug --static --progress

darwin-x86_64:
	@shards --production build --release --no-debug --progress

# Remove development artefacts
# ----------------------------

garbage-collect:
	@find . -type f \( -name .DS_Store -o -name "*.dwarf" \) -delete

clean: garbage-collect
	@find ./lib -depth 1 -print -delete
	@find ./bin -type f -not -name docker -print -delete
	@touch shard.yml
