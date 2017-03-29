**********************
net.cdaniels.toolchest
**********************

**ATTENTION**: by using this software, you agree to abide by the license
provided in each software module. If a software module does not have a license
explicitly provided, it falls under the `project license <LICENSE>`_.

.. contents::


Overview
========

`CHANGELOG <CHANGELOG>`_

`ROADMAP <ROADMAP>`_

This is a collection of tools and utilities that I and other's have written. This
project is a combination of two parts. The first is the ``toolchest`` itself, a
simple package manager for installing, uninstalling, and managing tools. The
second component is a collection of *packages*, which are mostly scripts and 
small tools which are too small to warrant being standalone software packages. 

Additionally, there are a number of *ports*, which are software tools written by
others, and are useful in cases where one is using a system with no package
manager, or a package manager which is unavailable for some reason. Ports are
internally identical to packages and are managed and interacted with in the same
way.

The toolchest attempts to fulfill a few key goals, which are elaborated on in
greater detail later; in short, they are:

* portability - the toolchest should ideally run on any POSIX-ish system that
  supports Bourne shell or 100% compatible.

* independance - the toolchest should not require any dependencies not installed
  out of the box on a supported system

* self-contained - the toolchest does not require root access, and all files
  system operations happen inside a single prefix (and ``/tmp``); deleting the
  toolchest completely removes all components from the system

Note that individual packages do not necessarily follow all of the above, with
the exception of the last goal, which is rigorously observed in all packages
I have written. 

Quick Installation Guide
------------------------

1. ``cd ~``
2. ``git clone https://bitbucket.org/charlesdaniels/toolchest``
3. ``mv toolchest .net.cdaniels.toolchest``
4. ``cd .net.cdaniels.toolchest``
5. ``./bin/toolchest setup``
6. ``./bin/toolchest-genpath >> ~/.bashrc``
7. ``./bin/toolchest-genpath >> ~/.bash_profile``
8. ``./bin/toolchest-genpath >> ~/.profile``
   
You may need to open a new shell session before the toolchest tools appear in 
``$PATH``. 

For documentation on using the ``toolchest`` command, run ``toolchest-doc
toolchest``.

For more information, see the `User Manual <./doc/manual.rst>`_ .

Goals
-----

The original purpose of this project was to ensure that systems specific
artifacts (eg. compiled binaries) are kept fully separated from the platform-
independent source code. Before switching to this method, I kept everything in
~/bin and synced this via git. This works pretty well for shell scripts, but
anything compiled does not play well with that approach, and even scripts that
have special dependencies could not be guaranteed to work without manually
validating that their dependencies were present. This is still a primary concern
to the toolchest, although further goals have been added over time.

The toolchest, as noted in the overview, aims to be highly portable. While not
all packages can always be portable to all systems, the ``toolchest`` itself and
the core utilities that ship with it will run with only Bourne shell (usually sh
or BASH) and common UNIX utilities. A system which has a C compiler, a python 3
interpreter, and a Perl 5 interpreter will run almost all packages supplied in
the default install.

The toolchest aims to run without any dependencies on supported systems. It will
work correctly (although all packages will not) out of the box on a stock
install of Ubuntu 16 or macOS 10.12, as well as many other operating systems.
Full functionality can be attained with minimal dependencies which most
developers and system administrates will already have installed. Further, almost
all packages have been configured with dependency validation which occurs before
installation, to avoid situations where a package installs but is broken after
the fact.

Last, the toolchest aims to be fully self-contained. Everything, including
packages, lives under the installation directory. This means installing the
toolchest is as simple as copying the install folder somewhere convenient, and
installing is simply the act of deleting the installation folder. 

Design
------

**NOTE**: except as noted, relative paths are assumed to be relative to the
toolchest installation directory.

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

Beginning with 0.0.5-ALPHA, dependency resolution among toolchest packages
is be supported as part of the toolchest management utility.

As of the 1.X.X release series, packages are further organized into
*repositories*. See the `Packaging Guide <doc/packaging.rst>`_ for further
information.

Packages are not to store any configuration files in local/bin or local/lib.
However, packages may use local/config for storing configuration if they need
it.


Rationale
---------

In many ways, this project is re-inventing the wheel. There are plenty of
excellent package manager out there. However, I felt that this approach was
useful enough to warrant a new project, for a number of reasons:

* the toolchest (should) run on any POSIX system 
* the toolchest does not need to be run as root
* the toolchest has very few dependencies, just a POSIX shell and some common
  utilities
* the toolchest (as of 0.0.5) supports running from any location - this makes
  it suitable for using as a runtime.



Style and Conventions
=====================

Documentation about specific packages and scripts is kept in the relevant source
files. The motto for documentation in this project is *code is prose* - all
source code files should contain all of their documentation in-line. In some
cases, it is necessary to store overarching documentation that is not module
specific - this is kept in the `doc <./doc>`_ folder.

We use 80 character line width for all files, although this is not strict. Some
shell scripts need to exceed this here and there for long conditional
statements. Ideally < 1% of total lines of code exceed 80 characters. This makes
the source code convenient to work with in a variety of editors and on a variety
of screen sizes. Documentation files are also hard-wrapped to 80 characters for
the same reason, although neither reStructuredText nor Markdown require this.

Things which are used in 3 or more packages should probably be moved into
coreutils (lib or bin), unless they have many dependencies or require
compilation, in which case they should be moved into their own package. This
make re-use easier. 

Libraries that cannot be executed on their own (eg. that just contain function
declarations) should end in ``.lib`` and should not be marked executable. It has
recently come to my attention that some compilers also emit ``.lib`` files as a
form of binary object file - the ``.lib`` files used in the toolchest should not
be confused. All toolchest ``.lib`` files are shell scripts which can be
sourced. 

Libraries that contain functions should not executed anything when
sourced beyond said function declarations.

From the point of view of the rest of the toolchest, the coreutils libraries
and binaries should be considered non-mutable. Outside of toolchest updates,
they should not change in contents or functionality, and their behavior is
not configurable.

Gotchas
-------

There are a few gotchas that I have identified which can affect cross platform
compatibility. This information is mostly of interest to individual wishing to
develop toolchest packages.

* On most systems in sh, ``/foo/bar/somefile/..`` is a valid path that points
  to ``/foo/bar``. This does NOT work on FreeBSD 11's sh however. 

* The convention for copying directory structures recursively differs between
  various UNIXes. Rather than writing an ugly switch statement, ``( cd
  /path/to/src ; tar cf - . ) | ( cd /path/to/dest ; tar xf - )`` will do the
  same thing, albeit somewhat awkwardly. Note that this functionality is now a
  part of the coreutils and is named `mirror-directory <./bin/mirror-
  directory>`_ .(`source <http://superuser.com/a/138604>`_)


Further Documentation
=====================

* `acquiring the toolchest installation directory <doc/paths.rst>`_
* `user manual <doc/manual.rst>`_
* `packaging guide <doc/packaging.rst>`_
* `versioning scheme <doc/version.rst>`_
* `toolchest management tool <bin/toolchest>`_
* `system requirements & supported OSes <doc/support.rst>`_
* `reference package installer <lib/generic-install.sh>`_
* `reference package uninstaller <lib/generic-uninstall.sh>`_
* `example with sh installer <packages/example>`_
* `example with make installer <packages/helloworld>`_
