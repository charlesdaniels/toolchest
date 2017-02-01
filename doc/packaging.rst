**************************************
net.cdaniels.toolchest Packaging Guide
**************************************

.. contents::

net.cdaniels.toochest Package Format
====================================

Toolchest packages are simply directories which contain the following files:

* ``brief.txt`` (optional) - a short (~ 100 characters or less) description of
  the package, shown during ``package list``

* ``description.txt`` (optional) - a description of the package, shown during
  ``package description``. May be any length. 80 character line length is
  strongly encouraged.

* (``install.sh`` AND ``uninstall.sh``) OR ``Makefile`` (required) - package
  installer/uninstaller scripts. If desired, a Makefile may be used. If a
  Makefile is used, it should respond correctly to ``make install`` and ``make
  uninstall``.

* ``dep`` (optional) - a directory containing zero or more of the following
  files:

  - ``system`` - newline delimited list of commands which must appear in $PATH
    for the package to install

  - ``toolchest`` - newline delimited list of toolchest packages which must be
    installed to install this package. Will cause said packages to be
    installed if they are not already.

  - ``uname`` - newline delimited list of OS ``uname``s - the host OS must
    match one or more of them in order for the package to install.

The rest of the package folder may be structured in whatever way best suits
the package.

Best Practices & Conventions
============================

Packages may write to their own directories. This is encouraged for cases
where packages need to compile binaries - the resulting binaries should be
stored in the package's directory.

Although this behavior is not enforced by technical means, packages may not
write outside of their own directories except as noted in this document.
Packages may (and almost always should) create symbolic links to any binaries,
commands, or libraries in ``local/bin`` and ``local/lib`` as needed.
Additionally, packages are encouraged to create a directory for themselves in
``local/lib`` to avoid clutter (eg. ``local/lib/packagename``), although this
directory should only contain symbolic links. If desired, said directory may
be a symbolic link itself.

Packages may store logs of any format and in any structure within
``local/log``. Logs need not be symbolic links, but should usually be write-
only (ideally append-only).

Packages may store any configuration files in any structure within
``local/config``. Configuration files need not be symbolic links.

Packages may store backups of any variety, in any structure or format in
``local/backup``. Such files need not be symlinks.

Packages should not under any circumstances (during installation or
uninstallation) write to any location outside the toolchest installation. It
is consequentially absolutely unacceptable for a package to say, install
itself into ``/usr/local``. This is because uninstalling the toolchest should
be as simple as removing it's installation directory.

Packages are encouraged to make use of any generic or smei-generic libraries
for installation and de-installation in the coreutil library.

Package installation and uninstallation scripts may call into as many other
programs or scripts as needed. For example, even the generic installer script
from the coreutils library has support for calling into a preinstall script.

As of 0.0.5-ALPHA, these include:

* `generic-install.sh <../lib/generic-install.sh>`_
* `generic-uninstall.sh <../lib/generic-uninstall.sh>`_

Repositories
============

The term "repository" refers to a directory which contains zero or more
folders formatted as toolchest packages as described above.

The packages/ directory, starting with the 1.X.X release series, contains only
repositories - all packages are placed inside these repositories.

At time of writing, the following repositories come with the toolchest:

* net.cdaniels.toolchest.indev - packages which are in development
* net.cdaniels.toolchest.legacy - packages which are out of date and either
  don't install, or install but don't work. These packages are maintained for
  historical purpose, and are not supported in any way. Some may work, so may
  not. Use them at your peril.
* net.cdaniels.toolchest.pycoreutil - packages which would be part of the
  coreutils if they did not depend on python.
* net.cdaniels.toolchest.python - python libraries
* net.cdaniels.toolchest.testing - packages which test the toolchest, including
  example and demo packages
* net.cdaniels.toolchest.tools - assorted tools and utilities
* net.cdaniels.toolchest.ports - programs which were written by other people

You may install additional repositories by placing an appropriately structured
directory tree in the packages/ directory, and you may uninstall a repository
by moving it out of the packages/ directory. A standalone tool to do this will
likely be added at some point during the 1.X.X release series.

Caveats
-------

* repository names should not be substrings of other repository names
* package names must be unique across all repositories
* package names should not be substrings of other package names

Examples
========

Sample Makefile
---------------

::

  NET_CDANIELS_TOOLCHEST_DIR=$(shell echo $$NET_CDANIELS_TOOLCHEST_DIR)
  PACKAGE_NAME=tcc
  PACKAGE_DIR=$(NET_CDANIELS_TOOLCHEST_DIR)/packages/$(PACKAGE_NAME)
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
