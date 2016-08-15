CMD_IMPLS := $(shell find src/cluster/commands -name '*.cr')
CMD_TESTS := $(shell find spec/cluster/commands -name '*.cr')
API_FILES := $(shell find doc/api -name '*.*')
RAW_FILES := $(shell find doc/raw -name '*.*')

.PHONY : all api raw

all: api raw

raw: doc/raw/tsv src/ext/redis/raw.cr

API.md: $(API_FILES) doc/api/impl doc/api/test
	crystal doc/api/build.cr > API.md

doc/api/impl: $(CMD_IMPLS) Makefile
	grep -hv "^\s*#" $(CMD_IMPLS) | grep -Phoe "(def|proxy|proxy_\w+) (\w+)"  | cut -d' ' -f2 | uniq > $@

doc/api/test: $(CMD_TESTS) Makefile
	grep -hv "^\s*#" $(CMD_TESTS) | grep -Phoe '(it|describe) "#(\w+)' | cut -d'#' -f2 | uniq > $@

doc/raw/tsv: libs/redis/redis/commands.cr doc/api/impl Makefile
	grep -Po '(^\s+def \w+|\b\w+_command)' $< | uniq | sed -e 's/\s*def\s*//' | paste -d "\t" - - | grep -f doc/api/impl > $@

src/ext/redis/raw.cr: $(RAW_FILES)
	crystal doc/raw/build.cr > $@
