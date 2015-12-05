#!/bin/bash
day=$1
xcode=~/tmp/adventOfCode

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
    # 2572
    # 2631
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
    # 2572
    # 2631
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
    # 254575
    # 1038736
}

case ${day} in
    0|1|2)
        day${day}
        ;;
    3|3a|4)
        part=1
        [ "$2" == '2' ] && part=2
        day${day} ${part} $3
        ;;
    *)
        echo "Still waiting for day ${day}"
        ;;
esac
