NET_CDANIELS_TOOLCHEST_DIR=$(shell echo $$NET_CDANIELS_TOOLCHEST_DIR)
PACKAGE_NAME=helloworld
PACKAGE_DIR=$(NET_CDANIELS_TOOLCHEST_DIR)/packages/$(PACKAGE_NAME)
INSTALL_DIR=$(NET_CDANIELS_TOOLCHEST_DIR)/local/bin

install: preflight helloworld
	ln -s $(PACKAGE_DIR)/$(PACKAGE_NAME) $(INSTALL_DIR)/$(PACKAGE_NAME)

uninstall: clean
	rm $(INSTALL_DIR)/$(PACKAGE_NAME)

clean:
	-rm $(PACKAGE_NAME)
	-rm *.o

helloworld: helloworld.o
	gcc -o $(PACKAGE_NAME) helloworld.o

helloworld.o: helloworld.c helloworld.h
	gcc -c helloworld.c 

preflight: 
	# check that gcc is present on the system
	command -v gcc > /dev/null