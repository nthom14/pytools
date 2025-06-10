#!/bin/bash

run_update() {
    local proxy
    proxy=$1
    proxy_flags=""
    if [ ! -z "$1" ]; then
        proxy_flags="--proxy $proxy"
    fi
    # [0] Upgrade pip
    pip install --upgrade pip $proxy_flags
    # [1]: Get outdated packages via pip and dump the result to pip_outdated_packages.json
    pip $proxy_flags list --outdated --format json > pip_outdated_packages.json
    # [2]: Check the length of packages. If zero no need to update something. Otherwise, go to [3].
    OUTDATED_PACKAGES_LIST_LEN=`jq '. | . | length'  pip_outdated_packages.json`
    if [ "$OUTDATED_PACKAGES_LIST_LEN" -gt 0 ]; then
        # [3a]: Update outdated packages
        echo "Updating $OUTDATED_PACKAGES_LIST_LEN packages"
        pip $proxy_flags install -U `jq '. | .[] | .name'  pip_outdated_packages.json | sed s/\"//g`
    else
        # [3b]: No outdated packages found
        echo "No packages to update"
    fi
    # [4]: remove JSON file 
    rm -v -f pip_outdated_packages.json
}

while getopts "p:" opt; do
  case "$opt" in
    p) proxy="$OPTARG" ;;
    \?) echo "Usage: $0 [-p proxy]"; exit 1 ;;
  esac
done

run_update $proxy
