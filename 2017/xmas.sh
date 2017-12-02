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

function day2() {
    local table
    table=$(cat <<!
5 1 9 5
7 5 3
2 4 6 8
!
)
    table=$(cat <<!
5 9 2 8
9 4 7 3
3 8 6 5
!
)
    local table; table=$(cat "${inputDir}"/day2.txt)
    local -i min=0
    local -i max=0
    local -a row=()
    local -i checksum=0
    local -i value

    local -a tail
    local -i current
    local -i len
    local -i value2
    local -i checksum2=0

    while read -ra row; do
        # part1
        min=${row[0]}
        max=${row[0]}
        for i in $(seq 1 $(( ${#row[@]}-1)) ); do
            let value=${row[$i]}
            (( value > max )) && max=${value}
            (( value < min )) && min=${value}
        done
        (( checksum += (max - min)))

        #part 2
        len=${#row[@]}
        current=${row[0]}
        tail=( ${row[@]:1:(( len-1 ))} )
        while (( ${#tail[@]} > 0 )); do
            if (( current != 0 )); then
                for z in $(seq 0 $(( ${#tail[@]} - 1 ))); do
                    let value2=${tail[$z]}
                    case 1 in
                        $(( (current % value2)==0 )))
                            (( checksum2 += current / value2))
                            break 2
                            ;;
                        $(( (value2 % current)==0 )))
                            (( checksum2 += value2 / current ))
                            break 2
                            ;;
                    esac
                done
            fi
            current=${tail[0]}
            tail=( ${tail[@]:1:(( len-1 ))} )
        done
    done <<<"${table}"
    echo "part1 checksum = ${checksum}"
    echo "part2 checksum = ${checksum2}"
}

eval -- day"${day}"

# results
# day02 part1 44887
# day02 part2 242
