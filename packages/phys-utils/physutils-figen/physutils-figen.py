#!/bin/sh
########10########20########30## DOCUMENTATION #50########60########70########80
#
#  OVERVIEW
#  ========
# 
#  A domain specific language designed for producing the figures needed for
#  Physics lab reports written in LaTeX. figen is written in Python 3, and
#  also depends on matlotlib for figure generation. figen is a streaming
#  language, in that it can safely be used as part of a pipeline, and will not
#  seek ahead or backwards in it's input.
#  
#  GRAMMER
#  =======
#  
#  figen is a simple markup language. It is comprised of lines. Each line
#  contains one directive then zero or more arguments. 
#  
#    DIRECTIVES
#    ----------
#    
#    plot [input file] [delimiter] [x-axis column] [y-axis column]
#    
#      Intended to plot columnar data. The input file should be a CSV-like
#      file, with the delimiter being the character which separates the
#      columns. X and Y axes of the graph are given by their zero-indexed
#      column number, with the leftmost column being the zeroth.
#      
#      All cell values in the input file are treated as floating point
#      numbers. Invalid cells (empty, strings, etc.) are implicitly ignored.
#  
########10########20########30##### LICENSE ####50########60########70########80
#  Copyright (c) 2016, Charles Daniels
#  All rights reserved.
# 
#  Redistribution and use in source and binary forms, with or without
#  modification, are permitted provided that the following conditions are met:
# 
#  1. Redistributions of source code must retain the above copyright notice,
#     this list of conditions and the following disclaimer.
#  
#  2. Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in the
#     documentation and/or other materials provided with the distribution.
# 
#  3. Neither the name of the copyright holder nor the names of its
#     contributors may be used to endorse or promote products derived from
#     this software without specific prior written permission.
# 
#  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
#  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
#  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
#  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
#  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
#  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
#  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
#  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
#  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
#  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
#  POSSIBILITY OF SUCH DAMAGE.
#  
########10########20########30########40########50########60########70########80
