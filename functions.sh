#!/bin/bash

# Preview helper for 1Password items in fzf
function opav-preview-op-item() {
    local op_item;
    local op_vault;
    local op_item_uuid=$2;

    op_item=$(op get item "$op_item_uuid");
    op_vault=$(jq -r '.vaultUuid' <<< "$op_item" | op get vault - | jq '.name')

    echo "[Item] %F{cyan}$1";
    echo "[Vault] %F${op_vault:-UNKNOWN}";
}

# Select the 1Password item to use for generating MFA codes
function opav-select-op-aws-item() {
    mkdir -p "$(dirname "$OPAV_CONFIG")";

    # Steps:
    # 1. (jq)          Extract Title/UUID from 1Password as a CSV
    # 2. (sed)         Strip out quotes (for display purposes)
    # 3. (echo && cat) Prepend a header
    # 4. (column)      Tabulate items for display in FZF
    # 5. (fzf)         Select a 1Password item
    # 6. (awk)         Extract the UUID of the selected item
    # 7. (jq)          write the UUID to the opav config
    op list items \
        | jq -r '.[] | [.overview.title, .uuid] | @csv' \
        | sed 's/"//g' \
        | (echo "TITLE,UUID" && cat) \
        | column -t -s, \
        | fzf \
            --header "Select the 1Password item for your AWS account" \
            --header-lines 1 \
            -1 \
            --preview-window=down:2 \
            --preview='opav-preview-op-item {}' \
        | awk '{print $NF}' \
        | jq -R '{ "op_aws_item": . }' > "$OPAV_CONFIG";
}

# Ensure the user has a 1Password session in their current
# shell.  Attempt to restart it if not.
function opav-ensure-session() {
    until op get account &>/dev/null; do
        eval "$(op signin my)";
    done
}

# Get the saved UUID of the 1Password AWS Item
function opav-get-aws-item-uuid() {
    jq -re '.op_aws_item' "$OPAV_CONFIG" 2>/dev/null;
    return $?;
}

# Get the MFA token for a user to sign into AWS
function opav-mfa-token() {
    until op get totp "$(opav-get-aws-item-uuid)" 2>/dev/null; do
        print "Could not get MFA token.  Running setup..." >&2
        sleep 2
        opav-select-op-aws-item;
    done
}

# Run a command in aws-vault without worrying about MFA args
function opav-helper() {
    local mfa_token='';
    local command=$1;
    shift;

    # Generate an MFA token and argument if the given command
    # can accept it
    [[ "$command" =~ ^(login|exec)$ ]] &&
        opav-ensure-session &&
        mfa_token=$(opav-mfa-token);

    aws-vault "$command" ${mfa_token:+--mfa-token="$mfa_token"} "$@";
}

# Select a profile for use with aws-vault
function aws-vault-profile-helper() {
    aws-vault list \
        | fzf --header-lines 2 --header "Select an AWS Profile" \
        | cut -d' ' -f1
}
