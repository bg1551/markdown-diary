#! /usr/bin/python
from bottle import route, run, view, static_file, request
from bottle import template
from datetime import datetime
import os
import subprocess
import sys
import signal

@route('/diary/show/<targetDate>')
@view('show')
def show(targetDate):
    return dict(targetDate=targetDate)

@route('/diary/edit/<targetDate>')
@view('edit')
def edit(targetDate):
    return dict(targetDate=targetDate)

@route('/diary/filer/<pageNum>')
@view('filer')
def filer(pageNum):
    return dict(targetDate=None, pageNum=int(pageNum))

@route('/diary/filer')
@view('filer')
def filer(pageNum='1'):
    return dict(targetDate=None, pageNum=int(pageNum))

@route('/diary/')
@view('show')
def base(targetDate=None):
    return dict(targetDate=targetDate)

@route('/diary/js/<filename>')
def js_files(filename):
    return static_file(filename, root='/var/www/diary/js/')

@route('/diary/css/<filename>')
def css_files(filename):
    return static_file(filename, root='/var/www/diary/css/')

@route('/diary/data/<filename>')
def data_files(filename):
    return static_file(filename, root='/var/www/diary/data/')

@route('/diary/images/<filename>')
def image_files(filename):
    return static_file(filename, root='/var/www/diary/images/')

@route('/diary/savecheck/<filename>', method='POST')
def savecheck(filename):
    filepath = '/var/www/diary/data/' + filename
    res = "NEW"
    if os.path.exists(filepath):
        res = "UPDATE"

        f = open(filepath, "rb");
        origData = f.read()
        f.close()

        newData = request.body.getvalue()
        if origData == newData:
            res = "SAME"

    return res

@route('/diary/save/<filename>', method='POST')
def save(filename):
    #print(request.body);
    f = open('/var/www/diary/data/' + filename, "wb");
    f.write(request.body.getvalue());
    f.close()
    subprocess.call(["make"], cwd='/var/www/diary/')
    return

if __name__ == '__main__':
    signal.signal(signal.SIGTERM, signal.SIG_DFL)
    sys.path.append('/var/www/diary/conf')
    run(host='0.0.0.0', port=80)
    #run(host='0.0.0.0', port=8001, debug=True, reloader=True)
