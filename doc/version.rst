********************************************************
net.cdaniels.toolchest Versions & Versioning Information
********************************************************

.. contents::

Versioning Scheme
=================

Beginning with the (at time of writing) upcoming 0.0.5 release, the following
version scheme is used:

X.Y.Z 

X is the major version. It is incremented when breaking API changes are made.
For example, backwards incompatible changes to net.cdaniels.coreutils, or to
the toolchest management utility.

Y is the minor version. It is incremented when backwards-compatible feature
additions are added to net.cdaniels.coreutil or to the toolchest management
utility. It may also be incremented when new packages are added, or when
breaking changes to packages are made.

Z is the revision. It is incremented for bug-fixes, code cleanups, and
documentation changes which do not add or remove features or otherwise affect
backwards compatibility.

Versions may have an optional suffix, i.e. X.Y.Z-suffix. The following
suffixes are valid:

* git - versions of the software kept in git only. These are not official
  releases, and may be unstable or in development.

* rcX - release candidate X, or the Xth release candidate for a particular
  version. May still be unstable or in development. 

* release - stable release of the toolchest

All changes are recorded along with the contributor, date of change, and
relevant version in the CHANGELOG.

Consequentially:

* all releases with the same revision should be functionally identical
 
* releases with a higher revision number should be more stable than releases
  with a lower revision number

* releases with the same minor version will have fully compatible versions of
  the toolchest managment utility and coreutils

* releases with the a higher minor version should be more stable than releases
  with a lower minor version

* releases with a higher minor version number may contain new toolchest or
  coreutils functionality

* releases with differing minor versions may have different, or incompatible
  packages

* releases with differing major version numbers have no guarantee of
  compatibility of any kind, and may make breaking changes to any part of the
  toolchest

Releases to Date (current 2016-12-27)
=====================================

+-------------+-----------+----------------+
| Version     | Stability | Status         |
+=============+===========+================+
| 0.0.3-ALPHA | alpha     | released       |
+-------------+-----------+----------------+
| 0.0.4-ALPHA | alpha     | released       |
+-------------+-----------+----------------+
| 0.0.5       | alpha     | in-development |
+-------------+-----------+----------------+