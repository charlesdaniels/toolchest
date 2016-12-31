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
``acquire-toolchest-dir`` via ``$(acquire-toolchest-dirs export)``. See the
`relevant header <../bin/acquire-toolchest-dirs>`_ for more information.

Conventions for Python Scripts
==============================

The convention for accessing the toolchest installation in Python is
demonstrated in the ``python-libtest`` package. See 
`here <../packages/python-libtest/test-libs.py>`_