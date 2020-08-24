.PHONY: test fixtures clean distclean src/git-gpg
ARCH := $(shell uname -s | tr '[:upper:]' '[:lower:]')-$(shell uname -m)

# Build the release
# -----------------

all: shard.lock build/git-gpg-$(ARCH)
	@rm -f build/*.dwarf

build/%-linux-x86_64: src/%.cr src/% | build
	crystal build $< -o $@ --release --static --progress

build/%-darwin-x86_64: src/%.cr src/% | build
	crystal build $< -o $@ --release --progress

shard.lock: shard.yml
	@shards install
	@shards prune

build:
	mkdir -p build

src/git-gpg: $(shell find src/git-gpg -type f -name *.cr)

# Test and development tools
# --------------------------

test: shard.lock bin/git-gpg
	./bin/ameba --all
	crystal spec --progress --order random

bin/%: src/%.cr src/%
	@shards build $(@F) --progress --debug
	@rm -f bin/*.dwarf

fixtures:
	gpg --encrypt --quiet --batch --no-tty \
		--recipient git-gpg-dev@ursa.dk \
		--output ./spec/fixtures/encrypted.bin ./spec/fixtures/decrypted.txt

# Clean up jobs
# -------------

clean:
	rm -Rf bin/{git-gpg,amber} lib/*
	find . -name *.dwarf -exec rm -f {} \;

distclean: clean
	rm -Rf build/*
	rm -f shard.lock
