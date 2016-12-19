**************************************
The net.cdaniels.carbonite File Format
**************************************

**CARBONITE VERSION**: 0.0.1

A self-extracting carbonite file contains two components. The first component,
which is not detailed here, is a shell script which parses the second -
extracting and executing it as desired by the packager.

The second component of such a file is referred to as the carbonite file (as
it can be generated separately and appended to the extraction script at a
later time).

OVERVIEW
========

The purpose of carbonate is to provide an easy means by which to distribute
scripts which have dependencies on (potentially many) other scripts as a
monolithic binary.

Carbonite provides a self-extracting binary, which extracts the payload
script(s) to a temporary location, passes any arguments (``$@``) to them, then
cleans up the scripts from the temporary location afterwards. This means a
carbonite file may contain many complex interlocking scripts, but be executed
as a standalone binary.

Carbonite should not be used for performance-critical applications, as each
execution of the resulting binary will produce a fair amount of IO to
``/tmp``, plus the CPU overhead of decompressing and checksumming the payload.

COMPONENTS
==========

HEADER
------

A valid carbonite file begins with the header::
  
  CARBONITE DATA BEGIN

FOOTER
------

A valid carbonite file ends with the footer::
  
  CARBONITE DATA BEGIN

MANIFEST
--------

A valid carbonite file contains a manifest. The manifest contains metadata
about the carbonite file and it's contents. The manifest begins with a set of
key value pairs, specified as ``KEY=VALUE``, with a newline after each pair,
and no spaces around the ``=``. 

The manifest contains the following keys:

+--------------------+----------------------------------------------------------------------------------------------------+
| Key                | Purpose                                                                                            |
+====================+====================================================================================================+
| CARBONITE_VERSION  | Carbonite release used to build this file                                                          |
+--------------------+----------------------------------------------------------------------------------------------------+
| TOOLCHEST_VERSION  | if carbonite is part of a net.cdaniels.toolchest, the toolchest version (otherwise ``standalone``) |
+--------------------+----------------------------------------------------------------------------------------------------+
| CHECKSUM_FORMAT    | the checksum format, either ``md5`` or ``shasum``                                                  |
+--------------------+----------------------------------------------------------------------------------------------------+
| COMPRESSION_FORMAT | the compression applied to each payload file (``gz``, ``xz``, or ``none``)                         |
+--------------------+----------------------------------------------------------------------------------------------------+
| PALYLOAD_FILE      | path relative to payload root of the file to be executed as the payload                            |
+--------------------+----------------------------------------------------------------------------------------------------+

Next, the manifest contains a list of files, specified relative to payload
root, associated with a checksum in the specified format.

The file list begins with the string ``CARBONITE FILE LIST BEGIN`` and 
ends with the the string ``CARBONITE FILE LIST END``. 

The key value pairs begin with ``CARBONITE PROPERTIES LIST BEGIN`` and end
with the string ``CARBONITE PROPERTIES LIST END``

PAYLOAD
-------

A carbonite file contains one or more files as a payload. These files are
frozen using ``tar``, and the resulting tarball is base64 encoded, and stored
in the carbonate file. The payload begins with the string ``CARBONITE PAYLOAD
BEGIN``, and ends with the string ``CARBONITE PAYLOAD END``. 

The tarball may be compressed according to ``COMPRESSION_FORMAT``. All files
are checksummed individually before being tar-ed or compressed.