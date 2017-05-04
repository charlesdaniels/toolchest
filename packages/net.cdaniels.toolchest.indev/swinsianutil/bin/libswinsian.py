########10########20########30## DOCUMENTATION #50########60########70########80
#
# OVERVIEW
# ========
#
# This library provides tools for interacting with Swinsian (a macOS music
# player).
#  
########10########20########30##### LICENSE ####50########60########70########80
# Copyright (c) 2017, Charles Daniels
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without 
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, 
# this list of conditions and the following disclaimer.
# 
# 2. Redistributions in binary form must reproduce the above copyright notice, 
# this list of conditions and the following disclaimer in the documentation 
# and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its 
# contributors may be used to endorse or promote products derived from this 
# software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE 
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
# POSSIBILITY OF SUCH DAMAGE.
########10########20########30########40########50########60########70########80

import sqlite3
import os

class Swinsian:
    """Swinsian
    
    This class is the top-level representation of "Swinsian". In most cases,
    this will wind up being a singleton for practical, rather than technical
    reasons. The most important task of this class is loading the Swinsian 
    database from disk. 

    Swinsian.tracks is a hashtable where the keys are track names, and the
    values are the paths to the pertinent file on disk. 
    
    Swinsian.playlists is a hashtable of lists, where keys are playlists names,
    and list elements are track names, such that each list contains the names
    of each track in the named playlist. 
    """

    tracks = None
    playlists = None
    defaultDatabaseFile = None

    def __init__(this):
        this.defaultDatabaseFile = \
            os.path.expanduser("~/Library/Application Support/Swinsian/Library.sqlite")
        this.tracks = {}
        this.playlists = {}


    def load(this, dbfile=defaultDatabaseFile):
        """load
        
        Load a Swinsian database from disk into this object.

        :param this:
        :param dbfile: path to Swinsian database (as a string)
        :throws FileNotFoundError: if dbfile does not exist
        """

        if not os.path.exists(dbfile):
            raise FileNotFoundError("dbfile {} does not exist".format(dbfile))

