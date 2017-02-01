NET_CDANIELS_TOOLCHEST_DIR=$(shell echo $$NET_CDANIELS_TOOLCHEST_DIR)
PACKAGE_NAME=$(shell echo $$PACKAGE_NAME)
PACKAGE_DIR=$(shell echo $$PACKAGE_PATH)
BIN_DIR=$(NET_CDANIELS_TOOLCHEST_DIR)/local/bin
LIB_DIR=$(NET_CDANIELS_TOOLCHEST_DIR)/local/lib/$(PACKAGE_NAME)
INSTALL_DIR=$(PACKAGE_DIR)/bin
UPSTREAM_URL=$(shell curl -s https://api.github.com/repos/ginatrapani/todo.txt-cli/releases/latest | grep 'browser_' | cut -d\" -f4)
UNAME_S := $(shell uname -s)
TIMESTAMP=$(shell iso8601date)
LOG_DIR=$(NET_CDANIELS_TOOLCHEST_DIR)/local/log
LOG_FILE=$(LOG_DIR)/$(PACKAGE_NAME)-$(TIMESTAMP).install.log

install: preflight
	@echo "INFO: log file for installation is: $(LOG_FILE)"
	@printf "INFO: retreving sources for $(PACKAGE_NAME) from upstream... "
	@cd $(INSTALL_DIR) && curl -L -O $(UPSTREAM_URL) >> $(LOG_FILE) 2>&1
	@echo "DONE"
	@echo "INFO: extracting package files... "
	@cd $(INSTALL_DIR) && tar xvf *.tar.gz   >> $(LOG_FILE) 2>&1
	@cd $(INSTALL_DIR) && rm *.tar.gz  >> $(LOG_FILE) 2>&1
	@cd $(INSTALL_DIR) && mv todo.txt_cli*/* ./  >> $(LOG_FILE) 2>&1
	@cd $(INSTALL_DIR) && rmdir todo.txt_cli*  >> $(LOG_FILE) 2>&1
	@printf "INFO: linking package files... "
	@ln -s $(INSTALL_DIR)/todo.sh $(BIN_DIR)/todotxt
	@chmod +x $(INSTALL_DIR)/todo.sh
	@echo "DONE"

preflight:
	@echo "INFO: performing preflight checks for $(PACKAGE_NAME)"
	@if ping -q -c 1 -W 1 8.8.8.8 >/dev/null ; then printf "" ; else echo "ERROR: no internet connection available!" ; exit 1 ; fi
	@printf "INFO: preparing environment... "
	@# make sure the bin dir exists for us to install to
	@-rm -rf $(INSTALL_DIR) ||:
	@mkdir $(INSTALL_DIR)
	@-rm -rf $(LIB_DIR) ||:
	@mkdir $(LIB_DIR)
	@echo "DONE"

uninstall:
	@printf "INFO: unlinking $(PACKAGE_NAME) files... "
	@-rm $(BIN_DIR)/todotxt >> $(LOG_FILE) 2>&1 ||:
	@echo "DONE"
	@printf "INFO: cleaning install directory... "
	@-rm -rf $(INSTALL_DIR) >> $(LOG_FILE) 2>&1 ||:
	@echo "DONE"
	@echo "INFO: uninstalled $($PACKAGE_NAME)"
