#!/bin/sh

set -eu
export LC_ALL=C
export UNIX_STD=2003
export POSIXLY_CORRECT=1


err() {
  printf "${0##*/}: %s\n" "$1"
  exit 1
}
case $# in 0)
  echo "Usage: ${0##*/} name ..." 1>&2
  exit 1
esac

for a in "$@"; do
  # name accepted?
  case "$a" in */*|*[!0-9A-Za-z._-]*)
    err "$a: name not accepted"
  esac

  # Filename
  case "$a" in *.[0-9]) :;; *) a="$a.1";; esac

  # File exists?
  [ -e "$a" ] && err "$a: exists"

  # Util name
  util="${a%.[0-9]}"
  T="$( printf '%s\n' "$util" | tr a-z A-Z )"

  # Template
  cat > "$a" <<-__MDOC__
.Dd $( date +'%B %d, %Y' )
.Dt $T
.Os
.Sh NAME
.Nm $util
.Nd \" TODO
.Sh SYNOPSIS
.Nm
.\" TODO
.Sh DESCRIPTION
The
.Nm
\" TODO
	__MDOC__

  echo Created "$a"
done
