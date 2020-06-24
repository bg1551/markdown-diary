#!/usr/bin/python
# -*- coding: utf-8 -*-
import os
import sys
import time
import subprocess
import datetime
import calendar
import tornado.ioloop
import tornado.web
import tornado.options
import tornado.locks
import tornado.template
import difflib

from logging import basicConfig, getLogger, DEBUG

import importlib

TOPDIR  = "/opt/mdiary"
HTMLDIR = TOPDIR + "/static/html"
DATADIR = TOPDIR + "/static/data"

class Application(tornado.web.Application):
    logger = getLogger(__name__)
    def __init__(self):
        handlers = [
            (r"/diary/", ShowHandler),
            (r"/diary/show/(.+)", ShowHandler),
            (r"/diary/edit/(.+)", EditHandler),
        ]
        settings = dict(
            template_path=os.path.join(os.path.join(os.path.dirname(__file__), "templates")),
            static_path=os.path.join(os.path.join(os.path.dirname(__file__), "static")),
            static_url_prefix="/diary/static/",
            debug=True,
            )
        super(Application, self).__init__(handlers, **settings)

def createDateParams(target):
    today = datetime.date.today()
    todayStr = today.strftime('%4Y-%2m-%2d')

    try:
        targetDate = datetime.datetime.strptime(target, '%Y-%m-%d')
    except:
        targetDate = today

    prevMonth = datetime.date.fromtimestamp(time.mktime((targetDate.year, targetDate.month - 1, 1, 0, 0, 0, 0, 0, 0)))
    nextMonth = datetime.date.fromtimestamp(time.mktime((targetDate.year, targetDate.month + 1, 1, 0, 0, 0, 0, 0, 0)))
    centerMonth = datetime.date.fromtimestamp(time.mktime((targetDate.year, targetDate.month, 1, 0, 0, 0, 0, 0, 0)))
    prevMonthStr = prevMonth.strftime('%4Y-%2m-%2d')
    nextMonthStr = nextMonth.strftime('%4Y-%2m-%2d')
    centerMonthStr = centerMonth.strftime('%4Y-%2m-%2d')

    prevDay = datetime.date.fromtimestamp(time.mktime((targetDate.year, targetDate.month, targetDate.day - 1, 0, 0, 0, 0, 0, 0)))
    nextDay = datetime.date.fromtimestamp(time.mktime((targetDate.year, targetDate.month, targetDate.day + 1, 0, 0, 0, 0, 0, 0)))
    centerDay = datetime.date.fromtimestamp(time.mktime((targetDate.year, targetDate.month, targetDate.day, 0, 0, 0, 0, 0, 0)))
    prevDayStr = prevDay.strftime('%4Y-%2m-%2d')
    nextDayStr = nextDay.strftime('%4Y-%2m-%2d')
    centerDayStr = centerDay.strftime('%4Y-%2m-%2d')

    
    dateParams = {}
    dateParams["target"] = target
    dateParams["targetDate"] = targetDate
    
    dateParams["today"] = today
    dateParams["todayStr"] = todayStr
    dateParams["prevMonth"] = prevMonth
    dateParams["nextMonth"] = nextMonth
    dateParams["prevMonthStr"] = prevMonthStr
    dateParams["nextMonthStr"] = nextMonthStr
    dateParams["prevDay"] = prevDay
    dateParams["nextDay"] = nextDay
    dateParams["prevDayStr"] = prevDayStr
    dateParams["nextDayStr"] = nextDayStr

    dateParams["centerMonthYear"] = targetDate.year
    dateParams["centerMonthMonth"] = targetDate.month
    dateParams["prevMonthYear"] = prevMonth.year
    dateParams["prevMonthMonth"] = prevMonth.month
    dateParams["targetMonthYear"] = today.year
    dateParams["targetMonthMonth"] = today.month
    dateParams["nextMonthYear"] = nextMonth.year
    dateParams["nextMonthMonth"] = nextMonth.month

    calendar.setfirstweekday(calendar.SUNDAY)
    prevCal = calendar.monthcalendar(prevMonth.year, prevMonth.month)
    centerCal = calendar.monthcalendar(centerMonth.year, centerMonth.month)
    targetCal = calendar.monthcalendar(today.year, today.month)
    nextCal = calendar.monthcalendar(nextMonth.year, nextMonth.month)
    dateParams["prevCal"] = prevCal
    dateParams["targetCal"] = targetCal
    dateParams["nextCal"] = nextCal
    dateParams["centerCal"] = centerCal

    return dateParams

