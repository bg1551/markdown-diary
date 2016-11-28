% import calendar
% year = date.year
% month = date.month
% day = date.day
% calendar.setfirstweekday(calendar.SUNDAY)
% cal = calendar.monthcalendar(year, month)
% today = datetime.now()

% TARGETDIR='/var/www/diary/html'
% list = []
% import glob;
% import re;
% files = glob.glob(TARGETDIR + '/????-??-??.html')
% targetfilename = "(%(y)04d-%(m)02d-\d{2})\\.html" % {"y": date.year, "m": date.month}
% for file in files:
%   try:
%     list.append(re.search(targetfilename, file).group(1))
%   except:
%     pass
%   end
% end

% import importlib
% import holidays
% importlib.reload(holidays)
% import privates
% importlib.reload(privates)

% if main == True:
<table class="table table-condensed2 table-bordered calendar this_month">
% else:
<table class="table table-condensed2 table-bordered calendar">
% end
  <thead>
  <tr>
    <th colspan="7">{{year}}/{{month}}</th>
  </tr>
  <tr>
    <th class="sun">日</th>
    <th>月</th>
    <th>火</th>
    <th>水</th>
    <th>木</th>
    <th>金</th>
    <th class="sat">土</th>
  </tr>  
  </thead>
  <tbody>
  % for w in cal:
  %   wd = 0
  <tr>
  % tstr = "%(y)04d-%(m)02d-%(d)02d" % {"y": tdate.year, "m": tdate.month, "d": tdate.day}
  %   for d in w:

    % dstr = "%(y)04d-%(m)02d-%(d)02d" % {"y": year, "m": month, "d": d}
    % target = ""
    % if dstr == tstr:
    %   target = " targetDay"
    % end

    % hasDiary = ""
    % if dstr in list:
    %   hasDiary = " hasDiary"
    % end

    % todayStyle = ""
    % if year == today.year and month == today.month and d == today.day:
    %   todayStyle=" today"
    % end

    % if d > 0 and wd == 0:
  <td class="sun{{target}}{{hasDiary}}{{todayStyle}}"><a href="/diary/{{mode}}/{{dstr}}">{{d}}</a></td>
    % elif d > 0 and wd == 6:
  <td class="sat{{target}}{{hasDiary}}{{todayStyle}}"><a href="/diary/{{mode}}/{{dstr}}">{{d}}</a></td>
    % elif d > 0 and dstr in holidays.holidays:
  <td class="holiday{{target}}{{hasDiary}}{{todayStyle}}"><a href="/diary/{{mode}}/{{dstr}}">{{d}}<span class="popup">{{holidays.holidays[dstr]}}</span></a></td>
    % elif d > 0 and dstr in privates.privates:
  <td class="private{{target}}{{hasDiary}}{{todayStyle}}"><a href="/diary/{{mode}}/{{dstr}}">{{d}}<span class="popup">{{privates.privates[dstr]}}</span></a></td>
    % elif d > 0:
  <td class="{{target}}{{hasDiary}}{{todayStyle}}"><a href="/diary/{{mode}}/{{dstr}}">{{d}}</a></td>
    % else:
  <td class="noday">&nbsp;</td>
    % end
  %     wd += 1
  %   end
  </tr>
  % end
  </tbody>
</table>
