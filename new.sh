if [[ $OSTYPE == 'darwin'* ]]; then
  FIND_COMMAND=gfind
else
  FIND_COMMAND=find
fi

get_script_dir () {
     SOURCE="${BASH_SOURCE[0]}"
     # While $SOURCE is a symlink, resolve it
     while [ -h "$SOURCE" ]; do
          DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
          SOURCE="$( readlink "$SOURCE" )"
          # If $SOURCE was a relative symlink (so no "/" as prefix, need to resolve it relative to the symlink base directory
          [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
     done
     DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
     echo "$DIR"
}

get_target_dir () {
    echo "$(get_script_dir)" | sed -e "s/.*\///"
    # $FIND_COMMAND . -maxdepth 1 -type d -printf "%f\n" | grep -E -v "templates|arch|\." | head -n 1
}

get_valid_choices () {
    $FIND_COMMAND "$(get_script_dir)/templates" -maxdepth 1 -type d -not -name "templates"  -printf "%f\n" | tr  '\r\n|\n\r|\n|\r' ' '
}

isIn() {
    for item in $2
    do
        if [ "$1" == "$item" ]; then
            echo 1
            exit
        fi
    done
    echo 0
}

usage () {
    echo "Usage: $0 [template_name] [new_name]"
}

if [[ ! -d $(get_target_dir) ]]
then
    echo "Creating ./$(get_target_dir)"
    mkdir -p $(get_target_dir)
    echo "Creating ./$(get_target_dir)/Makefile"
    cp ./templates/Makefile $(get_target_dir)/
    echo ""
fi

if [[ $(isIn "$1" "$(get_valid_choices)") -ne 1 ]]
then
    echo $(usage)
    echo "  \"$1\" is not valid choice; Valid choices= $(get_valid_choices)"
    exit 1
fi

if [[ -z "$2" ]]
then
    echo $(usage)
    echo "  new_name is required"
    exit 1
fi

if [ -d "$(get_target_dir)/$2" ]; then
  echo "$(get_target_dir)/$2 already exists!"
  exit 1
fi

echo "$(get_script_dir)/templates/$1" "->" "$(get_target_dir)/$2"
cp -r "$(get_script_dir)/templates/$1" "$(get_target_dir)/$2"

echo Created new target: "$(get_target_dir)/$2"

