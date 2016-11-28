#! /usr/bin/python
# -*- coding: utf-8 -*-
# md形式の設定ファイルからpy形式のファイルを生成する
# ファイル名チェックは行わない(システムで決まってるから)
# 引数のチェックも行わない(起動方法が固定だから)

import sys
import re

def main(argv):
    iname = sys.argv[1]
    oname = sys.argv[2]

    title = re.match(".*/([A-Za-z0-9_-]+)", iname).group(1)
    #print (title)

    data = {}

    # データを読み込む
    ifp = open(iname, "r")
    for line in ifp:
        m01 = re.match("^#", line)
        m02 = re.match("^[ \t]*$", line)
        m03 = re.match("^([A-Za-z0-9_-]+)=(.*?)[ ]*$", line)
        #print (repr(m01), repr(m02), repr(m03))
        if m01 != None:
            # コメント行なのでスキップ
            pass
        elif m02 != None:
            # 空行なのでスキップ
            pass
        elif m03 != None:
            # 設定行なので処理する
            key = m03.group(1)
            val = m03.group(2)
            data[key] = val
            #print (key + "=" + val)
    ifp.close()

    # データを書き込む
    ofp = open(oname, "w")
    ofp.write(title + "={\n")
    for k in data.keys():
        ofp.write("\"" + k + "\": \"" + data[k] +"\",\n")
    ofp.write("}\n")
    ofp.close()
    

if __name__ == '__main__':
    main(sys.argv)

