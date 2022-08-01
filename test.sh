#!/usr/bin/bash

# --------------------------------------
# recovery for multiple file types
# --------------------------------------
tests=(
    "qed"
    "test.sh"
    "qr_alltype_capacity.json"
    "qr_binary_capacity.json "
    "qr_capacity.json"
    "README.md"
    "data/aria.mid"
    "data/wave.gif"
    "data/assistant.mp4"
    "data/traumerei.pdf"
    "data/francis.pdf"
    "data/aria.m4a"
)

for t in ${tests[@]}
do
    qed -qe $t | xargs qed -d
done


# --------------------------------------
# recovery from mixed-duplicated data
# --------------------------------------
dup_tests=(
    "qed"
    "test.sh"
    "qr_alltype_capacity.json"
    "qr_binary_capacity.json "
    "qr_capacity.json"
    "README.md"
)


d=/tmp/.t
rm -rf $d; mkdir -p $d

for t in ${dup_tests[@]}
do
    qed -e $t
    pushd . &> /dev/null
    cd /tmp/.q

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

qed -d $d
