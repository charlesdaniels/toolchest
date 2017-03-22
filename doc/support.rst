****************************************************
net.cdaniels.toolchest - Supported Operating Systems
****************************************************

Overview
========

The following operating systems are fully supported, and will not be broken by
stable releases: 

* Current Ubuntu LTS release 
* Current Debian Stable release
* Current macOS release (non-beta) 
* Current FreeBSD stable release 
  
The following operating systems are supported when convenient:

* OSX 10.5.8 
* OSX 10.4.11 
* OpenIndiana 5.11 

System Requirements
===================

The ``toolchest`` management tool requires the following: 

* POSIX sh, bourne shell, BASH, or substantially compatible sh 

  - MUST support the ``local`` keyword (see bug #5)

* ``printf``
* ``sed`` 

  - the ``toolchest`` management tool supports BSD and GNU sed, but many packages
    require GNU sed 

* ``cut``
* ``sort``
* ``uniq``
* BSD or GNU ``make``

  - some packages may require one or the other, but ``toolchest`` does not care

* ``mkdir``
* ``rm`` including ``-r`` and ``-f``

The following are recommended to get full functionality out of most packages:

* python 3.X (ideally named ``python3``)
* perl 5 (named ``perl``)
* BASH
* GNU sed
* gcc 