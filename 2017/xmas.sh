#!/bin/bash

inputDir="${HOME}/study/adventOfCode/2017/inputs"

if [ $# -ne 1 ]; then
    echo "usage: $0 <number-of-day>"
    exit -1
fi
day=$1

function day1() {
    local list; list=$(cat "${inputDir}"/day1.txt)

    local -i sum=0
    local -i last current
    last=${list:((${#list}-1)):1}
    for i in $(seq 0 $((${#list}-1))); do
        current=${list:$i:1}
        (( last == current )) && ((sum+=current))
        let last=current
    done
    echo "sum=${sum}"
}

eval -- day"${day}"
