NET_CDANIELS_TOOLCHEST_DIR=$(shell echo $$NET_CDANIELS_TOOLCHEST_DIR)
PACKAGE_NAME=$(shell echo $$PACKAGE_NAME)
PACKAGE_DIR=$(shell echo $$PACKAGE_PATH)
BIN_DIR=$(NET_CDANIELS_TOOLCHEST_DIR)/local/bin
LIB_DIR=$(NET_CDANIELS_TOOLCHEST_DIR)/local/lib/$(PACKAGE_NAME)
INSTALL_DIR=$(PACKAGE_DIR)/lib
UNAME_S := $(shell uname -s)
TIMESTAMP=$(shell iso8601date)
LOG_DIR=$(NET_CDANIELS_TOOLCHEST_DIR)/local/log

install: preflight
	@printf "INFO: extracting files... "
	@cd "$(PACKAGE_DIR)/remote" ; tar xf "shellcheck.tar.xz"
	@cp "$(PACKAGE_DIR)/remote/shellcheck-latest/shellcheck" "$(LIB_DIR)"
	@echo "DONE"
	@printf "INFO: linking package files... "
	@ln -s $(LIB_DIR)/shellcheck "$(BIN_DIR)/shellcheck"
	@echo "DONE"

preflight:
	@echo "INFO: performing preflight checks for $(PACKAGE_NAME)"
	@printf "INFO: preparing environment... "
	@# make sure the bin dir exists for us to install to
	@-rm -rf $(INSTALL_DIR) ||:
	@mkdir $(INSTALL_DIR)
	@-rm -rf $(LIB_DIR) ||:
	@mkdir $(LIB_DIR)
	@echo "DONE"

uninstall:
	@printf "INFO: unlinking $(PACKAGE_NAME) files... "
	@-rm $(BIN_DIR)/shellcheck > /dev/null  2>&1 ||:
	@echo "DONE"
	@printf "INFO: cleaning install directory... "
	@-rm -rf $(INSTALL_DIR) > /dev/null 2>&1 ||:
	@-rm -rf $(LIB_DIR) > /dev/null 2>&1 ||:
	@-rm -rf $(PACKAGE_DIR)/remote > /dev/null 2>&1 ||:
	@echo "DONE"
	@echo "INFO: uninstalled $($PACKAGE_NAME)"
