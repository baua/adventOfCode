#!/bin/bash

inputDir="${HOME}/study/adventOfCode/2017/inputs"

if [ $# -lt 1 ]; then
    echo "usage: $0 <number-of-day>"
    exit -1
fi
day=$1
shift

# Reusable funcs -={
function abs(){
	local -i number=$1
	if (( number < 0 )); then
		echo $(( number * -1 ))
	else
        #shellcheck disable=SC2086
		echo ${number}
	fi
}

function ord {
    printf "%d" "'$1"
}

# Postition of the biggest value
function biggestPos() {
    local -a list; read -ra list <<<"$@"
    local -i biggest=0
    for i in $(seq 0 $((${#list[@]} - 1 ))); do
        (( ${list[$i]} > ${list[${biggest}]} )) && let biggest=i
    done
    echo ${biggest}
}

function dups() {
    local -a list=( $@ )
    local len=${#list[@]}
    local uniqElems; uniqElems=$(for i in "${list[@]}"; do echo "$i"; done| sort | uniq | wc -l)
    if (( len != uniqElems )); then
        echo "problem"
        #for i in "${list[@]}"; do echo $i; done| sort | uniq -c
        #echo "${list[@]}"
        exit
        return 1
    else
        return 0
    fi
}

function gridDist() {
    local -i x; x=$(abs "$1")
    local -i y; y=$(abs "$2")
    local -i dist=0

    if ((y > x )); then
        dist=x
        (( y-=x ))
        (( dist=dist+(y/2) ))
    else
        let dist=x
    fi
    echo ${dist}
}

# }=-

function lists() {
    local action=$1
    shift
    local list=$@

    case "${action}" in
        addUnique) noop ;;
    esac
}

# day 12 -={
function day12() {
    local data;
    data="$(cat "${inputDir}"/day12.txt)"
    local -A input
    local -A pipes
    local -i pid
    data=$(cat <<!
0 <-> 2
1 <-> 1
2 <-> 0, 3, 4
3 <-> 2, 4
4 <-> 2, 3, 6
5 <-> 6
6 <-> 4, 5
!
)
    while read -r pid _ rest; do
        input[${pid}]="${rest//, / }"
    done <<<"${data}"

    for x in "${!input[@]}"; do
        echo "$x -> ${input[$x]}"
    done
    echo

    # resolve pipes
    for i in "${!input[@]}"; do
        pipes[$i]+=${input[$i]// /|}
        for z in ${input[$i]}; do
            #shellcheck disable=SC1073
            pipes[$z]+="|$i"
        done
    done

    for x in "${!pipes[@]}"; do
        echo "$x -> ${pipes[$x]}"
    done

    echo "part1="
    echo "part2="
}

# }=-

# day 11 -={
function day11() {
    local data;
    local -a directions
    data="ne,ne,ne"
    data="ne,ne,sw,sw"
    data="ne,ne,s,s"
    data="se,sw,se,sw,sw"
    data="$(cat "${inputDir}"/day11.txt)"
    IFS=',' read -ra directions<<<"${data}"
    local -i x y
    let x=0
    let y=0
    local -i max=0
    local -i dist=0

    for dir in "${directions[@]}"; do
        case "${dir}" in
            n) (( y+=2 )) ;;
            s) (( y-=2 )) ;;
            ne) (( x++ )); (( y++ ));;
            se) (( x++ )); (( y-- ));;
            nw) (( x-- )); (( y++ ));;
            sw) (( x-- )); (( y-- ));;
            *) echo "problem"; exti;;
        esac
        dist=$(gridDist $x $y)
        (( dist > max )) && max=dist
    done

    echo "x=$x y=$y"
    echo -n "part1="
    gridDist $x $y
    echo "part2=$max"
}
# }=-

