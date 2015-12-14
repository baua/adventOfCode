#!/bin/python

import sys
import pprint
import re

def readFile(filename):
    f = open(filename,'r')
    return f.read()

def day1(infile,part):
    floor = 0
    pos = 0
    string = readFile(infile).rstrip()
    for c in string:
        if c == '(':
            floor += 1
        elif c == ')':
            floor -= 1
        else:
            print("Invalid character (%s)" % c)
            sys.exit(1)
        if part == 2 and floor == -1:
            break
        pos += 1

    if part == 1:
        print("floor: %s" % floor)
    elif part == 2:
        if floor == -1:
            print("On position %s he reaches the basement" % pos)
        else:
            print("He never reaches the basement")

def day6_changeArea(p1,p2,state,matrix,part=1):
    for x in range(int(p1[0]),int(p2[0])+1):
        for y in range(int(p1[1]),int(p2[1])+1):
            if part == 1:
                if state > -1:
                    matrix[x][y] = state
                else:
                    matrix[x][y] ^= 1
            elif part == 2:
                if state == 1:
                    matrix[x][y] += 1
                elif state == 0:
                    matrix[x][y] -= 1
                elif state == -1:
                    matrix[x][y] += 2

                if matrix[x][y] < 0:
                    matrix[x][y] = 0

            else:
                print("This part is not implemented.")
                sys.exit(1)

    return matrix

def day6_countLights(matrix,part):
    lightsOn=0
    for x in range(0,len(matrix)):
        for y in range(0,len(matrix[0])):
            if matrix[x][y] > 0:
                if part == 1:
                    lightsOn += 1
                elif part == 2:
                    lightsOn += matrix[x][y]

    return lightsOn

def day6(infile,part):
    dim = 1000
    matrix = [ [ 0 for x in range(dim) ] for x in range(dim) ]
    string = readFile(infile).rstrip()
    regex = re.compile('^(.*) ([\d,]+) through ([\d,]+)$')

    for line in string.split("\n"):
    #for line in ["turn on 0,0 through 0,0", "toggle 0,0 through 999,999"]:
        match = re.match(regex,line)
        if match:
            p1 = match.groups()[1].split(',')
            p2 = match.groups()[2].split(',')
            if match.groups()[0] == "turn on":
               state = 1
            elif match.groups()[0] == "turn off":
               state = 0
            elif match.groups()[0] == "toggle":
               state = -1
            else:
                print("This command is not readable (%s)!" % match.groups()[0])
                sys.exit(1)

            day6_changeArea(p1,p2,state,matrix,part)
        else:
            print("This line is not readable (%s)!" % line)
            sys.exit(1)
    print day6_countLights(matrix,part)
    # 377891
    # 14110788

def day7_isGate(str):
    if re.search('.*(NOT|AND|OR|LSHIFT|RSHIFT).*',str):
        return True
    else:
        return False

def day7_isWire(str,circuit):
    if str in circuit:
        return True
    else:
        return False

def day7_isSignal(str):
    if int(str):
        return True
    else:
        return False

def day7(infile,part):
    string = readFile(infile).rstrip()
    gates = string.split('\n')
    circuit = {}

    # build circuit
    for gate in gates:
        (i,o) = gate.split(' -> ')
        circuit[o] = i

    # follow output
    seq = [ 'a' ]
    while not (isinstance(seq[0],int) and len(seq) == 1):
        resolve = seq[-1]

        if day7_isWire(resolve,circuit):
            seq[-1] = circuit[resolve]
        elif day7_isGate(resolve):




workdir="/home/mlehmann/tmp/adventOfCode/"
day=int(sys.argv[1])
if (len(sys.argv) > 2):
    part=sys.argv[2]
else:
    part = 1

infile=workdir + "day%s.txt" % day
if day == 1:
    day1(infile,int(part))
elif day == 6:
    day6(infile,int(part))
elif day == 7:
    day7(infile,int(part))

