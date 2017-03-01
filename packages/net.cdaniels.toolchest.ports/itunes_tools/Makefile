NET_CDANIELS_TOOLCHEST_DIR=$(shell echo $$NET_CDANIELS_TOOLCHEST_DIR)
PACKAGE_NAME=$(shell echo $$PACKAGE_NAME)
PACKAGE_DIR=$(shell echo $$PACKAGE_PATH)
BIN_DIR=$(NET_CDANIELS_TOOLCHEST_DIR)/local/bin
LIB_DIR=$(NET_CDANIELS_TOOLCHEST_DIR)/local/lib/$(PACKAGE_NAME)
INSTALL_DIR=$(PACKAGE_DIR)/bin
UPSTREAM_URL=https://github.com/jacobvosmaer/itunes_tools
UNAME_S := $(shell uname -s)
TIMESTAMP=$(shell iso8601date)
LOG_DIR=$(NET_CDANIELS_TOOLCHEST_DIR)/local/log
LOG_FILE=$(LOG_DIR)/$(PACKAGE_NAME)-$(TIMESTAMP).install.log
RELEASE_PATH=$(INSTALL_DIR)/$(PACKAGE_NAME)/build/Release

install: preflight
	@echo "INFO: log file for installation is: $(LOG_FILE)"
	@printf "INFO: retreving sources for $(PACKAGE_NAME) from upstream... "
	@cd $(INSTALL_DIR) && git clone $(UPSTREAM_URL) > $(LOG_FILE) 2>&1
	@echo "DONE"
	@printf "INFO: compiling binaries... "
	@cd $(INSTALL_DIR)/$(PACKAGE_NAME) && xcodebuild -alltargets >> $(LOG_FILE) 2>&1
	@echo "DONE"
	@printf "INFO: linking package files... "
	@ln -s $(RELEASE_PATH)/build_itunes_playlists $(BIN_DIR)/build_itunes_playlists
	@ln -s $(RELEASE_PATH)/itunes_add_missing 		$(BIN_DIR)/itunes_add_missing
	@ln -s $(RELEASE_PATH)/itunes_selection			  $(BIN_DIR)/itunes_selection
	@ln -s $(RELEASE_PATH)/make_itunes_playlist   $(BIN_DIR)/make_itunes_playlist
	@echo "DONE"

preflight:
	@printf "INFO: preparing environment... "
	@rm -rf $(INSTALL_DIR) ||:
	@mkdir $(INSTALL_DIR)
	@-rm -rf $(LIB_DIR) ||:
	@mkdir $(LIB_DIR)
	@echo "DONE"

uninstall:
	@printf "INFO: unlinking $(PACKAGE_NAME) files... "
	rm $(BIN_DIR)/build_itunes_playlists ||:
	rm $(BIN_DIR)/itunes_add_missing ||:
	rm $(BIN_DIR)/itunes_selection ||:
	rm $(BIN_DIR)/make_itunes_playlist ||:
	@echo "DONE"
	@printf "INFO: cleaning install directory... "
	@rm -rf $(INSTALL_DIR)/* ||:
	@echo "DONE"
	@echo "INFO: uninstalled $($PACKAGE_NAME)"
