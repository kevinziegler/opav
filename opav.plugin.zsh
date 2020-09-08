SOURCE_PATH="${0:h}"

fpath+="$SOURCE_PATH/funcs"

for func in "$SOURCE_PATH"/funcs/*; do
    autoload -Uz $func
done

source "$SOURCE_PATH/vars.sh"
source "$SOURCE_PATH/aliases.sh"
