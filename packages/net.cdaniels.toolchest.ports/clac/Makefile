NET_CDANIELS_TOOLCHEST_DIR=$(shell echo $$NET_CDANIELS_TOOLCHEST_DIR)
PACKAGE_NAME=$(shell echo $$PACKAGE_NAME)
PACKAGE_DIR=$(shell echo $$PACKAGE_PATH)
BIN_DIR=$(NET_CDANIELS_TOOLCHEST_DIR)/local/bin
LIB_DIR=$(NET_CDANIELS_TOOLCHEST_DIR)/local/lib/$(PACKAGE_NAME)
INSTALL_DIR=$(PACKAGE_DIR)/bin
UPSTREAM_URL=https://github.com/soveran/clac
UNAME_S := $(shell uname -s)
TIMESTAMP=$(shell iso8601date)
LOG_DIR=$(NET_CDANIELS_TOOLCHEST_DIR)/local/log
LOG_FILE=$(LOG_DIR)/$(PACKAGE_NAME)-$(TIMESTAMP).install.log

install: preflight
	@echo "INFO: log file for installation is: $(LOG_FILE)"
	@printf "INFO: retreving sources for $(PACKAGE_NAME) from upstream... "
	@cd $(INSTALL_DIR) && git clone $(UPSTREAM_URL) > $(LOG_FILE) 2>&1
	@echo "DONE"
	@printf "INFO: compiling binaries... "
	@cd $(INSTALL_DIR)/$(PACKAGE_NAME) && make >> $(LOG_FILE) 2>&1
	@echo "DONE"
	@printf "INFO: linking package files... "
	@ln -s $(INSTALL_DIR)/$(PACKAGE_NAME)/$(PACKAGE_NAME) $(BIN_DIR)/$(PACKAGE_NAME)

	@echo "DONE"

preflight:
	@printf "INFO: preparing environment... "
	@# make sure the bin dir exists for us to install to
	@rm -rf $(INSTALL_DIR) ||:
	@mkdir $(INSTALL_DIR)
	@-rm -rf $(LIB_DIR) ||:
	@mkdir $(LIB_DIR)
	@echo "DONE"

uninstall:
	@printf "INFO: unlinking $(PACKAGE_NAME) files... "
	@rm $(BIN_DIR)/$(PACKAGE_NAME) ||:
	@echo "DONE"
	@printf "INFO: cleaning install directory... "
	@rm -rf $(INSTALL_DIR)/* ||:
	@echo "DONE"
	@echo "INFO: uninstalled $($PACKAGE_NAME)"
