************************************
net.cdaniels.toolchest User's Manual
************************************

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

Updating the Toolchest Installation
===================================

Troubleshooting
===============