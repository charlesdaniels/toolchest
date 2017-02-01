NET_CDANIELS_TOOLCHEST_DIR=$(shell echo $$NET_CDANIELS_TOOLCHEST_DIR)
PACKAGE_NAME=$(shell echo $$PACKAGE_NAME)
PACKAGE_DIR=$(shell echo $$PACKAGE_PATH)
BIN_DIR=$(NET_CDANIELS_TOOLCHEST_DIR)/local/bin
LIB_DIR=$(NET_CDANIELS_TOOLCHEST_DIR)/local/lib/$(PACKAGE_NAME)
INSTALL_DIR=$(PACKAGE_DIR)/bin
UPSTREAM_URL=https://yt-dl.org/downloads/latest/youtube-dl
UNAME_S := $(shell uname -s)
TIMESTAMP=$(shell iso8601date)
LOG_DIR=$(NET_CDANIELS_TOOLCHEST_DIR)/local/log
LOG_FILE=$(LOG_DIR)/$(PACKAGE_NAME)-$(TIMESTAMP).install.log

install: preflight
	@printf "INFO: fetching $(PACKAGE_NAME) from upstream... "
	@#NOTE: use of -k is insecure, as it disables the SSL check for the download
	@curl -k -L $(UPSTREAM_URL) -o $(INSTALL_DIR)/youtube-dl > $(LOG_FILE) 2>&1
	@chmod +x $(INSTALL_DIR)/youtube-dl
	@echo "DONE"
	@printf "INFO: linking package files... "
	@ln -s $(INSTALL_DIR)/youtube-dl $(BIN_DIR)/youtube-dl
	@echo "DONE"

uninstall:
	@printf "INFO: unlinking package files... "
	@rm $(BIN_DIR)/youtube-dl > /dev/null  2>&1 ||:
	@echo "DONE"
	@printf "INFO: removing package libraries... "
	@rm -rf $(LIB_DIR) > /dev/null  2>&1 ||:
	@echo "DONE"
	@printf "INFO: removing installation files... "
	@rm -rf $(INSTALL_DIR) > /dev/null  2>&1 ||:
	@echo "DONE"

preflight:
	@# make sure that youtube-dl is not already installed
	@printf "INFO: checking if youtube-dl is already installed... "
	@# gives a nonzero exit code if youtube-dl in $PATH
	@command -v youtube-dl > /dev/null ; if [ "$$?" -eq 0 ] ; then false ; else true ; fi
	@echo "OK"
	@printf "INFO: creating installation directories... "
	@mkdir $(INSTALL_DIR) ||:
	@mkdir $(LIB_DIR) ||:
	@echo "DONE"
