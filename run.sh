#! /bin/sh -x
mkdir -p static/conf
mkdir -p static/data
mkdir -p static/html
BASEFILES=`cd static/base; ls -1 *.md`
for f in $BASEFILES; do
    if [ ! -f static/conf/$f ]; then
       echo "copy $f to conf/"
       cp static/base/$f static/conf/.
    fi
done
BASEFILES2=`cd static/base; ls -1 *.png`
for f in $BASEFILES; do
    if [ ! -f static/html/$f ]; then
       echo "copy $f to html/"
       cp static/base/$f static/html/.
    fi
done

make
python3 mdiary.py
