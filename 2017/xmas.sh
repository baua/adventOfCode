#!/bin/bash

inputDir="${HOME}/study/adventOfCode/2017/inputs"

if [ $# -ne 1 ]; then
    echo "usage: $0 <number-of-day>"
    exit -1
fi
day=$1

function day1() {
    list=12131415
    list=123123
    list=123425
    local list; list=$(cat "${inputDir}"/day1.txt)

    local -i sum=0
    local -i sum2=0
    local -i last current
    local -i len; let len=${#list}
    local -i half; let half=$(( ${#list} / 2 ))
    last=${list:((${#list}-1)):1}
    last2=${list:((half)):1}
    for i in $(seq 0 $((${#list}-1))); do
        current=${list:$i:1}
        (( last == current )) && ((sum+=current))
        (( last2 == current )) && ((sum2+=current))
        let last=current
        let last2=${list:$(((i+half+1) % len)):1}
    done
    echo "sum_part1=${sum}"
    echo "sum_part2=${sum2}"
}

eval -- day"${day}"
