************************************
net.cdaniels.toolchest User's Manual
************************************

Current as of 1.0.2-RELEASE-2

.. contents:: 

Installation
============

Acquiring the Toolchest
-----------------------

You must first download a copy of the toolchest. If you are not a developer,
and do not wish to develop your own toolchest packages, you should simply
download the latest stable release and extract it somewhere convenient. 

If you are a developer, you may wish to download and install the toolchest via
git, in which case you can simply ``git clone`` this repository.

Either way, lets assume you have download and extracted an appropriate copy of
the toolchest, and that this resides in ``./toolchest/``. In either case, it
does not matter where you download or extract the toolchest - it will install
itself to an appropriate location shortly.

Installing the Toolchest
------------------------

As of 0.0.5, there is no special installation procedure for the toolchest.
Simply ``git clone`` the repo, or download a release tarball and extract it
anywhere. It is suggested, but not required, that you name the resulting
directory ``.net.cdaniels.toolchest``, and place it either in ``$HOME`` or
``/opt/`` (or anywhere convienient).

**NOTE**: the toolchest contains a number of symbolic links - make sure you
preserve them while copying or extracting it, or you may get unexpected
results. A tool is available for this purpose in ``bin/mirror-directory`` - it
can be used standalone before the toolchest is set up.

Call the top-level directory of the toolchest ``NET_CDANIELS_TOOLCHEST_DIR``,
such that it contains the folders ``bin``, ``doc``, ``lib``, and ``packages``

Now add the following directories to ``$PATH``

* ``$NET_CDANIELS_TOOLCHEST_DIR/bin``
* ``$NET_CDANIELS_TOOLCHEST_DIR/local/bin``
 
As of 1.0.2, `bin/toolchest-genpath` can be used to produce appropriate export
commands to add the toolchest's bin folders to your PATH. You can setup 
your PATH with the following commands:

1. ``./bin/toolchest-genpath >> ~/.bashrc``
2. ``./bin/toolchest-genpath >> ~/.bash_profile``
3. ``./bin/toolchest-genpath >> ~/.profile``

**NOTE**: These commands assume your CWD is ``NET_CDANIELS_TOOLCHEST_DIR``. 

Uninstalling the Toolchest
--------------------------

Simply delete ``$NET_CDANIELS_TOOLCHEST_DIR``. By design, no package should
write outside of this directory, so simply removing it and taking the relevant
directories out of ``$PATH`` will fully remove the toolchest from your system.

Managing Packages
=================

Packages may be managed using the toolchest management utility. For full
documentation, please review the ``bin/toolchest`` (relative to installation
directory) - the documentation for the management utility is included in it's
header.

For convenience, some key functions are also documented here. 

To get a list of available package, run ``toolchest package list``. Package
names are listed on the left, with short descriptions on the right.

To read the full package description, use ``toolchest package description
packagename``, replacing "packagenamne" with the name of the package you would
like to read the description for.

To install a package, use ``toolchest package install packagename``, likewise,
to uninstall a package you can use ``toolchest package uninstall
packagename``.

Note that as of 0.0.5-ALPHA, the toolchest tracks package installation status.
That is, if you have installed a package already, you cannot install it a
second time. To view a list of installed packages, use ``toolchest package
list-installed``. To view the installation state of a package, use ``toolchest
package status packagename``. 

The package state is not intended to be mutable by end users. Developers and
administrators who have a valid reason to forcibly change the package
installation state should review the header of the ``bin/toolchest`` file,
paying specific attention to the ``internal`` commands documented there.

For the convenience of those viewing this file in a web interface, `here
<../bin/toolchest>`_ is a link to the relevant file directly.

Updating the Toolchest Installation
===================================

Those who have installed toolchest via ``git`` need only use ``git pull`` to
update.

Those who installed from a binary archive, outside of git, should copy the
``bin/``, ``lib/``, and ``packages/`` folders from the updated archive over
top of the relevant folders in their installation directory. This process is
not currently automated, and no such automation is planned (as of
0.0.5-ALPHA).

Note that users are encouraged to run ``toolchest refresh`` after updating by
either method.

Troubleshooting
===============

``toolchest refresh``
---------------------

In some cases, often after an update, users may find it helpful to use
``toolchest refresh``. This command first backs up any settings in
``local/config``, including the list of installed packages. Next, the entire
``local/`` directory is deleted from the toolchest installation. Finally, the
backup copy of the ``config`` directory is copied back into the now cleaned
``local/`` folder. Any installed packages are then re-installed "fresh".

This command can be very useful in cases where the state of ``local/`` becomes
stale, or otherwise out of sync with the state of the packages tree or the
toolchest version. 

This command is also very useful for development purposes, especially when
combined with the ``toolchest internal package`` command set.