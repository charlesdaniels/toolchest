**********************
net.cdaniels.toolchest
**********************

**ATTENTION**: by using this software, you agree to abide by the license
provided in each software module. If a software module does not have a license
explicitly provided, it falls under the `project license <LICENSE>`_.

.. contents::

For the user's manual, click `here <doc/manual.rst>_`. 

For My Friends
==============

If you came here because I told you I had a useful script in this repo, and
you wanted to install it, here is what to do:

* clone the repo (``git clone https://bitbucket.org/charlesdaniels/toolchest``)

* install the toolchest (``cd toolchest && ./bin/toolchest install local``)

* the installer will give you some directories to add to your ``$PATH``, you
  should make sure to do this

* install the pakage you want (``toolchest package install packagename``)

Overview
========

`CHANGELOG <CHANGELOG>`_

`ROADMAP <ROADMAP>`_

This is a set of tools which I have developed for my personal use and
convenience. This repository make it easy to install these tools on various
systems.

Goals
-----

The key objective of this repository is to ensure that systems specific
artifacts (eg. compiled binaries) are fully separated from the platform-
independent source code. Before switching to this method, I kept everything in
~/bin and synced this via git. This works pretty well for shell scripts, but
anything compiled (eg. micro) does not play well with that approach, and even
scripts that have special dependencies could not be guaranteed to work without
manually validating that their dependencies.

Design
------

In this repository, we keep a set of core utilities (usually referred to as
coreutils, or uniquely net.cdaniels.toolchest.coreutils) in the bin/ folder.
This lives directly under the toolchest install directory. These utilities
include the toolchest management utility itself, as well as it's dependencies,
and various cross-platform scripts which are used commonly by packages.

Additionally, a set of core libraries is provided in the lib/ folder which is
also stored directly under the toolchest install directory. These contain very
commonly used tools which are not useful on their own. This includes the
reference package installer and uninstaller scripts, among other things.

Packages are kept in the packages/ directory. Packages install using either a
makefile or a set of scripts (install.sh and uninstall.sh). Package artifacts
are symlinked into local/lib or local/bin as appropriate (local/ is directly
under the toolchest installation directory). 

Packages may be managed using ``toolchest package``. 

~~~Package installations are stateless. Installing a package a second time will
not break anything (usually it will cause the installer to fail, uninstalling
the package). Uninstalling a package that does not exist will not break.~~~

Beginning with 0.0.5-ALPHA, dependency resolution among toolchest packages
will be supported as part of the toolchest management utility.

Packages are not to store any configuration files in local/bin or local/lib.
However, packages may use local/config for storing configuration if they need
it.


Rationale
---------

In many ways, this is re-inventing the wheel. There are plenty of excellent
package manager out there. However, I felt that this approach was useful
enough to warrent a new project, for a number of reasons:

* the toolchest (should) run on any POSIX system 
* the toolchest does not need to be run as root

  - system wide or ``$HOME`` installations are fully supported

* the toolchest has very few dependencies, just a POSIX shell and some common
  utilities



Style and Conventions
=====================

Documentation about specific packages and scripts is kept in the relevant
source files.

We use 80 character line width for all files, although this is not strict.
Some shell scripts need to exceed this here and there for long conditional
statements. Ideally < 1% of total lines of code exceed 80 characters.

Things which are used in 3 or more packages should probably be moved into
coreutils (lib or bin), unless they have many dependencies or require
compilation, in which case they should be moved into their own package. This
make re-use easier. 

Libraries that cannot be executed on their own (eg. that just contain function
declarations) should end in ``.lib`` and should not be marked executable.

Libraries that contain functions should not also executed anything when
sourced.

Gotchas
-------

There are a few gotchas that I have identified which can affect cross platform
compatibility.

* On most systems in sh, ``/foo/bar/somefile/..`` is a valid path that points
  to ``/foo/bar``. This does NOT work on FreeBSD 11's sh however. 

* The convention for copying directory structures recursively differs between
  various UNIXes. Rather than writing an ugly switch statement, ``( cd
  /path/to/src ; tar cf - . ) | ( cd /path/to/dest ; tar xf - )`` will do the
  same thing, albeit somewhat awkwardly. (`source
  <http://superuser.com/a/138604>`_)


Links to Module Documentation
=============================

* `toolchest management tool <bin/toolchest>`_
* `reference package installer <lib/generic-install.sh>`_
* `reference package uninstaller <lib/generic-uninstall.sh>`_
* `example with sh installer <packages/example>`_
* `example with make installer <packages/helloworld>`_
