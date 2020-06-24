#! /bin/sh -x
cd $(dirname $0)
mkdir -p static/conf
mkdir -p static/data
mkdir -p static/html
BASEFILES=`cd static/base; ls -1`
for f in $BASEFILES; do
    if [ ! -f static/data/$f ]; then
       echo "copy $f to data/"
       cp static/base/$f static/data/.
    fi
done

make

PYTHONPATH=./static/conf; export PYTHONPATH
python3 mdiary.py
