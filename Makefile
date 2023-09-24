ARCH := $(shell uname -s | tr '[:upper:]' '[:lower:]')-$(shell uname -m)
RECIPIENT := git-gpg-dev@ursa.dk

.PHONY: all lib debug release test
all: tests debug
lib: shard.lock
debug: targets garbage-collect
release: shard.lock $(ARCH) garbage-collect
test: tests

# Test and development tools
# --------------------------

.PHONY: targets
targets: shard.lock
	@shards build --progress --debug

.PHONY: tests
tests: shard.lock
	./bin/ameba --all
	@echo
	crystal spec --progress --order rand

shard.lock: shard.yml
	@shards install
	@shards prune
	@touch shard.lock

.PHONY: fixtures
fixtures:
	gpg --encrypt --quiet --batch --no-tty \
		--recipient $(RECIPIENT) \
		--output ./spec/fixtures/encrypted.bin ./spec/fixtures/decrypted.txt

# Build the release
# -----------------

.PHONY: linux-x86_64
linux-x86_64:
	@shards --production build --release --no-debug --static --progress

.PHONY: darwin-x86_64
darwin-x86_64:
	@shards --production build --release --no-debug --progress

# Remove development artefacts
# ----------------------------

.PHONY: garbage-collect
garbage-collect:
	@find . -type f \( -name .DS_Store -o -name "*.dwarf" \) -delete

.PHONY: clean
clean: garbage-collect
	@find ./lib -depth 1 -print -delete
	@find ./bin -type f -not -name docker -print -delete
	@touch shard.yml
