.PHONY: lib targets tests fixtures release clean \
				linux-x86_64 darwin-x86_64
ARCH := $(shell uname -s | tr '[:upper:]' '[:lower:]')-$(shell uname -m)
RECIPIENT := git-gpg-dev@ursa.dk

all: tests targets
lib: shard.lock

# Test and development tools
# --------------------------

targets: shard.lock
	@shards build --progress --debug
	@rm -f bin/*.dwarf

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

release: shard.lock $(ARCH)
	@rm -f build/*.dwarf

linux-x86_64:
	@shards --production build --release --static --progress

darwin-x86_64:
	@shards --production build --release --progress

# Remove development artefacts
# ----------------------------

clean:
	@find . -type f \( -name .DS_Store -o -name "*.dwarf" \) -exec rm -f {} \;
	@rm -R -fv lib/* | grep -E "^removed directory: 'lib/[^/]+'" || :
	@find ./bin -type f -not -name docker -exec rm -fv {} \;
	@touch shard.yml