# day 10 -={
function day10() {
    local data;
    local -a list=();
    list=( $(seq 0 $(( 255 ))) )
    local -i listLength=${#list[@]}
    local -a subList
    local subListRev
    local -i skipSize=0
    local -i pos=0
    local -i end
    local -i rounds=1
    local -i part
    if [ $# -gt 0 ]; then
        let part=$1
    else
        let part=1
    fi
    data=$(cat <<!
3,0,4,1,5
!
)
    data="$(cat "${inputDir}"/day10.txt)"
    local -a lengths=()
    local -i c
    if (( part == 2 )); then
        local char
        if (( ${#data[@]} > 0 )); then
            while read -r -n 1 char; do
                let c=$(ord "${char}")
                (( c != 0 )) && lengths+=( $c )
            done<<<"${data}"
        fi
        lengths+=(17 31 73 47 23)
        rounds=64
    else
        IFS=',' read -ra lengths<<<"${data}"
    fi
    if (( listLength>0 )); then
        #shellcheck disable=SC2034
        for round in $(seq 1 ${rounds}); do
            #echo "round=${round} - p:$pos,s:$skipSize"
            for length in "${lengths[@]}"; do
                # find section
                let end=$((pos+length))
                if ((end >= listLength )); then
                    subList=( ${list[@]:${pos}} )
                    subList+=( ${list[@]:0:$((end - listLength ))} )
                else
                    subList=( ${list[@]:${pos}:${length}} )
                fi
                #echo "sublist(p:$pos,s:$skipSize,l:$length)=${subList[@]}"
                subListRev=( $(echo "${subList[@]}"|tr ' ' '\n'|tac|tr '\n' ' ') )
                for p in "${subListRev[@]}"; do
                    list[${pos}]=$p
                    ((pos++))
                    (( pos == listLength )) && let pos=0
                done
                (( pos += skipSize ))
                #(( pos >= listLength )) && (( pos=pos-listLength ))
                (( pos %= listLength ))

                (( skipSize ++ ))
            done
            dups "${list[@]}"
        done
    fi

    if (( part == 2 )); then
        local xorStr=
        local -a denseHash=()
        local -i hash
        for a in $(seq 0 16 255); do
            xorStr="${list[@]:$a:16}"
            eval "let hash=${xorStr// /^}"
            denseHash+=( ${hash} ) 
        done
        echo -n "part2="
        for dh in "${denseHash[@]}"; do
            printf "%02x" "${dh}"
        done
        echo
    else
        echo "part1=$(( ${list[0]} * ${list[1]} ))"
    fi
    #echo "part2=${}"
}
# }=-

# day 9 -={
function day9() {
    local data;
    data=$(cat <<!
{{<a!>},{<a!>},{<a!>},{<ab>}}
!
)
    data="$(cat "${inputDir}"/day9.txt)"

    local -i groups=0
    local -i garbageOn=0
    local -i score=0
    local -i ignoreNext=0
    local -i garbageCount=0

    while read -rn 1 char; do
        if (( ignoreNext == 1 )); then
            (( ignoreNext=0 ))
        else
            if (( garbageOn == 1 )); then
                case "${char}" in
                    "!") let ignoreNext=1 ;;
                    ">") let garbageOn=0 ;;
                    *) (( garbageCount++));;
                esac
            else
                case "${char}" in
                    "{") (( groups++ )) ;;
                    "}")
                        (( score += groups))
                        (( groups--))
                    ;;
                    "<") let garbageOn=1 ;;
                esac
            fi
        fi
    done <<<"${data}"
    echo "part1=${score}"
    echo "part2=${garbageCount}"

}
# }=-

# day 8 -={
function day8() {
    local data;
    data=$(cat <<!
b inc 5 if a > 1
a inc 1 if b < 5
c dec -10 if a >= 1
c inc -20 if c == 10
!
)
    data="$(cat "${inputDir}"/day8.txt)"
    local -A regs
    local -i biggerest=0
    local reg op value first cond
    local -i wahr value second
    while read -r reg op value _ first cond second; do
        wahr=0
        [ "${regs[${reg}]:-NilOrNotSet}" == "NilOrNotSet" ] && regs[${reg}]=0
        [ "${regs[${first}]:-NilOrNotSet}" == "NilOrNotSet" ] && regs[${first}]=0

        eval "(( ${regs[${first}]} ${cond} ${second} ))" && wahr=1
        if (( wahr == 1 )); then
            case "${op}" in
                inc) regs[${reg}]=$(( ${regs[${reg}]} + value )) ;;
                dec) regs[${reg}]=$(( ${regs[${reg}]} - value )) ;;
            esac
        fi
        (( ${regs[${reg}]} > biggerest )) && biggerest=${regs[${reg}]}
    done <<<"${data}"
    local -i biggest=0
    for r in "${regs[@]}"; do
        (( r > biggest )) && biggest=$r
    done
    echo "part1=${biggest}"
    echo "part2=${biggerest}"

}
# }=-

