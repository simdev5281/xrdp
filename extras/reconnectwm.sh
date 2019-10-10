#!/bin/bash -l
# ****************************************************************************
# Simulator Engineering Bourne shell Module Source File. 
# ****************************************************************************
# Copyright 2019 NATS (En-route) plc, ('NERL').
# This document contains commercially confidential information and must not
# be disclosed to third parties or copied or reproduced in whole or in part
# without NERL's prior written consent. All changes to this document shall be
# authorised by NERL, including its issue, amendment and distribution. In the
# event that this document is superseded, or no longer required by a
# designated holder, that holder shall ensure its safe return to NATS.
# ****************************************************************************
# Module Header
# -------------
# Component       - Linux systems software
# Program or Unit - reconnectwm.sh
# ****************************************************************************
# Description Section
# -------------------
# Called when a user reconnects to an XRDP session
# ****************************************************************************

# This script is '-l' to primarily run the system login scripts. If the
# user's shell is other than bash, this will not be as useful as it
# could be.

# Has the user set an environment variable to log the reconnect
# (debugging only). This needs to be in .bash_profile or whatever.
if [[ $XRDP_RECONNECT_LOG ]]; then
    exec >>$XRDP_RECONNECT_LOG 2>&1
else
    exec >/dev/null 2>&1
fi

# Find the scripts directory
declare __dir__=%{_libexecdir}/xrdp/reconnect.d

for __s__ in "$__dir__"/*; do
    if [[ -r $__s__ && ${__s__##*.} == bash ]]; then
        # Just source this one
        echo "- Sourcing $__s__"
        . "$__s__"

    elif [[ -x "$__s__" ]]; then
        echo "- Executing $__s__"
        "$__s__"
    fi
done

# User got a script?
if [[ -x $HOME/xrdp_reconnectwm.sh ]]; then
    echo "- Executing $HOME/xrdp_reconnectwm.sh"
    "$HOME/xrdp_reconnectwm.sh"
fi

echo "- Done"

exit 0
