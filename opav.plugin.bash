#!/bin/bash

# Shellcheck doesn't support following the variable-path includes we use
# in this file, so we ignore that check for sanity.
# shellcheck disable=1090

PLUGIN_DIR="${BASH_SOURCE%/*}";

for func in "$PLUGIN_DIR"/funcs/*; do
    source "$func";
done;

source "$PLUGIN_DIR/vars.sh";
source "$PLUGIN_DIR/aliases.sh";
