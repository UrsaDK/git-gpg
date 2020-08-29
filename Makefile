.PHONY: init tests targets fixtures release clean distclean \
				linux-x86_64 darwin-x86_64
ARCH := $(shell uname -s | tr '[:upper:]' '[:lower:]')-$(shell uname -m)
RECIPIENT := git-gpg-dev@ursa.dk

all: tests targets

# Test and development tools
# --------------------------

tests: shard.lock
	@./bin/ameba --all
	@crystal spec --progress --order random

shard.lock: shard.yml
	@shards install
	@shards prune

targets: shard.lock
	@shards build --progress --debug
	@rm -f bin/*.dwarf

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
	@rm -fv shard.lock build/*
