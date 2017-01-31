NET_CDANIELS_TOOLCHEST_DIR=$(shell echo $$NET_CDANIELS_TOOLCHEST_DIR)
NET_CDANIELS_LOCAL=$(NET_CDANIELS_TOOLCHEST_DIR)/local
NET_CDANIELS_LOCAL_LIB=$(NET_CDANIELS_LOCAL)/lib
INSTALL_DIR=$(NET_CDANIELS_LOCAL_LIB)/net.cdaniels.python
PACKAGE_NAME=net.cdaniels.python
PACKAGE_DIR=$(NET_CDANIELS_TOOLCHEST_DIR)/packages/$(PACKAGE_NAME)

install:
	-mkdir -p $(INSTALL_DIR)
	ln -s $(PACKAGE_DIR)/lib/loggingutils.py $(INSTALL_DIR)/loggingutils.py

uninstall:
	-rm $(INSTALL_DIR)/logingutils.py
	-rmdir $(INSTALL_DIR)
