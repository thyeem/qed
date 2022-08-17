#!/usr/bin/bash

path=$(cd $(dirname $0); pwd -P)

QED="$path/qed -v"

files=(
    "$path/qed"
    "$path/test.sh"
    "$path/README.md"
    "$path/data/wave.gif"
    "$path/data/assistant.mp4"
    "$path/data/traumerei.pdf"
    "$path/data/qr_capacity.json"
    "$path/data/qr_binary_capacity.json"
    "$path/data/qr_alltype_capacity.json"
    "$path/data/aria.m4a"
    "$path/data/aria.mid"
    "$path/data/francis.pdf"
    "$path/data/francis.mp3"
)


red () {
    echo "\033[0;31m$1\033[0m"
}


green () {
    echo "\033[0;32m$1\033[0m"
}


msg () {
    >&2 echo "$@"
}


error () {
    msg $@
    exit 1
}


t () {
  msg
  msg "$3"
  msg "$4"
  msg

  local lhs=$(echo "$3" | head -c 32)
  local rhs=$(echo "$4" | head -c 32)
  if [ "$lhs" == "$rhs" ]; then
      msg $1 "($2)" ... $(green passed)
  else
      error $1 "($2)" ... $(red failed)
  fi
}


random_bytes () {
    echo  $(cat /dev/urandom | head -c 32)
}


tmp_filepath () {
    echo "/tmp/$(random_bytes | sha256sum | head -c 16)"
}


when_encode_decode_with_data_passed_via_stdin () {
    local f=
    for i in $(seq 0 5); do
        f=${files[i]}
        t "$FUNCNAME" $f \
        "$(cat $f | $QED | $QED -d | sha256sum)" \
        "$(sha256sum $f)"
    done
}


when_encode_decode_with_data_passed_via_args () {
    local f=
    for i in $(seq 0 5); do
        f=${files[i]}
        t "$FUNCNAME" $f \
        "$($QED $f | $QED -d | sha256sum)" \
        "$(sha256sum $f)"
    done
}

when_provided_with_option_images_in_browser () {
    local f=${files[5]}
    t "$FUNCNAME" $f \
    "$($QED -q $f | $QED -d | sha256sum)" \
    "$(sha256sum $f)"
}


when_provided_with_option_play_slideshows () {
    local f=${files[5]}
    t "$FUNCNAME" $f \
    "$($QED -p $f | $QED -d | sha256sum)" \
    "$(sha256sum $f)"
}


when_encoded_files_are_renamed_mixed_duplicated () {
    local o=$(tmp_filepath)
    local fs=${files[@]:3:3}

    mkdir -p $o
    for f in $fs; do
        $QED $f | tar x -C $o
    done

    # randomizes renames, and duplicates files encoded.
    pushd . &> /dev/null
    cd $o

    msg "random-renaming/duplicating endoded files..."
    msg
    for f in *; do
        # how many times these deadly tasks
        for _ in $(seq $1); do
            r=$(random_bytes | sha256sum | head -c 16)
            cp -f $f $r
        done
        rm -f $f
    done
    popd &> /dev/null

    # try to decode. let's go back to before!
    t "$FUNCNAME" "" \
    "$($QED -d $o | sha256sum)" \
    "$(echo $fs | xargs ls | sort | xargs cat | sha256sum)"
}


when_encode_decode_with_full_combination_of_capcodes () {
    local f=${files[2]}
    local level=("L" "M" "Q" "H")
    for v in $(seq 3 40); do
        for l in ${level[@]}; do
            t "$FUNCNAME" "$f:$l-$v-binary" \
            "$(${QED} -V $v -l $l $f | ${QED} -d | sha256sum)" \
            "$(sha256sum $f)"
        done
    done

}


when_encode_decode_with_full_list_of_files () {
    for f in ${files[@]}; do
        t "$FUNCNAME" $f \
        "$(${QED} $f | ${QED} -d | sha256sum)" \
        "$(sha256sum $f)"
    done
}


when_encode_decode_with_data_passed_via_stdin

when_encode_decode_with_data_passed_via_args

when_provided_with_option_images_in_browser

when_provided_with_option_play_slideshows

when_encoded_files_are_renamed_mixed_duplicated 2

when_encode_decode_with_full_combination_of_capcodes

when_encode_decode_with_full_list_of_files
