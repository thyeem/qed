#!/usr/bin/bash

path=$(dirname $0)
QED="$path/qed"

# --------------------------------------
# recovery for multiple file types
# --------------------------------------
tests=(
    "$path/qed"
    "$path/test.sh"
    "$path/qr_alltype_capacity.json"
    "$path/qr_binary_capacity.json"
    "$path/qr_capacity.json"
    "$path/README.md"
    "$path/data/aria.mid"
    "$path/data/wave.gif"
    "$path/data/assistant.mp4"
    "$path/data/traumerei.pdf"
    "$path/data/francis.pdf"
    "$path/data/aria.m4a"
)

for t in ${tests[@]}
do
    ${QED} -qe $t | xargs ${QED} -d
done


# --------------------------------------
# recovery from mixed-duplicated data
# --------------------------------------
dup_tests=(
    "$path/qed"
    "$path/test.sh"
    "$path/qr_alltype_capacity.json"
    "$path/qr_binary_capacity.json"
    "$path/qr_capacity.json"
    "$path/README.md"
)


d=/tmp/.t
o=/tmp/.o
rm -rf $d; mkdir -p $d

for t in ${dup_tests[@]}
do
    ${QED} -e -o $o $t

    pushd . &> /dev/null
    cd $o

    # randomize file names and duplicate them.
    for f in *.png
    do
        r=$(basename $(mktemp))
        cp -f $f "$d/$r"

        r=$(basename $(mktemp))
        cp -f $f "$d/$r"
    done
    popd &> /dev/null
done

${QED} -d $d
