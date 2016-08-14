CMD_IMPLS := $(shell find src/cluster/commands -name '*.cr')
CMD_TESTS := $(shell find spec/cluster/commands -name '*.cr')
DOC_FILES := $(shell find doc -name '*.*')

all: API.md

API.md: $(DOC_FILES)
	crystal doc/build.cr > API.md

doc/api.impl: $(CMD_IMPLS) Makefile
	grep -hv "^\s*#" $(CMD_IMPLS) | grep -Phoe "(def|proxy|proxy_\w+) (\w+)"  | cut -d' ' -f2 | uniq > doc/api.impl

doc/api.test: $(CMD_TESTS) Makefile
	grep -hv "^\s*#" $(CMD_TESTS) | grep -Phoe '(it|describe) "#(\w+)' | cut -d'#' -f2 | uniq > doc/api.test
