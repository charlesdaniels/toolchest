*********************************
Acquiring the Toolchest Directory
*********************************

.. contents::

Overview
========

In many cases, it is necessary for toolchest scripts and packages to determine
the location of the toolchest installation, for example in order to locate
libraries or configuration files.

There is one supported method to determine the toolchest installation location
- via the ``acquire-toolchest-dirs`` coreutils script. Beginning with
  0.0.5-release, determining the toolchest installation directory via
  ``toolchest dir`` or environment variables is considered unsupported and is
  deprecated. 

Conventions for ``sh`` Scripts
==============================

``sh`` and compatible scripts (eg. ksh, bash, zsh, xonsh (?)) can invoke
``acquire-toolchest-dirs`` via ``$(acquire-toolchest-dirs)``. See the
`relevant header <../bin/acquire-toolchest-dirs>`_ for more information.

Conventions for Python Scripts
==============================

**TODO**

By 0.0.5-release, Python bindings for acquire-toolchest-dirs need to be
written. Possibly by having an alternate version or switch for ``acquire-
toolchest-dirs`` which emits Python code, which can then be ``eval()`` -ed.