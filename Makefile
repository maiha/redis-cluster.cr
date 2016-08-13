CMD_IMPLS := $(shell find src/cluster/commands -name '*.cr')
CMD_TESTS := $(shell find spec/cluster/commands -name '*.cr')

all: API.md

API.md: doc/build.cr doc/api.impl doc/api.test
	crystal doc/build.cr > API.md

doc/api.impl: $(CMD_IMPLS) Makefile
	grep -hv "^\s*#" $(CMD_IMPLS) | grep -Phoe "(def|proxy) (\w+)"  | cut -d' ' -f2 | uniq > doc/api.impl

doc/api.test: $(CMD_TESTS) Makefile
	grep -hv "^\s*#" $(CMD_TESTS) | grep -Phoe '(it|describe) "#(\w+)' | cut -d'#' -f2 | uniq > doc/api.test
