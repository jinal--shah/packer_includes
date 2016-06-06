#!/bin/bash
# after_puppet.sh
#
# Boostrap script that runs all other scripts within the packer scripts dir
# that fit a pattern.
#
BIN_DIR=/tmp/scripts/after_puppet
PATH=$PATH:$BIN_DIR
SCRIPTS=$(ls -1 $BIN_DIR/[0-9][0-9][0-9][0-9][0-9]-* 2>/dev/null)
for this_script in $SCRIPTS; do
    if [[ ! -x $this_script ]]; then
        chmod a+x $this_script
    fi
    echo "$0 INFO: .... executing $this_script"
    env $this_script || exit 1
done

rm -rf /tmp/scripts/after_puppet || true
