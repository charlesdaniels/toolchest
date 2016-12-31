########10########20########30## DOCUMENTATION #50########60########70########80
#
#  OVERVIEW
#  ========
#
#  Realpath implementation in BASH (NOT sh) by David Raistrick. Depends on
#  BASH and readlink. For systems without realpath, but with bash and
#  readlink, this is the preferred implementation.
#  
#  This appears to also work with zsh. 
#  
#  USAGE
#  =====
#  
#  $1 . . . path to normalize
#  
#  RETURNS
#  =======
#  
#  Outputs the normalized path to stdout. 
#
########10########20########30##### LICENSE ####50########60########70########80
#
#  This script sourced from David Raistrick's GitHub page on 2016-12-30
#  
#  It has been slightly modified to fit net.cdaniels.toolchest conventions. 
#  
#  All credit to David Raistrick
#  
#  Original URL: 
#
#  https://github.com/keen99/shell-functions/tree/master/resolve_path
#
########10########20########30## CONFIGURATION #50########60########70########80



#I'm bash only, please!
# usage:  resolve_path <a file or directory> 
# follows symlinks and relative paths, exits a full real path
#
owd="$PWD"
#echo "$FUNCNAME for $1" >&2
opath="$1"
npath=""
obase=$(basename "$opath")
odir=$(dirname "$opath")
if [[ -L "$opath" ]]
then
#it's a link.
#file or directory, we want to cd into it's dir
  cd $odir
#then extract where the link points.
  npath=$(readlink "$obase")
  #have to -L BEFORE we -f, because -f includes -L :(
  if [[ -L $npath ]]
   then
  #the link points to another symlink, so go follow that.
    resolve_path "$npath"
    #and finish out early, we're done.
    exit $?
    #done
  elif [[ -f $npath ]]
  #the link points to a file.
   then
    #get the dir for the new file
    nbase=$(basename $npath)
    npath=$(dirname $npath)
    cd "$npath"
    ndir=$(pwd -P)
    retval=0
    #done
  elif [[ -d $npath ]]
   then
  #the link points to a directory.
    cd "$npath"
    ndir=$(pwd -P)
    retval=0
    #done
  else
    echo "$FUNCNAME: ERROR: unknown condition inside link!!" >&2
    echo "opath [[ $opath ]]" >&2
    echo "npath [[ $npath ]]" >&2
    exit 1
  fi
else
  if ! [[ -e "$opath" ]]
   then
    echo "$FUNCNAME: $opath: No such file or directory" >&2
    exit 1
    #and break early
  elif [[ -d "$opath" ]]
   then 
    cd "$opath"
    ndir=$(pwd -P)
    retval=0
    #done
  elif [[ -f "$opath" ]]
   then
    cd $odir
    ndir=$(pwd -P)
    nbase=$(basename "$opath")
    retval=0
    #done
  else
    echo "$FUNCNAME: ERROR: unknown condition outside link!!" >&2
    echo "opath [[ $opath ]]" >&2
    exit 1
  fi
fi
#now assemble our output
echo -n "$ndir"
if [[ "x${nbase:=}" != "x" ]]
 then
  echo "/$nbase"
else 
  echo
fi
#now exit to where we were
cd "$owd"
exit $retval