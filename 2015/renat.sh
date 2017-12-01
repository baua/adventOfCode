#!/usr/bin/env bash

lenx=$1
leny=$2

a=`seq  -f "." -s '' $[lenx*leny]`

function toggle {
   tr '.x' 'x.'
}

function on {
   tr '.' 'x'
}

function off {
   tr 'x' '.'
}

function modify {
    local x1=$1
    local y1=$2
    local x2=$3
    local y2=$4
    local f=$5

    for y in $(seq $y1 $y2); do
        b=$[y*lenx + x1]
        e=$[y*lenx + x2 +1]
        mlen=$[e-b]
        m=$($f <<< ${a:b:mlen})
        a=${a:0:b}$m${a:e}
    done
}

function print {
    for y in $(seq 0 $[leny-1]); do
        echo ${a:$[y*lenx]:lenx}
    done
}

while read i
do
    i=${i/turn /}
    i=${i//,/ }
    ia=( $i )

    modify ${ia[1]} ${ia[2]} ${ia[4]} ${ia[5]} ${ia[0]}
    echo modify ${ia[1]} ${ia[2]} ${ia[4]} ${ia[5]} ${ia[0]}
    #print
done

echo -n result:
tr -d '.\n' <<< $a | wc -c
