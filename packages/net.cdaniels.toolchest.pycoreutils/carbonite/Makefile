NET_CDANIELS_TOOLCHEST_DIR=$(shell echo $$NET_CDANIELS_TOOLCHEST_DIR)
PACKAGE_NAME=$(shell echo $$PACKAGE_NAME)
PACKAGE_DIR=$(shell echo $$PACKAGE_PATH)
BIN_DIR=$(NET_CDANIELS_TOOLCHEST_DIR)/local/bin
LIB_DIR=$(NET_CDANIELS_TOOLCHEST_DIR)/local/lib/$(PACKAGE_NAME)

install: preflight
	@printf "INFO: installing carbonite... "
	@mkdir $(LIB_DIR) ||:
	@ln -s $(PACKAGE_DIR)/lib/carbonite.py $(LIB_DIR)/carbonite.py
	@ln -s $(PACKAGE_DIR)/lib/extract-execute.lib $(LIB_DIR)/extract-execute.lib
	@ln -s $(PACKAGE_DIR)/bin/carbonite $(BIN_DIR)/carbonite
	@echo "DONE"

preflight:

uninstall:
	@printf "INFO: uninstalling carbonite... "
	@rm $(LIB_DIR)/carbonite.py ||:
	@rm $(LIB_DIR)/extract-execute.lib ||:
	@rm $(BIN_DIR)/carbonite ||:
	@rmdir $(LIB_DIR) ||:
	@echo "DONE"
