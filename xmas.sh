#!/bin/bash
day=$1
xcode=~/tmp/xmascode

case ${day} in 
    0)
        echo $(($(grep -o '(' $pin| wc -l)-$(grep -o ')' $pin | wc -l)))
        ;;

    1)
        pin=~/tmp/xmas-code/day1.in
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
        ;;
    2)
        in=${xcode}/day2.in
        sf=0  # square feet
        rf=0  # ribbon feet
        le=0  # longest edge
        ss=0  # small side
        wr=0  # wrap ribbon
        br=0  # bow ribbon
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
        ;;
    3)
        in=$(cat ${xcode}/day3.txt)
        # get dimensions
        declare -a x
        declare -a y
        pc=0     # present carrier (part one only 0, part two 0-santa 1-robot)
        x=0
        y=0
        pos=0
        part=1
        [ "$2" == '2' ] && part=2
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

        ;;
    *)
        echo "Still waiting for day ${day}"
        ;;
esac
