# include root makefile
ifndef ROOT_MAKEFILE_MK
include ../../../Makefile
endif

# prevent rules from being evaluated/included multiple times
ifndef $(abspath $(lastword $(MAKEFILE_LIST)))_MK
$(abspath $(lastword $(MAKEFILE_LIST)))_MK := 1


# The following are control variables that determine what logic from `rules.mk` is enabled

# `true`/`false` to enable/disable the actual unit test command so it can be overridden (the targets are still created)
# applies to both the pony and elixir test targets
$(abspath $(lastword $(MAKEFILE_LIST)))_UNIT_TEST_COMMAND := false

# `true`/`false` to enable/disable generate pony related targets (build/test/clean) for pony sources in this directory
# otherwise targets only get created if there are pony sources (*.pony) in this directory.
$(abspath $(lastword $(MAKEFILE_LIST)))_PONY_TARGET := false

# `true`/`false` to enable/disable generate final file build target using ponyc command for the pony build target so
# it can be overridden manually
$(abspath $(lastword $(MAKEFILE_LIST)))_PONYC_TARGET := false

# `true`/`false` to enable/disable generate exs related targets (build/test/clean) for elixir sources in this directory
# otherwise targets only get created if there are elixir sources (*.exs) in this directory.
$(abspath $(lastword $(MAKEFILE_LIST)))_EXS_TARGET := false

# `true`/`false` to enable/disable generate docker related targets (build/push) for a Dockerfile in this directory
# otherwise targets only get created if there is a Dockerfile in this directory
$(abspath $(lastword $(MAKEFILE_LIST)))_DOCKER_TARGET := false

# `true`/`false` to enable/disable recursing into Makefiles of subdirectories if they exist
# (and by recursion every makefile in the tree that is referenced)
$(abspath $(lastword $(MAKEFILE_LIST)))_RECURSE_SUBMAKEFILES := false

CELSIUS_GO_PATH := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
GO_PONY_LIB := $(wallaroo_path)/go_api/go
CELSIUS_GOPATH := $(CELSIUS_GO_PATH)/go:$(GO_PONY_LIB)

# standard rules generation makefile
include $(rules_mk_path)

build-examples-go-celsius: celsius_go_build
unit-tests-examples-go-celsius: build-examples-go-celsius
integration-tests-examples-go-celsius: build-examples-go-celsius
integration-tests-examples-go-celsius: celsius_go_test
clean-examples-go-celsius: celsius_go_clean

celsius_go_build: $(CELSIUS_GO_PATH)/celsius

celsius_go_clean:
	$(QUIET)rm -rf $(CELSIUS_GO_PATH)/lib $(CELSIUS_GO_PATH)/.deps $(CELSIUS_GO_PATH)/celsius $(CELSIUS_GO_PATH)/celsius.d

-include $(CELSIUS_GO_PATH)/celsius.d
$(CELSIUS_GO_PATH)/celsius: $(CELSIUS_GO_PATH)/lib/libwallaroo.a
	$(call PONYC,$(abspath $(CELSIUS_GO_PATH:%/=%)))

$(CELSIUS_GO_PATH)/lib/libwallaroo.a: $(CELSIUS_GO_PATH)/go/src/celsius/celsius.go
	$(QUIET)export GOPATH=$(CELSIUS_GOPATH) && go build -buildmode=c-archive -o $(CELSIUS_GO_PATH)lib/libwallaroo.a celsius

celsius_go_test:
	cd $(CELSIUS_GO_PATH) && \
	integration_test --framed-file-sender \
	  _test.txt --validation-cmp \
	  --expected-file _expected.txt \
		--log-level error \
		--command './celsius' \
		--sink-mode newlines \
		--sink-expect 100

# end of prevent rules from being evaluated/included multiple times
endif