def checkDiaries(startDay):
    hasDiaries = []
    d = startDay
    #while startDay.month == d.month:
    for i in range(100):
        dstr = "{:04d}-{:02d}-{:02d}".format(d.year, d.month, d.day)
        #print(HTMLDIR + "/" + dstr + ".html")
        if os.path.exists(HTMLDIR + "/" + dstr + ".html"):
            hasDiaries.append(dstr)
        d += datetime.timedelta(days=1)
    return hasDiaries
    
class ShowHandler(tornado.web.RequestHandler):
    def get(self, target = None):
        if target == None:
            target = datetime.date.today().strftime('%4Y-%2m-%2d')
        importlib.reload(config)
        args = config.config.copy()
        args.update(createDateParams(target))
        args["hasDiaries"] = checkDiaries(datetime.date(args["prevMonth"].year, args["prevMonth"].month, 1))
        importlib.reload(holidays)
        args["holidays"] = holidays.holidays
        importlib.reload(privates)
        args["privates"] = privates.privates
        args["target"] = target
        args["mode"] = "show"
        targetHtml = readFile(HTMLDIR + "/" + target + ".html")
        args["targetHtml"] = targetHtml
        self.render("show.html", **args)

class EditHandler(tornado.web.RequestHandler):
    def get(self, target = None):
        if target == None:
            target = datetime.date.today().strftime('%4Y-%2m-%2d')
        importlib.reload(config)
        args = config.config.copy()
        args.update(createDateParams(target))
        args["hasDiaries"] = checkDiaries(datetime.date(args["prevMonth"].year, args["prevMonth"].month, 1))
        importlib.reload(holidays)
        args["holidays"] = holidays.holidays
        importlib.reload(privates)
        args["privates"] = privates.privates
        args["target"] = target
        args["mode"] = "edit"
        #targetHtml = readFile(HTMLDIR + "/" + target + ".html")
        #args["targetHtml"] = targetHtml
        #targetMd = readFile(DATADIR + "/" + target + ".md")
        #args["targetMd"] = targetMd
        args["targetHtml"] = ""
        args["targetMd"] = ""
        self.render("edit.html", **args)

    def do_check(self, target):
        filepath = DATADIR + "/" + target + ".md"
        res = "NEW"
        if os.path.exists(filepath):
            res = "UPDATE"
            f = open(filepath, "rb")
            origData = f.read()
            f.close()

            newData = self.request.body

            if origData == newData:
                res = "SAME"
            elif newData == b'':
                res = "DELETE"
            else:
                s1 = origData.decode('utf-8').splitlines(keepends = True)
                s2 = newData.decode('utf-8').splitlines(keepends = True)
                difflines = difflib.unified_diff(s1, s2, fromfile='prev', tofile='post')
                res = "UPDATE\n"
                for s in difflines:
                    res += s
        self.write(res)
        self.finish()

    def do_save(self, target):
        filepath1 = DATADIR + "/" + target + ".md"
        filepath2 = HTMLDIR + "/" + target + ".html"
        val = self.request.body
        if val != b'':
            f = open(filepath1, "wb")
            f.write(val)
            f.close()
        else:
            os.rename(filepath1, filepath1 + ".DEL")
            os.rename(filepath2, filepath2 + ".DEL")
        subprocess.call(["make"], cwd=TOPDIR)
            
    def post(self, target):
        check = self.get_argument("check", "false")
        if check == "true":
            self.do_check(target)
        else:
            self.do_save(target)
        
def readFile(filename):
    data = ""
    try:
        f = open(filename, "r")
        data = f.read()
        f.close()
    except:
        data = ""
    return data
        
async def main():
    tornado.options.parse_command_line()
    app = Application()
    app.listen(8001)
    shutdown_event = tornado.locks.Event()
    await shutdown_event.wait()
        
if __name__ == "__main__":
    basicConfig(level = DEBUG, format='%(asctime)s [%(levelname)s] %(module)s | %(message)s', datefmt='%Y-%m-%d %H:%M:%S')
    sys.path.append('/opt/mdiary/static/conf')
    import config
    import holidays
    import privates
    logger = getLogger(__name__)
    logger.info("START: Markdown-Diary Server")
    tornado.ioloop.IOLoop.current().run_sync(main)

