markdown-diary
==============
Bootstrap4/jQuery/tornadoを使用して作成したmarkdown形式の日記管理ツールです。

*   インストール手順例(通常の手順)
    *   はじめに
        *   ubuntu20.04でのインストール手順例になります。
        *   nginxを利用したリーバスプロキシを使います。
	*   この例ではletsencryptによりpemファイルを利用しています。
	*   ここでは初期アカウントのubuntuのホームディレクトリにインストールします。

    *   ミドルウェアのインストール
    	*   python3/pip3/tornado/pandoc/nginx/htpasswdをインストールします。
            ```
            % sudo apt install python3 python3-pip -y
            % sudo pip3 install tornado -y
            % sudo apt install pandoc -y
            % sudo apt install nginx apache2-utils -y
            ```

    *   ファイルのダウンロード
        ```
        % cd ~
        % git clone https://github.com/bg1551/markdown-diary.git
        ```

    *   起動確認
        ```
        % cd ~/markdown-diary
        % ./run.sh
        ```

    *   ブラウザから接続確認
        *   8001ポートに外部からアクセスできるように設定
        *   以下のURLにブラウザから接続
            http://<サーバのIPアドレス>:8001/diary/
	*   表示できるようであればポートを閉塞

    *   SSL化・基本認証追加
        *   htpasswdファイルを作成
            ```
            $ cd /etc/nginx
            $ sudo htpasswd -c -b htpasswd <ユーザ名> <パスワード>
            ```
        *   nginxの以下のファイルを変更(ドメイン名は正しいものに設定)
	    /etc/nginx/site-available/default
            ```
            server {
              listen 443 ssl;
              server_name test.example.com;
              ssl on;
              ssl_certificate /etc/letsencrypt/live/test.example.com/fullchain.pem;
              ssl_certificate_key /etc/letsencrypt/live/test.example.com/privkey.pem;
              proxy_set_header X-Forwarded-For $remote_addr;
              location /diary {
                auth_basic "Login";
            	auth_basic_user_file /etc/nginx/htpasswd;
                proxy_pass http://127.0.0.1:8001;
              }
            }
            ```
    *   サービス化
        *   起動をsystemctlで制御するようにするために設定ファイルを作成します
	    ファイル名：/usr/lib/systemd/system/multi-user.target.wants/markdown-diary.service
            ```
            [Unit]
            Description = Markdown Diary Service
            ConditionPathExists = /home/ubuntu/markdown-diary
            After=network.target
            
            [Service]
            Type = simple
            ExecStart = /home/ubuntu/markdown-diary/run.sh
            Restart = always
            User = ubuntu
            Group = ubuntu
            
            [Install]
            WantedBy = multi-user.target
            ```

*   インストール手順例(dockerを利用)
    *   はじめに
        *   docker-compose/dockerがインストールされている必要があります。
	*   リバースプロキシの設定は通常の手順とほぼ同様なので省略します。
	*   カレントディレクトリに作成される"mydata"ディレクトリに作成されたmd形式のファイルが
	    保存されます。このディレクトリにユーザが作成したファイルはすべて入っていますので、
	    バックアップを取ったり、サーバ移設する際とかにはこのディレクトリだけ
	    持って行ってください。

    *   ファイルのダウンロード
        ```
        % cd ~
        % git clone https://github.com/bg1551/markdown-diary.git
	```

    *   実行
        ```
	% sudo docker-compose up -d
	```

    *   ブラウザから接続確認
        *   8001ポートに外部からアクセスできるように設定
        *   以下のURLにブラウザから接続
            http://<サーバのIPアドレス>:8001/diary/
	*   表示できるようであればポートを閉塞
