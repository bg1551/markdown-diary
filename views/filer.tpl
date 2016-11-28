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
	  bgメモ
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
	    
	    <li><a href="/diary/filer">ファイル管理</a><br></li>
	  </ul>
	</div>
      </div>
      
      <div class="col-sm-10">
	<div class="filer">
          % import os
          % import datetime
          % import sys
          % import re
          % try:
	  %   files = sorted(os.listdir("/var/www/diary/data/"))
          %   filenum = len(files)
          %   pagesize = 25
          %   showmaxpage = 10
          %   npage = int(filenum / 25) + 1
          %   if npage < showmaxpage:
          %     minpage = 0
          %     maxpage = npage
          %   else:
          %     minpage = pageNum - int(showmaxpage / 2)
          %     maxpage = pageNum + int(showmaxpage / 2)
          %     if maxpage + int(showmaxpage / 2 - 1) > npage:
          %       minpage = npage - showmaxpage
          %       maxpage = npage
          %     elif minpage - int(showmaxpage / 2 - 1) < 0:
          %       minpage = 1
          %       maxpage = minpage + showmaxpage
          %     end						  
          %   end

          %   prevpage = pageNum - int(showmaxpage / 2)
          %   nextpage = pageNum + int(showmaxpage / 2)
          %   if prevpage < 1:
          %     prevpage = 1
          %   end			    
          %   if nextpage > npage:
          %     nextpage = npage
          %   end			    

	  <nav aria-label="Page navigation">
	    <ul class="pagination pagination-sm">
	      <li class="page-item">
	        <a class="page-link" href="/diary/filer/{{prevpage}}" aria-label="Previous">
		  <span aria-hidden="true">&laquo;</span>
		  <span class="sr-only">Previous</span>
		</a>
	      </li>
	      % count = minpage - 1
	      % while count < maxpage:
	      %   if count != pageNum - 1:
	      <li class="page-item"><a class="page-link" href="/diary/filer/{{count + 1}}">{{count + 1}}</a></li>
	      %   else:
	      <li class="page-item active"><a class="page-link" href="/diary/filer/{{count + 1}}">{{count + 1}}<span class="sr-only">(current)</span></a></li>
	      %   end
	      %   count += 1
	      % end
	      <li class="page-item">
	        <a class="page-link" href="/diary/filer/{{nextpage}}" aria-label="Next">
		  <span aria-hidden="true">&raquo;</span>
		  <span class="sr-only">Next</span>
		</a>
	      </li>
            </ul>
          </nav>
	  
          <table class="table filer-table">
	    <thead>
            <tr>
	        <th class="filename">ファイル名</th>
		<th class="size">サイズ</th>
		<th class="timestamp">更新日時</th>
		<th class="action">操作</th>
	    </tr>
	    </thead>
	    <tbody>
	  %   fcount = 0
	  %   for f in files:
          %     if fcount < (pageNum - 1) * pagesize or fcount >= pageNum * pagesize:
	  %       fcount += 1
          %       continue
	  %     end
	  %     fcount += 1
          %     st = os.stat("/var/www/diary/data/" + f)
          %     t = datetime.datetime.fromtimestamp(st.st_mtime)
            <tr>
	  %     if re.match(".*\.md$", f):
	        <td class="filename"><a href="/diary/show/{{f[:-3]}}">{{f}}</a></td>
          %     else:
                <td class="filename">{{f}}</td>
	  %     end
		<td class="size">{{st.st_size}}</td>
		<td class="timestamp">{{t.strftime("%Y-%m-%d %H:%M:%S")}}</td>
		<td class="action"><a href="/diary/edit/{{f[:-3]}}">編集</a></td>
	    </tr>
          %   end
          % except:
          %   print(sys.exc_info())
          % end
	    </tbody>
          </table>
	</div>
      </div>
    </div>
  </div>

<!--
  <div class="hidden">
    <button class="btn btn-primary" data-toggle="modal" data-target="#deleteModal" id="dummyButton">
      モーダルダイアログ用
    </button>
  </div>

  <div class="modal" id="deleteModal" tabindex="-1">
    <div class="modal-dialog modal-sm">
      <div class="modal-content">
	<div class="modal-header">
	  <button type="button" class="close" data-dismiss="modal">
	    <span aria-hidden="true">&times;</span>
	  </button>
	  <h4 class="modal-title" id="modal-label">削除確認</h4>
	</div>
	<div class="modal-body">
	  ファイルを削除してよろしいですか？
	</div>
	<div class="modal-footer">
	  <button type="button" class="btn btn-default" data-dismiss="modal">やめる</button>
	  <button type="button" class="btn btn-primary">削除する</button>
	</div>
      </div>
    </div>
  </div>
-->

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

