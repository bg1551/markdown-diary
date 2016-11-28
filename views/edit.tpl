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
  <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/highlight.js/9.7.0/styles/default.min.css">
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
	  <a href="/diary/edit/{{pmonth}}">前月</a>/<a href="/diary/edit/{{todayStr}}">今日</a>/<a href="/diary/edit/{{nmonth}}">次月</a>
	</div>
	
	<div class="row">
	  % include('calendar.tpl', date=prevMonth, main=False, mode="edit")
	</div>
	<div class="row">
	  % include('calendar.tpl', date=tdate, main=True, mode="edit")
	</div>
	<div class="row">
	  % include('calendar.tpl', date=nextMonth, main=False, mode="edit")
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
	    <td><a href="/diary/edit/{{pday}}">←前の日</a></td>
	    <td><a href="/diary/show/{{targetDate}}">参照</a></td>
	    <td><a href="/diary/edit/{{nday}}">次の日→</a></td>
	  </tr>
	</table>
	<div class="diary_main">
          <h1 id="targetDate">{{targetDate}}</h1>
	  <ul class="nav nav-tabs">
	    <li class="active"><a href="#tab1" data-toggle="tab" id="tabselect1">編集</a></li>
	    <li><a href="#tab2" data-toggle="tab" id="tabselect2">表示</a></li>
	    <!--
	    <li>
	      <a>ベースとするページ
		<select name="test">
		  <option value="a">A</option>
		  <option value="b">B</option>
		</select>
		<input type="button" value="読み込み"></input>
	      </a>
	      
	    </li>
	    -->
	  </ul>
	  <div id="myTabContent" class="tab-content">
	    <div class="tab-pane fade in active" id="tab1">
	      <div id="editor" style="height: 400px;">\\
		% try:
		%   include('data/' + targetDate + '.md')
		% except:
		%   pass
		% end
	      </div>
	    </div>
	    <div class="tab-pane fade" id="tab2">
	      <div id="view">
		% try:
		%   include('html/' + targetDate + '.html')
		% except:
		%   pass
		% end
	      </div>
	    </div>
	  </div>
	  <div class="contoller">
	    <button type="button" id="saveButton" class="btn btn-default">保存</button>
	    <span id="log"></span>
	  </div>
	</div>
      </div>
    </div>
  </div>


  <div class="hidden">
    <button class="btn btn-primary" data-toggle="modal" data-target="#updateModal" id="dummyButton">
      モーダルダイアログ用
    </button>
    <div id="savecheckresult"></div>
  </div>

  <div class="modal" id="updateModal" tabindex="-1">
    <div class="modal-dialog modal-sm">
      <div class="modal-content">
	<div class="modal-header">
	  <button type="button" class="close" data-dismiss="modal">
	    <span aria-hidden="true">&times;</span>
	  </button>
	  <h4 class="modal-title" id="modal-label">更新確認</h4>
	</div>
	<div class="modal-body">
	  ファイルがすでに存在します。<br>
	  更新しますか？
	</div>
	<div class="modal-footer">
	  <button type="button" class="btn btn-default" data-dismiss="modal">やめる</button>
	  <button type="button" class="btn btn-primary">更新する</button>
	</div>
      </div>
    </div>
  </div>


  <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
  <script src="js/bootstrap.min.js"></script>
  <script src="js/marked.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/ace/1.2.5/ace.js" type="text/javascript" charset="utf-8"></script>
  <script>
    var baseText = "";
    var targetDate = "{{targetDate}}";
    var editor = ace.edit("editor");
    //document.getElementById('editor').style.fontSize='14px';
    editor.setTheme("ace/theme/dreamweaver");
    editor.setOption("showInvisibles", true);
    editor.setOption("fontFamily", "MeiryoKe_Gothic,MS ゴシック");
    //editor.setOption("fontFamily", "monospace");
    //editor.setOption("fontFamily", "MeiryoKe_Gothic");
    //editor.setOption("fontFamily", "MyricaM Monospace");
    editor.getSession().setMode("ace/mode/markdown");
    editor.getSession().setUseSoftTabs(true);
    editor.getSession().setTabSize(2);

    $("#tabselect2").click(function() {
      var target = $("#view");
      target.html(marked(editor.getValue()));
    });

    $('#saveButton').click(function() {
      var filename = $("#targetDate").text();
    var saveMd = editor.getValue();
      $("#log").text("更新確認中...");
      $.post('/diary/savecheck/' + targetDate + '.md', saveMd, 
        function(data){
          $("#savecheckresult").text(data);
          if (data == 'UPDATE' || data == 'DELETE') {
            $("#dummyButton").click();
          } else {
            $("#log").text("処理中...");
            var msg = "更新なし";
            if (data == "UPDATE") { msg = "更新あり"; } else if (data == "NEW") { msg = "新規保存"; } else if (data == "DELETE") { msg = "削除";}
            $.post('/diary/save/' + targetDate + '.md', saveMd, function(data){$("#log").text("処理終了(" + msg + ")");});
            baseText = saveMd;
          }
        }
      );
    });

    $('#updateModal').on('click', '.modal-footer .btn-primary', function() {
      $('#updateModal').modal('hide');
      var saveMd = editor.getValue();
      $("#log").text("処理中...");
      var msg = "更新なし";
      var data2 = $("#savecheckresult").text();
      if (data2 == "UPDATE") { msg = "更新あり"; } else if (data2 == "NEW") { msg = "新規保存"; } else if (data2 == "DELETE") { msg = "削除";}
      $.post('/diary/save/' + targetDate + '.md', saveMd, function(data){$("#log").text("処理終了(" + msg + ")");});
      baseText = saveMd;
    });

    $(document).ready(function(){
      $.ajax({
        url:'/diary/data/' + targetDate + '.md',
      }).success(function(data){
        editor.setValue(data);
        editor.clearSelection();
        baseText = data;
      }).error(function(data){
        editor.setValue("no data");
        editor.clearSelection();
        baseText = editor.getValue();
      });

      $('#goButton').click(function(){
        var d = $('#goDate').val();
        location.href = '/diary/edit/' + d;
      })
    });

    $(function(){
    $(window).on('beforeunload', function(){
    if (baseText != editor.getValue()) {
    return '保存せずに移動してもいいですか？';
    }
    });
    });
  </script>
</body>
</html>
 
