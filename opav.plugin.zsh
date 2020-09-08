SOURCE_PATH="${0:h}"

fpath+="$SOURCE_PATH/funcs"
autoload -Uz $SOURCE_PATH/funcs/*(.:t)

source "$SOURCE_PATH/vars.sh"
source "$SOURCE_PATH/aliases.sh"

