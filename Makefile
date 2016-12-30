SHELL=/bin/bash

CMD_IMPLS := $(shell find src/cluster/commands -name '*.cr')
CMD_TESTS := $(shell find spec/cluster/commands -name '*.cr')
API_FILES := $(shell find doc/api -name '*.*')

.PHONY : all spec test

all: API.md src/cluster/commands/api.cr

test: all spec check_version_mismatch

API.md: $(API_FILES) doc/api/impl doc/api/test Makefile
	crystal doc/api/doc.cr > API.md

doc/api/impl: $(CMD_IMPLS) Makefile
	grep -hv "^\s*#" $(CMD_IMPLS) | grep -Phoe "(def|proxy|proxy_\w+) (\w+)"  | cut -d' ' -f2 | sort | uniq > $@

doc/api/test: $(CMD_TESTS) Makefile
	grep -hv "^\s*#" $(CMD_TESTS) | grep -Phoe '(it|describe) "#(\w+)' | cut -d'#' -f2 | sort | uniq > $@

src/cluster/commands/api.cr: $(API_FILES) Makefile
	crystal doc/api/gen.cr > $@

spec:
	crystal spec -v --fail-fast

.PHONY : check_version_mismatch
check_version_mismatch: shard.yml README.md
	diff -w -c <(grep version: README.md) <(grep ^version: shard.yml)
