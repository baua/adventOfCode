#!/bin/bash
day=$1
xcode=~/study/adventOfCode


# $1 - list
# $2 - item
function listContains() {
    len=${#@}
    list=${@:1:$((len-1))}
    elem=${@:${len}:1}
    for item in ${list[@]}; do
        [ "${item}" = "${elem}" ] && return 0
    done
    return 1
}

function day0() {
    local pin=${xcode}/day1.in
    echo $(($(grep -o '(' $pin| wc -l)-$(grep -o ')' $pin | wc -l)))
}

function day1() {
    local pin=${xcode}/day1.in
    p=$(cat $pin)
    floor=0
    for i in `seq 0 $((${#p}-1))`; do
        c=${p:$i:1}
        case ${c} in
            '(')
                floor=$(( floor+=1 ))
            ;;
            ')')
                floor=$(( floor-=1 ))
            ;;
            *)
                echo "Wrong character detected"
                break
                ;;
        esac
        if [ $floor -eq -1 ]; then
            echo "On position $(($i+1)) he reaches floor -1";
        fi
    done
    echo "At the end of the day he ends up on floor ${floor}"
}

function day2() {
    local in=${xcode}/day2.in
    local sf=0  # square feet
    local rf=0  # ribbon feet
    local le=0  # longest edge
    local ss=0  # small side
    local wr=0  # wrap ribbon
    local br=0  # bow ribbon
    while read line; do
        sfp=0  # square feet package
        # read l w h into edges array
        read -r -a edges <<< ${line//x/ }

        # get the longest edge
        [ ${edges[0]} -gt ${edges[1]} ] && le=${edges[0]} || le=${edges[1]}
        [ ${edges[2]} -gt ${le} ] && le=${edges[2]}

        # get the short edges
        shortEdges=()
        pos=0
        for i in ${edges[@]}; do
            [ ${i} == ${le} ] && break || shortEdges=("${shortEdges[@]}" ${i})
            pos=$(( pos+=1 ))
        done
        pos=$(( pos+=1 ))
        shortEdges=("${shortEdges[@]}" ${edges[@]:${pos}})

        # part one
        s1=$(( ${edges[0]}*${edges[1]} ))
        s2=$(( ${edges[0]}*${edges[2]} ))
        s3=$(( ${edges[1]}*${edges[2]}))
        ss=$(( ${shortEdges[0]} * ${shortEdges[1]} ))
        sfp=$(( 2 * ( s1 + s2 + s3 ) + ss ))
        sf=$(( sf + sfp))

        # part two
        wr=$(( wr + ((${shortEdges[0]}+${shortEdges[1]}) * 2) ))
        br=$(( br + (${edges[0]}*${edges[1]}*${edges[2]}) ))

    done < ${in}
    echo "Order ${sf} square feed of paper."
    echo "Order $(( wr + br )) feed of ribbon."
}

function day3() {
    part=$1
    in=$(cat ${xcode}/day3.txt)
    # get dimensions
    declare -a x
    declare -a y
    pc=0     # present carrier (part one only 0, part two 0-santa 1-robot)
    x=0
    y=0
    pos=0
    declare -A m
    m[0,0]=1

    if [ ${part} -eq 2 ]; then
        xr=0
        yr=0
    fi

    while [ ${pos} -lt ${#in} ]; do
        c=${in:${pos}:1}

        case ${c} in
            '>'|'<')
                if [ "${pc}" == "0" ]; then
                    [ ${c} = '>' ] && x=$(( x += 1 )) || x=$(( x -= 1 ))
                else
                    [ ${c} = '>' ] && xr=$(( xr += 1 )) || xr=$(( xr -= 1 ))
                fi
                ;;
            '^'|'v')
                if [ "${pc}" == "0" ]; then
                    [ ${c} == '^' ] && y=$(( y += 1 )) || y=$(( y -= 1 ))
                else
                    [ ${c} == '^' ] && yr=$(( yr += 1 )) || yr=$(( yr -= 1 ))
                fi
                ;;
            *)
                echo "Unknown character (${c}) on position ${pos}";
                exit -1
        esac


        if [ "${pc}" == "0" ]; then
            if [ "${m[${x},${y}]}" != "" ]; then
                m[${x},${y}]=$(( m[${x},${y}]+=1 ))
            else
                m[${x},${y}]=1
            fi
        else
            if [ "${m[${xr},${yr}]}" != "" ]; then
                m[${xr},${yr}]=$(( m[${xr},${yr}]+=1 ))
            else
                m[${xr},${yr}]=1
            fi
        fi
        # if part two toggle carrier
        if [ $part -eq 2 ]; then
            [ $pc -eq 0 ] && pc=1 || pc=0
        fi
        pos=$(( pos+=1 ))
    done

    echo ${#m[@]}
}

function day3a() {
    # TODO: current code produces one to much for part 1 and two too much
    #       for part 2
    in=$(cat ${xcode}/day3.txt)
    local num=1
    [ $1 -eq 2 ] && num=2
    local pc=1     # present carrier (part one only 1, part two 1-santa 2-robot)
    local pos=0
    declare -A m
    local m
    m[0,0]=1
    for i in $(seq 1 ${num}); do
        local x${i}=0
        local y${i}=0
    done

    while [ ${pos} -lt ${#in} ]; do
        c=${in:${pos}:1}

        case ${c} in
            '>'|'<')
                    if [ ${c} = '>' ]; then
                        let x${pc}=$(( x${pc} += 1 ))
                    else
                        let x${pc}=$(( x${pc} -= 1 ))
                    fi
                ;;
            '^'|'v')
                    if [ ${c} = '^' ]; then
                        let y${pc}=$(( y${pc} += 1 ))
                    else
                        let y${pc}=$(( y${pc} -= 1 ))
                    fi
                ;;
             *)
                echo "Unknown character (${c}) on position ${pos}";
                exit -1
        esac

        x=x${pc}
        y=y${pc}
        if [ "${m[${!x},${!y}]}" != "" ]; then
            m[${!x},${!y}]=$(( m[$x${pc},$y${pc}]+=1 ))
        else
            m[${!x},${!y}]=1
        fi
        echo "x=$x (${!x}) y=$y (${!y}) m=${m[${!x},${!y}]}"

        # if part two toggle carrier
        if [ $part -eq 2 ]; then
            [ $pc -eq 1 ] && pc=2 || pc=1
        fi
        pos=$(( pos+=1 ))
    done

    echo x= $x1
    echo y= $y1

    echo ${#m[@]}
}

function day4(){
    local puzzle=bgvyzdsv
    local count=0
    local result=''
    local start='00000'
    local count=0
    if [ "$1" = "2" ]; then
        start='000000'
    fi
    [ "$2" != "" ] && count=$2

    while [ "${result:0:${#start}}" != "${start}" ]; do
        result=$(echo -n ${puzzle}${count}|md5sum)
        count=$(( count+=1 ))
        [ $(( count % 10000 )) -eq 0 ] && echo $count
    done
    echo $(( count - 1 ))
}

function day5part1() {
    local in=${xcode}/day5.txt
    local -a vowels=( a e i u o )
    local hasDouble=0
    local vowelCount=0
    local niceStrings=0
    local lastChar=''
    local -a naughty=( ab cd pq xy)
    for word in $(cat ${in}); do
        hasDouble=0
        vowelCount=0
        lastChar=''
        for p in $(seq 0 $(( ${#word} - 1 ))); do
            c=${word:${p}:1}
            $(listContains "${vowels[@]}" ${c}) && vowelCount=$(( vowelCount += 1 ))
            [ "${lastChar}" = "${c}" ] && hasDouble=1
            lastChar=${c}
        done
        if [[ "${word}" =~ .*(ab|cd|pq|xy).* ]]; then
            continue
        fi
        [ ${vowelCount} -ge 3 -a ${hasDouble} -ge 1 ] && niceStrings=$(( niceStrings += 1))
    done
    echo "Number of nice strings = ${niceStrings}"
}

function day5part2(){
    local in=${xcode}/day5.txt
    local niceStrings=0
    local doublePair=0
    local repeatedLetter=0
    for word in $(cat ${in}); do
        doublePair=0
        repeatedLetter=0
        for pos in $(seq 0 $(( ${#word} - 1 ))); do
            pair=${word:${pos}:2}
            rest=${word:$(( ${pos}+2 )):$(( ${#word}-pos ))}
            if [[ "${rest}" =~ .*${pair}.* ]]; then
                doublePair=$(( doublePair+=1 ))
            fi
            c=${word:${pos}:1}
            ccc=${word:$(( ${pos}+2 )):1}
            if [[ ${c} == ${ccc} ]]; then
                repeatedLetter=$(( repeatedLetter+=1 ))
            fi
        done
        if [ ${doublePair} -ge 1 -a ${repeatedLetter} -ge 1 ]; then
            niceStrings=$(( niceStrings+=1 ))
        fi
    done
    echo "Number of nice strings = ${niceStrings}"
}

# $1 - set to (0|1|t) t=toggle
function setSection() {
    local setTo=$1
    local x0=$2
    local y0=$3
    local x1=$4
    local y1=$5

    for x in $(seq ${x0} ${x1}); do
        for y in $(seq ${y0} ${y1}); do
            if [ "${setTo}" = "t" ]; then
                [ ${matrix[${x},${y}]} -eq 0 ] && matrix[${x},${y}]=1 || matrix[${x},${y}]=0
            else
                matrix[${x},${y}]=${setTo}
            fi
        done
    done
    return ${matrix}
}

function countLights() {
    echo "Counting ..."
    local -i dim=$1
    local -i count=0

    for x in $(seq 0 ${dim}); do
        for y in $(seq 0 ${dim}); do
            [ ${matrix[${x},${y}]} -eq 1 ] && count=$(( count+=1 ))
        done
    done
    echo ${count}
}

function setSectionb() {
    local setTo=$1
    local x0=$2
    local y0=$3
    local x1=$4
    local y1=$5

    for x in $(seq ${x0} ${x1}); do
        for y in $(seq ${y0} ${y1}); do
            if [ "${setTo}" = "t" ]; then
                [ ${matrix[${x},${y}]} -eq 0 ] && matrix[${x},${y}]=1 || matrix[${x},${y}]=0
            else
                matrix[${x},${y}]=${setTo}
            fi
        done
    done
    return ${matrix}
}


function day6b() {
    local in=${xcode}/day6.txt
    dim=999
    declare -A matrix

    while read line; do
        echo $line
    done <<<$(tac ${in})
}

function day6() {
    local in=${xcode}/day6.txt
    dim=999
    declare -A matrix
    echo "Initialise"
    setSection 1 0 0 ${dim} ${dim}

    while read line; do
        echo ${line}
        case ${line} in
            turn\ on\ *)
                    read a b edge1 c edge2 <<<${line}
                    setSection 1 ${edge1%%,*} ${edge1##*,} ${edge2%%,*} ${edge2##*,}
                ;;
            turn\ off\ *)
                    read a b edge1 c edge2 <<<${line}
                    setSection 0 ${edge1%%,*} ${edge1##*,} ${edge2%%,*} ${edge2##*,}
                ;;
            toggle\ *)
                    read a edge1 b edge2 <<<${line}
                    setSection t ${edge1%%,*} ${edge1##*,} ${edge2%%,*} ${edge2##*,}
                ;;
            *)
                echo "This is an undefine command."
                exit -1
                ;;
        esac
    done <${in}
    echo $(countLights ${dim})
}

function day8() {
    local in=${xcode}/day8.txt
    local -i memCount=0
    local -i strCount=0
    file=$(cat ${in})


    if [ ${part} -eq 1 ]; then
        # TODO:
        # is there a way without using sed?
        for line in ${file}; do
            memCount=$(( memCount += ${#line} ))
            str=${line:1:$((${#line}-2))}
            str=$(sed -e 's/\(\\"\|\\\\\|\\x..\)/X/g' <<<${str})
            strCount=$(( strCount += ${#str} ))
        done

        echo $(( memCount - strCount ))
    else
        for line in ${file}; do
            echo "0: $line"
            strCount=$(( strCount += ${#line} ))
            str=${line//\\/\\\\}
            str2=${str//\"/\\\"}
            final="\"${str2}\""
            memCount=$(( memCount += ${#final} ))
        done

        echo $(( memCount - strCount ))
    fi
}

function day9_getDistance(){
    echo "hier"
    echo $@
    local -a args=$@
    local total=${1}
    if [ $# -eq 1 ]; then
        echo $1
    else
        echo ${args:2}
        #for city in ${args:2}: 
        #    echo $ 
    fi
}

function day9(){
    local in=${xcode}/day9.txt
    local -A cities
    local -A dists

    while read c to c2 eq distance; do
        cities[${c}]=0
        dists[${c}To${c2}]=${distance}
    done <${in}
    day9_getDistance 0 ${!cities[@]}
    echo ${!cities[@]}
    echo ${!dists[@]}
}

case ${day} in
    0|1|2|6|6b)
        day${day}
        ;;
    3|3a|4|8|9)
        part=1
        [ "$2" == '2' ] && part=2
        day${day} ${part} $3
        ;;
    5)
        part=1
        [ "$2" == '2' ] && day5part2 || day5part1
        ;;
    *)
        echo "Still waiting for day ${day}"
        ;;
esac
