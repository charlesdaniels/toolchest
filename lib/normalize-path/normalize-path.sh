########10########20########30## DOCUMENTATION #50########60########70########80
#
#  OVERVIEW
#  ========
#
#  Realpath implementation in pure sh. This implementation should only be used
#  on systems without readlink and BASH, and where realpath is not present.
#  
#  Note that this may produce "dirty" paths, such as /foo/bar/./, although
#  these will be correct, and should resolve correctly by things that parse
#  paths in a POSIX compliant way.
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
#  This script sourced from StackOverflow user Sildoreth
#  
#  It has been slightly modified to fit net.cdaniels.toolchest conventions
#  
#  Original URL: 
#
#  http://unix.stackexchange.com/a/204381
#
########10########20########30## CONFIGURATION #50########60########70########80


if [ $# -eq 0 ] || [ $# -gt 2 ]; then
  printf "Usage: $0 path [working-directory]\n" >&2
  exit 1
fi
cantGoUp=

path=$1
if [ $# -gt 1 ]; then
  cd "$2"
fi
cwd=`pwd -P` #Use -P option to account for directories that are actually symlinks

#Handle non-relative paths, which don't need resolution
if echo "$path" | grep '^/' > /dev/null ; then
  printf '%s\n' "$path"
  exit 0
fi

#Resolve for each occurrence of ".." at the beginning of the given path.
#For performance, don't worry about ".." in the middle of the path.
while true
do
  case "$path" in
    ..*)
      if [ "$cwd" = '/' ]; then
        printf 'Invalid relative path\n' >&2
        exit 1
      fi
      if [ "$path" = '..' ]; then
        path=
      else
        path=`echo "$path" | sed 's;^\.\./;;'`
      fi
      cwd=`dirname $cwd`
      ;;
    *)
      break
      ;;
  esac
done

cwd=`echo "$cwd" | sed 's;/$;;'`
if [ -z "$path" ]; then
  if [ -z "$cwd" ]; then
    cwd='/'
  fi
  printf '%s\n' "$cwd"
else
  printf '%s/%s\n' "$cwd" "$path"
fi