#!/usr/bin/bash

path=$(dirname $0)

QED="$path/qed"

files=(
    "$path/qed"
    "$path/test.sh"
    "$path/README.md"
    "$path/qr_capacity.json"
    "$path/qr_binary_capacity.json"
    "$path/qr_alltype_capacity.json"
    "$path/data/wave.gif"
    "$path/data/traumerei.pdf"
    "$path/data/assistant.mp4"
    "$path/data/aria.mid"
    "$path/data/aria.m4a"
    "$path/data/francis.pdf"
    "$path/data/francis.mp3"
)


stderr_msg () {
    >&2 echo
    >&2 echo "$@" "\t"
}


error () {
    stderr_msg $@
    exit 1
}


when_encoded_files_are_renamed_mixed_duplicated () {
    local files=${files[@]:5:5}
    local out=`${QED} -e ${files[@]}`

    # randomizes renames, and duplicate files encoded.
    pushd . &> /dev/null
    cd $out

    stderr_msg "random-renaming/duplicating endoded files..."
    stderr_msg
    for f in *; do
        # how many times these deadly tasks
        for _ in $(seq $1); do
            r=$(basename $(mktemp))
            cp -f $f $r
        done
        rm -f $f
    done
    popd &> /dev/null


    # try to decode. let's go back to before!
    ${QED} -d $out
}


when_provided_with_option_images_on_browser () {
    ${QED} -eq ${files[5]}
}


when_encode_decode_with_multiple_file_types () {
    ${QED} -e ${files[@]} | ${QED} -d
}



when_encoded_files_are_renamed_mixed_duplicated 2

when_provided_with_option_images_on_browser

when_encode_decode_with_multiple_file_types
