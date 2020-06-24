#! /bin/sh -x
mkdir -p static/conf
mkdir -p static/data
BASEFILES=`cd static/base; ls -1`
for f in $BASEFILES; do
    if [ ! -f static/data/$f ]; then
       echo "copy $f"
       cp static/base/$f static/data/.
    fi
done

make
python3 mdiary.py
