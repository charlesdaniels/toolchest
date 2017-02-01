NET_CDANIELS_TOOLCHEST_DIR=$(shell echo $$NET_CDANIELS_TOOLCHEST_DIR)
PACKAGE_NAME=$(shell echo $$PACKAGE_NAME)
PACKAGE_DIR=$(shell echo $$PACKAGE_PATH)
BIN_DIR=$(NET_CDANIELS_TOOLCHEST_DIR)/local/bin
LIB_DIR=$(NET_CDANIELS_TOOLCHEST_DIR)/local/lib/$(PACKAGE_NAME)
INSTALL_DIR=$(PACKAGE_DIR)/bin
UPSTREAM_URL=https://github.com/TinyCC/tinycc
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
	@cd $(INSTALL_DIR)/tinycc && ./configure --prefix="$(INSTALL_DIR)/tcc-install" >> $(LOG_FILE) 2>&1
	@cd $(INSTALL_DIR)/tinycc && make >> $(LOG_FILE) 2>&1
	@cd $(INSTALL_DIR)/tinycc && make install >> $(LOG_FILE) 2>&1
	@echo "DONE"
	@printf "INFO: linking package files... "
	@ln -s $(INSTALL_DIR)/tcc-install/bin/tcc           $(BIN_DIR)/tcc
	@ln -s $(INSTALL_DIR)/tcc-install/bin/tiny_libmaker $(BIN_DIR)/tiny_libmaker
	@ln -s $(INSTALL_DIR)/tcc-install/lib               $(LIB_DIR)/lib
	@ln -s $(INSTALL_DIR)/tcc-install/lib64             $(LIB_DIR)/lib64
	@ln -s $(INSTALL_DIR)/tcc-install/include           $(LIB_DIR)/include
	@ln -s $(INSTALL_DIR)/tcc-install/share             $(LIB_DIR)/share
	@echo "DONE"

preflight:
	@echo "INFO: performing preflight checks for $(PACKAGE_NAME):"
	@printf "\tgit... "
	@command -v > /dev/null ; if [ "$$?" -eq 0 ] ; then true ; else false ; fi
	@echo "OK"
	@echo "INFO: preflight check complete"
	@printf "INFO: preparing environment... "
	@# make sure the bin dir exists for us to install to
	@rm -rf $(INSTALL_DIR) ||:
	@mkdir $(INSTALL_DIR)
	@rm -rf $(INSTALL_DIR)/tcc-install ||:
	@mkdir $(INSTALL_DIR)/tcc-install
	@-rm -rf $(LIB_DIR) ||:
	@mkdir $(LIB_DIR)
	@echo "DONE"

uninstall:
	@printf "INFO: unlinking $(PACKAGE_NAME) files... "
	@rm $(BIN_DIR)/tcc ||:
	@rm $(BIN_DIR)/tiny_libmaker ||:
	@rm $(LIB_DIR)/lib  ||:
	@rm $(LIB_DIR)/lib64 ||:
	@rm $(LIB_DIR)/include  ||:
	@rm $(LIB_DIR)/share  ||:
	@echo "DONE"
	@printf "INFO: cleaning install directory... "
	@rm -rf $(INSTALL_DIR)/* ||:
	@echo "DONE"
	@echo "INFO: uninstalled $($PACKAGE_NAME)"
