#!/bin/bash

# Designed to work on a source tree patch on stdin, and produce a
# release tree patch on stdout.

# Substitutions performed are:-
# Patches for these files are redirected:-
#
# sesman/sesman.ini.in -> sesman/sesman.ini
# xrdp/xrdp.ini.in -> xrdp/xrdp.ini
#
# Within these patches only, the following substitutions are made:-
# @lib_extension@ -> so
# @sesmansysconfdir@ -> /etc/xrdp
#
declare leader1=a/
declare leader2=b/
declare inPatch=
declare ignoreNext=

while read line; do
    # Are we ignoring this one?
    if [[ $ignoreNext ]]; then
        ignoreNext=
        continue
    fi
    if [[ $line == ---* ]]; then
        #  Start of a patch
        set -- $line
        if [[ $2 == $leader1* ]]; then
            file=${2#$leader1}
            case "$file" in
                sesman/sesman.ini.in | xrdp/xrdp.ini.in)
                    # One of the files we're looking for
                    file=${file%.in}
                    # Output a modified patch header
                    echo "--- $leader1$file"
                    line="+++ $leader2$file"
                    ignoreNext=1 ; # So the next line in the input is lost
                    inPatch=1
                    ;;
                 *) inPatch=
             esac
         fi
    elif [[ $inPatch ]]; then
        line=${line//@lib_extension@/so}
        line=${line//@sesmansysconfdir@//etc/xrdp}
    fi
    echo "$line"
done

