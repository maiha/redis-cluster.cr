CMD_IMPLS := $(shell find src/cluster/commands -name '*.cr')
CMD_TESTS := $(shell find spec/cluster/commands -name '*.cr')
API_FILES := $(shell find doc/api -name '*.*')

.PHONY : all

all: API.md src/cluster/commands/api.cr

API.md: $(API_FILES) doc/api/impl doc/api/test Makefile
	crystal doc/api/doc.cr > API.md

doc/api/impl: $(CMD_IMPLS) Makefile
	grep -hv "^\s*#" $(CMD_IMPLS) | grep -Phoe "(def|proxy|proxy_\w+) (\w+)"  | cut -d' ' -f2 | uniq > $@

doc/api/test: $(CMD_TESTS) Makefile
	grep -hv "^\s*#" $(CMD_TESTS) | grep -Phoe '(it|describe) "#(\w+)' | cut -d'#' -f2 | uniq > $@

src/cluster/commands/api.cr: $(API_FILES) Makefile
	crystal doc/api/gen.cr > $@
