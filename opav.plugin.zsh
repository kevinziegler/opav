SOURCE_PATH="${0:h}"

fpath+="$SOURCE_PATH/funcs"

source "$SOURCE_PATH/vars.sh"
source "$SOURCE_PATH/aliases.sh"

function opav-init() {
    for func in "$SOURCE_PATH"/funcs/*; do
        autoload -Uz $func
    done
}

opav-init
