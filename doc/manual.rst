************************************
net.cdaniels.toolchest User's Manual
************************************

Current as of 0.0.5-ALPHA 

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

Now, ``cd ./toolchest``, or otherwise change your working directory to the
directory you just extracted to. Next run ``bin/toolchest install``. Follow
the resulting prompts. Note that if you try to perform a system installation
without being root, unexpected results may occur.

Once the installation is complete, you will see a message with some
directories you will need to add to your ``$PATH``. You should do so in a
manner appropriate for your shell.

System vs Local Installations
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

System installations of the toolchest are intended to be used by system
administrators and the like in cases where all users on the relevant system
need to have access to the toolchest. Note that non-root users will not be
able to install packages.

Local installations place the toolchest installation in the user's home
folder, and are intended for cases where a single user, possibly without root
access, wishes to have toolchest access on a particular system.

Cases where local and system installations of the toolchest exist on the same
system are not well tested. If you wish to have both, you should make sure
that user(s) with local installations do not also have the system installation
in their ``$PATH``, or unexpected results may occur. 

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