# day 7 -={
function day7() {
    local data;
    data=$(cat <<!
pbga (66)
xhth (57)
ebii (61)
havc (66)
ktlj (57)
fwft (72) -> ktlj, cntj, xhth
qoyq (66)
padx (45) -> pbga, havc, qoyq
tknk (41) -> ugml, padx, fwft
jptl (61)
ugml (68) -> gyxo, ebii, jptl
gyxo (61)
cntj (57)
!
)
    local -a holding
    local value
    data="$(cat "${inputDir}"/day7.txt)"
    declare -A progs=()
    while read -r name weight rest; do
        weight=${weight//(/}
        weight=${weight//)/}
        progs["${name}"]="|${weight}|"
        if [ ${#rest} -gt 0 ]; then
            rest=${rest#-> }
            rest=${rest//,/}
            progs["${name}"]+="${rest}"
        fi
    done<<<"${data}"

    for i in "${!progs[@]}"; do
        value="${progs[$i]}"
        read -ra holding <<<"${value##*|}"
        for h in "${holding[@]}"; do
            h=${h// /}
            progs[$h]="$i${progs[$h]}"
        done
    done

    for i in "${!progs[@]}"; do
        value=${progs[$i]}
        if [ "${value:0:1}" == "|" ]; then
            echo "part1=$i"
        fi
    done
    read

    local -i sum=0
    local -a leaves
    local -i foundDiff=0
    local -i nodeReady=1
    local -A weights=()
    local -A check=()
    local -i diff=0
    local foo

    while (( foundDiff == 0 )); do
        for i in "${!progs[@]}"; do
            echo -n "trying $i ..."
            nodeReady=1
            check=()
            let nodeReady=1
            value="${progs[$i]}"
            read -ra leaves<<<"${value##*|}"
            value=${value%|*}
            value=${value#*|}

            # check if all leaves are resolved which means the weight is set
            for leaf in "${leaves[@]}"; do
                if [ "${weights[${leaf}]:-NilOrNotSet}" == "NilOrNotSet" ]; then
                    let nodeReady=0
                fi
            done

            # if so then loop again
            if (( nodeReady == 1 )); then
                echo -n " check leaves ..."
                for leaf in "${leaves[@]}"; do
                    check[${weights[${leaf}]}]+="|${leaf}"
                    (( value += ${weights[${leaf}]} ))
                done
                if [ ${#check[@]} -gt 1 ]; then
                    diff=0
                    local -a checkleaves
                    for item in "${!check[@]}"; do
                        echo "progs ${check[${item}]} have ${item}"
                        foo="${check[${item}]}"
                        IFS='|' read -ra checkleaves <<<"${foo#|}"
                        if (( diff == 0 )); then
                            let diff=${item}
                        else
                            (( diff -= item ))
                        fi
                        if [ ${#checkleaves[@]} -eq 1 ]; then
                            foo="${progs[${checkleaves[0]}]}"
                            foo=${foo%|*}
                            foo=${foo#*|}
                        fi
                        foundDiff=1
                        break
                    done
                    #echo "diff=${diff}"
                    #echo "$i=${progs[$i]}"
                    #echo "cwwwj=${progs[cwwwj]}"
                    #echo "cwwwj=${weights['cwwwj']}"
                    #echo "slzaeep=${weights['slzaeep']}"
                    #echo "hiotqxu=${weights['hiotqxu']}"
                    #echo "qppggd=${weights['qppggd']}"
                fi
                weights[$i]=${value}
                echo " finished."
            else
                echo "$i is not weighted yet"
            fi

            # debug
            #for weight in "${!weights[@]}"; do
            #    echo "$weight weighs ${weights[${weight}]}"
            #done
        done
    done
    echo -n "part2="
    echo $((foo - diff))
    echo
}
# }=-

# day 6 -={
function day6() {
    local data;
    data="0 2 7 0"
    data="$(cat "${inputDir}"/day6.txt)"
    local -a banks; read -ra banks <<<"${data[@]}"
    local -A states=()
    local currentState=${data// /_}
    local -i bigPos bigVal pos
    local -i cycles

    while [ "${states[${currentState}]:-NilOrNotSet}" == "NilOrNotSet" ]; do
        bigPos=$(biggestPos "${banks[@]}")
        let bigVal=${banks[${bigPos}]}
        let -i numBanks=${#banks[@]}

        states[${currentState}]=${cycles}

        banks[${bigPos}]=0
        (( pos=bigPos+1 ))

        while (( bigVal > 0 )); do
            if (( pos > numBanks - 1)); then pos=0; fi
            banks[${pos}]=$(( ${banks[${pos}]}+1 ))
            (( bigVal -- ))
            (( pos++ ))
        done
        (( cycles ++ ))
        dummy="${banks[*]}"
        currentState=${dummy// /_}
    done
    echo "part1=${cycles}"
    local loop; loop=$(( cycles - ${states[${currentState}]}))
    echo "part2=${loop}"
}

# }=-

# day 5 -={
function day5() {
    local data;
    local -a stack
    stack=( 0 3 0 1 -3 )
    local stackOrg; stackOrg=( $(xargs < "${inputDir}"/"${FUNCNAME[0]}".txt ) )
    stack=( ${stackOrg[@]} )
    local -i len=${#stack[@]}
    local -i pointer=0
    local -i offset
    local -i steps=0

    while (( pointer < len )); do
        offset=${stack[${pointer}]}
        stack[${pointer}]=$(( offset + 1 ))
        (( pointer += offset ))
        (( steps ++ ))
    done
    echo "part1=${steps}"

    stack=( 0 3 0 1 -3 )
    stack=( ${stackOrg[@]} )
    pointer=0;
    steps=0
    while (( pointer < len )); do
        let offset=${stack[${pointer}]}
        if (( offset >=  3 )); then
            stack[${pointer}]=$(( offset - 1 ))
        else
            stack[${pointer}]=$(( offset + 1 ))
        fi
        (( pointer += offset ))
        (( steps ++ ))
    done
    echo "part2=${steps}"

}

# }=-

# day 4 -={
function day4() {
    local data;
    data=$(cat <<!
aa bb cc dd ee
aa bb cc dd aa
aa bb cc dd aaa
aa
!
)
    data="$(cat "${inputDir}"/day4.txt)"
    local -a row
    local -A dummy=()
    local -A dummy2=()
    local -i duplicates=0
    local -i anagrams=0
    local -i validPasswords=0
    local -i validPasswords2=0
    local hash
    local -i partOneDone=0

    while read -ra row; do
        let partOneDone=0
        let duplicates=0
        let duplicates2=0
        dummy=()
        dummy2=()
        for i in "${row[@]}"; do
            # part1
            if [[ "${dummy[$i]:-NilOrNotSet}" != "NilOrNotSet" ]] && (( partOneDone == 0 )); then
                (( duplicates ++ ))
                partOneDone=1
            else
                dummy[$i]=1
            fi

            #part2
            hash="$(echo "$i" | fold -w1 |sort | xargs)"
            hash=${hash// /_}
            if [ "${dummy2[${hash}]:-NilOrNotSet}" != "NilOrNotSet" ]; then
                (( duplicates2 ++ ))
                break
            else
                dummy2[${hash}]=1
            fi
        done
        if (( duplicates == 0 )) && (( partOneDone ==0 )); then
            ((validPasswords++))
        fi
        if (( duplicates2 == 0 )); then
            ((validPasswords2++))
        fi
    done <<<"${data}"
    echo "part1 valid passwords = $validPasswords"
    echo "part2 valid passwords = $validPasswords2"
}

# }=-

# day 3 -={
function day3() {
#shellcheck disable=SC2034
	mem=$(cat <<!
17  16  15  14  13
18   5   4   3  12
19   6   1   2  11
20   7   8   9  10
21  22  23
!
)

#1  R
#2  RU
#3  RUL
#4  RULL
#5  RULLL
#6  RULLLD
#7  RULLLDD
#8  RULLLDDDR
#9  RULLLDDDRR
#10 RULLLDDDRR
#11 RULLLDDDRRRU
#12 RULLLDDDRRRUU
#13 RULLLDDDRRRUU
#RULLLDDD
	# R = x+1
	# U = y+1
	# L = x-1
	# D = y-1
	# R U L D
	local direction="R"
	local -i maxX=0
	local -i minX=0
	local -i maxY=0
	local -i minY=0

	local -i number=13
	local -i number=133
	local -i number=289326
	local -i marker=1
	local -i marker2=1

	local -i part2Done=0

	local -i x=0
	local -i y=0
	local -A grid=()
	grid['0,0']=1
	local -i calcNumber=0

	while (( marker < number )); do
		calcNumber=0
		#echo "part1 - $marker  - ($x,$y) ($maxX,$maxY) $direction"
		case "${direction}" in
			R)
				(( x+=1 ))
				if (( x > maxX)); then
					(( maxX++ ))
					direction="U"
				fi
			;;
			L)
				(( x-=1 ))
				if (( x < minX)); then
					(( minX-- ))
					direction="D"
				fi
			;;
			U)
				(( y+=1 ))
				if (( y > maxY)); then
					(( maxY++ ))
					direction="L"
				fi
			;;
			D)
				(( y-=1 ))
				if (( y < minY)); then
					(( minY-- ))
					direction="R"
				fi
			;;
		esac

		# part two value calculation is a bit harder
		if (( part2Done == 0 )); then
			[ ${grid["$((x+0)),$((y+1))"]:-NilOrNotSet} != "NilOrNotSet" ] && (( calcNumber+=${grid["$((x+0)),$((y+1))"]} ))
			[ ${grid["$((x+1)),$((y+1))"]:-NilOrNotSet} != "NilOrNotSet" ] && (( calcNumber+=${grid["$((x+1)),$((y+1))"]} ))
			[ ${grid["$((x+1)),$((y+0))"]:-NilOrNotSet} != "NilOrNotSet" ] && (( calcNumber+=${grid["$((x+1)),$((y+0))"]} ))
			[ ${grid["$((x+1)),$((y-1))"]:-NilOrNotSet} != "NilOrNotSet" ] && (( calcNumber+=${grid["$((x+1)),$((y-1))"]} ))
			[ ${grid["$((x+0)),$((y-1))"]:-NilOrNotSet} != "NilOrNotSet" ] && (( calcNumber+=${grid["$((x+0)),$((y-1))"]} ))
			[ ${grid["$((x-1)),$((y-1))"]:-NilOrNotSet} != "NilOrNotSet" ] && (( calcNumber+=${grid["$((x-1)),$((y-1))"]} ))
			[ ${grid["$((x-1)),$((y-0))"]:-NilOrNotSet} != "NilOrNotSet" ] && (( calcNumber+=${grid["$((x-1)),$((y+0))"]} ))
			[ ${grid["$((x-1)),$((y+1))"]:-NilOrNotSet} != "NilOrNotSet" ] && (( calcNumber+=${grid["$((x-1)),$((y+1))"]} ))
			grid["$x,$y"]=${calcNumber}
			#echo "part2 - $calcNumber  - ($x,$y) ($maxX,$maxY) $direction"
			if (( calcNumber > number )); then
				echo "part2 number=${calcNumber}"
				part2Done=1
			fi
		fi

		(( marker ++ ))
	done

	echo "($x,$y)"
	local -i xx; let xx=$(abs $x)
	local -i yy; let yy=$(abs $y)
	echo "path=$((xx+yy))"
}

# }=-

# day 1 -={
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

# }=-

# day 2 -={
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

# }=-

eval -- day"${day}" "$@"

# results
# day12 part1
# day12 part2
# day11 part1 670
# day11 part2 1426
# day10 part1 9656
# day10 part2 20b7b54c92bf73cf3e5631458a715149
# day09 part1 12803
# day09 part2 6425
# day08 part1 6611
# day08 part2 6619
# day07 part1 cyrupz
# day07 part2 cwwwj=201-8=193
# day06 part1 3156
# day06 part2 1610
# day05 part1 373160
# day05 part2 26395586
# day04 part1 386
# day04 part2 208
# day03 part1 419
# day03 part2 295229
# day02 part1 44887
# day02 part2 242
