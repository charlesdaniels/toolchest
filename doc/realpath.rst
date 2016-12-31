********************************************
The Joy of Cross-Platform Path Normalization
********************************************

.. contents::

What is Path Normalization
==========================

Sometimes called path canonicalization, path normalization refers to taking a
relative path such as ``~/``, or ``./``, and converting it to an absolute or
"full" path, such as ``/foo/bar``. It can sometimes also involve resolving and
removing symbolic links - for example, in a case where ``./`` is ``/foo/bar``,
which is a symbolic link to ``/foo/baz``, obtaining the latter from ``./``.

We only concern ourselves with the former case, as nothing in the toolchest
coreutils depend on symbolic link resolution/removal - scripts or tools which
need this should use ``readlink``.

How is Path Normalization Used in net.cdaniels.toolchest ?
==========================================================

Path normalization is used by ``acquire-toolchest-dirs`` and ``toolchest``.
Significantly, the former assumes that it exists in ``$PATH``, and that it
exists in a toolchest installation. It thus resolves the toolchest
installation directory relative to ``$0/..``, although this notation is not
used in the script for compatibility reason (BSD sh cannot handle it).

When and Why ``realpath`` Won't Suffice
=======================================

Those familiar with UNIX operating systems may have already realized that
``realpath`` is an obvious solution here. It tends to work reliably, and is
available on many systems. However, there are a number of caveats with the
``realpath`` command that make it unsuitable for use in the toolkit

* there are multiple implementations; while GNU coreutils does provide one, it
  is not installed out of the box on many systems (including macOS/OSX) an (to
  my knowledge) Ubuntu.

* a comparable command, ``readlink`` is available on many systems also, mostly
  BSD-like systems, however there are also many implementations of
  ``readlink``, sometimes with inconsistent behavior.

These two points violate several core goals of the toolchest, namely that the
management utility and coreutils should run on a minimal POSIX system without
root access (eg. we may not call into the package manager to install realpath). 

Further, ``realpath`` and ``readlink`` are not part of the POSIX specification
(to my knowledge), and may not even be available on all systems (the
availability of realpath on say, Solaris or AIX is questionable).

The Solution
============

The solution I have selected for net.cdaniels.toolchest is ``normalize-path``.
This is a simple command which takes one argument - a path, and returns an
absolute/normalized version of the same path. This is roughly equivalent to
the normal behavior of ``realpath`` with no options.

normalize-path first checks to see if realpath is available on the current
system - if so, it is called directly and the script exits. Next, if the
script can detect a valid toolchest installation, it will call into the
coreutils library for one of three implementations of this functionality I
have written and found. If BASH or zsh, AND readlink are present, ``normalize-
path.bash`` is used - this was copied from the GitHub page of Mr. David
Raistrick and slightly modified to execute as a script, rather than a
function. Next, if python is available, my own implementation ``normalize-
path.py`` is used - which is backed by Python's ``os.path.abspath()``. If
python is not available, a pure ``sh`` implementation from the StackOverflow
user Sildoreth is used. Last, if a toolchest installation is not present, but
``readlink`` is, it is used.

Of course, this approach is not perfect - it does mean maintaining multiple
different implementations of the same functionality in multiple languages.
However, it has the benefit of providing at least adequate functionality on
practically any POSIX system. It also permits me to remove the toolchest's
longstanding dependency on ``realpath``.