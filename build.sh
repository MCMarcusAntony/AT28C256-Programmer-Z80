#!/bin/sh
fname=$1

if [ ! -f $fname.asm ]; then
    echo "File not found!"
    exit 1
fi

fout=${fname}.com
fname=${fname}.asm

cp $fname $fname.bak

curdefine=$(cat $fname | grep "^BuildId: db")
today=$(date +%Y%m%d)
newbuild=$(cat $fname | grep "BuildId: db" | awk '{print $3}' | cut -f2 -d"."|sed 's/"//'|awk '{printf "%03d\n", $1 + 1;}')

rc=$?

if [ $rc = 0 ];then
    newdefine="BuildId: db \"$today.$newbuild\""
    cat $fname | sed "s/$curdefine/$newdefine/" > $fname.tmp && mv $fname.tmp $fname
    echo "New BuildId for $1: $today.$newbuild"
fi


~/Dev/bin/z80asm --output=${fout} ${fname}
rc=$?

if [ $rc = 0 ];then
    cp ${fout} ~/Dev/github//C_Dev/MSX_Fusion-C_V1.2/WorkingFolder/Tools/MSX-DOS/MSXDOS-103/
    git add .
    git commit -m "New BuildId for ${fname}: $today.$newbuild"
fi
