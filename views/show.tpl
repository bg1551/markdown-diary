<!DOCTYPE html>

% import importlib
% import config
% importlib.reload(config)

<html lang="ja">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, inital-scale=1">
  <title>{{config.config['title']}}</title>
  <base href="/diary/">
  <link href="css/bootstrap.min.css" rel="stylesheet">
  <meta name="description" content="{{config.config['description']}}">
  <link href="css/style.css" rel="stylesheet">
  <link rel="icon" href="/diary/{{config.config['favicon']}}" type="image/png"/>
</head>
<body>
  <div class="container">
    <div class="row">
      <div class="col-sm-12" style="background: url(/diary/{{config.config['header']}}) no-repeat 50% 50%;">
	<h1 class="title" style="height: 150px; background-color: Transparent; ">
	  {{config.config['title']}}
	</h1>
      </div>

      <div class="col-sm-2">
	<div class="form-group">
	  <label for="goDate">ページ名
	    <input type="text" class="form-control" id="goDate">
	    <input type="button" value="移動" id="goButton">
	  </label>
	</div>
	
	% from datetime import datetime
	% import time
	% todayStr = datetime.now().strftime('%4Y-%2m-%2d')
	% if targetDate == None:
	%   targetDate = todayStr
	% end
	% try:
	%   tdate = datetime.strptime(targetDate, '%Y-%m-%d')
	% except:
	%   tdate = datetime.strptime(todayStr, '%Y-%m-%d')
	% end
	% prevMonth = datetime.fromtimestamp(time.mktime((tdate.year, tdate.month - 1, 1, 0, 0, 0, 0, 0, 0)))
	% pmonth = datetime.strftime(prevMonth, '%Y-%m-%d')
	% nextMonth = datetime.fromtimestamp(time.mktime((tdate.year, tdate.month + 1, 1, 0, 0, 0, 0, 0, 0)))
	% nmonth = datetime.strftime(nextMonth, '%Y-%m-%d')
	% prevDay = datetime.fromtimestamp(time.mktime((tdate.year, tdate.month, tdate.day - 1, 0, 0, 0, 0, 0, 0)))
	% pday = datetime.strftime(prevDay, '%Y-%m-%d')
	% nextDay = datetime.fromtimestamp(time.mktime((tdate.year, tdate.month, tdate.day + 1, 0, 0, 0, 0, 0, 0)))
	% nday = datetime.strftime(nextDay, '%Y-%m-%d')

	<div class="links">
	  <a href="/diary/show/{{pmonth}}">前月</a>
	  /
	  <a href="/diary/">今日</a>
	  /
	  <a href="/diary/show/{{nmonth}}">次月</a>
	</div>
	
	<div class="row">
	  % include('calendar.tpl', date=prevMonth, main=False, mode="show")
	</div>
	<div class="row">
	  % include('calendar.tpl', date=tdate, main=True, mode="show")
	</div>
	<div class="row">
	  % include('calendar.tpl', date=nextMonth, main=False, mode="show")
	</div>

	<div class="conf">
	  <ul>
	    <li><a href="/diary/edit/config">基本設定</a><br></li>
	    <li><a href="/diary/edit/holidays">祝日設定</a><br></li>
	    <li><a href="/diary/edit/privates">特殊日設定</a><br></li>
	  </ul>
	</div>
      </div>
      
      <div class="col-sm-10">
	<table class="table">
	  <tr>
	    <td><a href="/diary/show/{{pday}}">←前の日</a></td>
	    <td><a href="/diary/edit/{{targetDate}}">編集</a></td>
	    <td><a href="/diary/show/{{nday}}">次の日→</a></td>
	  </tr>
	</table>
        <h1>{{targetDate}}</h1>
	<div class="diary_main">
          % try:
	  %   include('html/' + targetDate + '.html')
          % except:
          日記未作成?
          % end
	</div>
      </div>
    </div>
  </div>

  <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
  <script src="js/bootstrap.min.js"></script>
  <script>
    $(document).ready(function(){
      $('#goButton').click(function(){
        var d = $('#goDate').val();
        location.href = '/diary/show/' + d;
      })
    });
  </script>
</body>
</html>

