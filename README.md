markdown-diary
==============

bottle.pyを使用した日記管理ツールです。  
以下のような感じで起動してください。

```
% DATADIR=<データを置くディレクトリ>
% mkdir -p ${DATADIR}/data
% docker run -p 8888:80 --volume=${DATADIR}/data:/var/www/diary/data --volume=${DATADIR}/html:/var/www/diary/html --rm --name mdiary bg1551/markdown-diary:latest
```

このままだと誰でもアクセスできてしまうので、8888ポートへのアクセスはnginx等を使って、SSLのリバースプロキシを
構築して使ってください。認証はベーシック認証あたりで…

nginx用のリバースプロキシ設定例です。  
ドメイン名・SSL認証・ベーシック認証用パスワードの設定はファイルを用意した上で
適当に直してください。。。  

```
server {
    listen 443 ssl;
    server_name XXX.XXX.XXX;
    ssl on;
    ssl_certificate /xxx/fullchain.pem;
    ssl_certificate_key /xxx/privkey.pem;
    ssl_session_timeout 5m;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers 'EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH';
    ssl_prefer_server_ciphers on;
    ssl_session_cache shared:SSL:10m;

    location /diary {
        auth_basic "Login";
        auth_basic_user_file /etc/xxx/htpasswd;
        gzip off;
        proxy_set_header X-Forwarded-Ssl on;
        client_max_body_size 50M;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $http_host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
        proxy_set_header X-Frame-Options SAMEORIGIN;
        proxy_pass http://127.0.0.1:8888;
    }																				}
```


システム構成
============

開発時は以下の構成で作ってます。  
運用時は…

開発時
------

+   python3
+   bottle.py
+   Node.js
+   marked
+   pandoc


機能仕様
========

このシステムで提供する機能の説明になります。  

機能一覧
--------

持っている機能一覧を記載します。  

+   日記参照
    +   タイトル表示機能
    +   カレンダー表示機能(参照)
	+   日記参照機能
	+   日付移動機能(参照)
	+   編集遷移機能

+   日記編集
    +   タイトル表示機能
    +   カレンダー表示機能(編集)
	+   日記編集機能
	+   日付移動機能(編集)
	+   参照遷移機能


以下については機能を持っていません。HTTPデーモン(nginxなど)でなんとかしてください。

+   ログイン認証

機能詳細
--------

### 日記参照機能

作成した日記を参照する日記参照画面に関する機能です。この画面では以下の機能を提供します。

+   タイトル表示機能  
    日記のタイトルをテキスト表示します。  
    また、タイトルとかぶせてタイトルバック画像を表示します。
    タイトル文字列、タイトルバック画像は設定ファイルで設定可能です。(TBD)
	
+   カレンダー表示機能(参照)  
    指定日の前後3ヶ月分のカレンダーを表示します。  
    対象日が日付でない場合は今日を中心に表示します。  
    カレンダーの日付をクリックすると当該日の日付の日記参照画面に移動します。  
	
+   日記参照機能  
    対象日の日記を表示します。  
    対象日が日付でない場合はそのファイル名のファイルを表示します。  

+   日付移動機能  
    以下の日付移動機能を提供します。  
    ページ移動用の入力エリアに日付以外を入れることもできます。その場合は、その名前のページが表示されます。  
    参照画面から日付移動をした場合は指定した日付の参照画面に移動します。
    設定ファイル(config.md)、祝日ファイル(holidays.md)、特殊日ファイル(privates.md)についてはカレンダーの下に
    リンクを置いてあります。

        +   ページ移動用のラベル/入力エリア/ボタン  
        +   前月への移動リンク
        +   今日への移動リンク
        +   次月への移動リンク
        +   前の日への移動リンク
        +   次の日への移動リンク


+   編集遷移機能  
    現在表示している日記の編集画面に移動します。  
	

### 日記編集機能

指定された日付の日記を編集する日記編集画面に関する機能です。この画面では以下の機能を提供します。

+   タイトル表示機能  
    日記参照機能のタイトル表示機能と同じです。

+   カレンダー表示機能(編集)  
    日記参照機能のカレンダー表示機能(参照)とほぼ同じですが、日付をクリックしたときに
    遷移する画面が、日記参照画面ではなく、日記編集画面になります。
	
+   日記編集機能  
    日記を編集する機能です。タブを切り替えることで、HTML化したファイルのプレビューを
    表示することも可能です。  
    <!---(未実装)
    ベースとするページを選択し、読み込みボタンを押すことで、編集中のデータを選択したページの先頭に
    追記することができます。  
    ベースとするページには、「テンプレート」で始まるページと、最近更新されたページ5つが表示されます。  
    -->
    保存ボタンを押すことで、ページを保存することができます。  
    保存時に、すでにファイルが存在する場合は上書きを確認するダイアログが表示されます。また、別名保存を
    選択することもできます。別名保存を選択したときはファイル名を指定し、保存ボタン押下に戻ります。  

+   日付移動機能(編集)  
    日記編集機能の日付移動機能(参照)とほぼ同じですが、移動時に遷移する画面が、
    日記参照画面ではなく、日記編集画面になります。

+   参照遷移機能  
    現在表示している日記の参照画面に移動します。
