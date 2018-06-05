#!/usr/bin/env bash
#
# Copyright (c) 2018 Microsoft Corp. All Rights Reserved.
#

current_userid=$(id -u)
if [ $current_userid -ne 0 ]; then
    echo "$(basename "$0") installation script requires superuser privileges to run"
    exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

mkdir -p /usr/lib/azcopy
if [ ! $? -eq 0 ]; then
    echo "Failed to create folder for azcopy under /usr/lib"
    exit 1
fi

rsync -av --exclude startup --exclude installation $DIR/azcopy/* /usr/lib/azcopy

cp -f $DIR/azcopy/startup /usr/bin/azcopy
chmod a+x /usr/lib/azcopy/azcopy
chmod a+x /usr/bin/azcopy

if [ -d /etc/bash_completion.d ]; then
    cp $DIR/azcopy/azcopy_autocomplete /etc/bash_completion.d/azcopy
elif [ -d /usr/share/bash-completion/completions ]; then
    cp $DIR/azcopy/azcopy_autocomplete /usr/share/bash-completion/completions/azcopy
fi

if [ -f /etc/bash.bashrc ]; then
    source /etc/bash.bashrc
fi

