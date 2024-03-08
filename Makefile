# set makefile echo back
ifdef VERBOSE
	V :=
else
	V := @
endif

.PHONY: build
## build : Build binary
build: manager read_config ddns_resolute

.PHONY: bin
## bin : Create bin directory
bin:
	@mkdir -p build/bin

# .PHONY: install_config
# ## install : install config file in ~/.config/Echo
# install_config:
# 	@mkdir -p ~/.config/Echo
# 	@cp -f files/echo.conf ~/.config/Echo/

.PHONY: clean
## clean : clean all binary in bin directory
clean:
	@rm -f build/bin/*

.PHONY: help
## help : Print help message
help: Makefile
	@sed -n 's/^##//p' $< | awk 'BEGIN {FS = ":"} {printf "\033[36m%-23s\033[0m %s\n", $$1, $$2}'

# --------------- ------------------ ---------------
# --------------- User Defined Tasks ---------------

PHONY: manager
## manager : Build manager
manager: bin
	$(V)go build -o build/bin/manager main/manager.go

.PHONY: read_config
## read_config : Build read_config binary for test
read_config: bin
	$(V)go build -o build/bin/read_config examples/parser/parse_toml.go

.PHONY: ddns_resolute
## ddns_resolute : Build ddns_resolute binary for test
ddns_resolute: bin
	$(V)go build -o build/bin/dns-resolute examples/ddns/dns_resolute.go
