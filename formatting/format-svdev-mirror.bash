#!/usr/bin/env bash
function helptext {
    echo 'Usage: format-svdev-mirror.bash device0 device1 [device2 ...]'
    echo
    echo 'Please pass as arguments all the block devices you wish to include in the special metadata / small files vdev.'
    echo 'The provided block devices will be made into ZFS mirrors of each other.'
    echo
    echo 'You can configure this script by editing `env.sh`.'
    echo
    echo 'Warning: This script does not check validity. Make sure your block devices exist and are the same size.'
}

## Validate parameters
if [[ $# -lt 2 ]]; then
    helptext >&2
    exit 1
fi

## Define variables
ENV_FILE='./env.sh'; if [[ -f "$ENV_FILE" ]]; then source ./env.sh; else echo "ERROR: Missing '$ENV_FILE'."; exit -1; fi
ASHIFT=$(./helpers/calculate-powers-of-two.bash $ENV_HDD_SECTOR_SIZE)

## Format as SVDEV
set -e
zpool add \
    -o ashift="$ASHIFT" \
    -O vdev_zaps_v2=on \
    "$ENV_POOL_NAME" \
    special \
    mirror "$@"
exit $?
