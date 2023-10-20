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
  eval "$3"                                \
      && msg $1 "($2)" ... $(green passed) \
      || error $1 "($2)" ... $(red failed)
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
        t "$FUNCNAME" $f "cat $f | $QED | $QED -d >/dev/null"
    done
}


when_encode_decode_with_data_passed_via_args () {
    local f=
    for i in $(seq 0 5); do
        f=${files[i]}
        t "$FUNCNAME" $f "$QED $f | $QED -d >/dev/null"
    done
}

when_provided_with_option_images_in_browser () {
    local f=${files[5]}
    t "$FUNCNAME" $f "$QED -q $f | xargs open"
}


when_provided_with_option_play_slideshows () {
    local f=${files[5]}
    t "$FUNCNAME" $f "$QED -p $f | xargs open"
}


when_encoded_files_are_renamed_mixed_duplicated () {
    local o=$(tmp_filepath)
    local fs=${files[@]:3:3}

    # generate QR images to target dir
    mkdir -p $o
    for f in $fs; do
        $QED $f | tar x -C $o
    done

    cd $o

    # intentionally corrupt directory configuration
    msg "random-renaming/duplicating endoded files..."
    msg
    local r=
    local q=
    for f in *; do
        # renames file with random string
        r=$(random_bytes | sha256sum | head -c 16)
        cp -f $f $r

        # duplicates and relocates files
        x=$(random_bytes | sha256sum | head -c 6)
        y=$(random_bytes | sha256sum | head -c 6)
        mkdir -p "$x" && cp -f $r "$_"
        mkdir -p "$x/$y" && mv -f $f "$_/$r"
    done

    # try to decode. let's go back to before!
    t "$FUNCNAME" "dir-corruption-test" "$QED -d $o >/dev/null"
    rm -rf o
}


when_encode_decode_with_full_combination_of_capcodes () {
    local f=${files[1]}
    local level=("L" "M" "Q" "H")
    for v in $(seq 3 40); do
        for l in ${level[@]}; do
            t "$FUNCNAME" "$f:$l-$v-binary" \
              "$QED -V $v -l $l $f | $QED -d >/dev/null"
            sleep 1
        done
    done

}


when_encode_decode_with_full_list_of_files () {
    for f in ${files[@]}; do
        t "$FUNCNAME" $f "$QED $f | $QED -d >/dev/null"
        sleep 1
    done
}


when_encode_decode_with_data_passed_via_stdin

when_encode_decode_with_data_passed_via_args

when_provided_with_option_images_in_browser

when_provided_with_option_play_slideshows

when_encode_decode_with_full_combination_of_capcodes

when_encoded_files_are_renamed_mixed_duplicated

when_encode_decode_with_full_list_of_files
