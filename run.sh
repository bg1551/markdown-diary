#! /bin/sh -x
if [ ! -d conf ]; then
    mkdir conf
fi
BASEFILES=`cd base; ls -1`
for f in $BASEFILES; do
    if [ ! -f data/$f ]; then
       echo "copy $f"
       cp base/$f data/.
    fi
done

make
python3 index.py
