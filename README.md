goldrush-docker
===============

Docker container image for GoldRush development.

## install vm.

ネイティブなLinuxがない場合、ローカルマシンに仮想マシンを入れてください。64bit OSじゃないとDockerが動かないので注意！

VMware player
* https://my.vmware.com/jp/web/vmware/free#desktop_end_user_computing/vmware_player/6_0

Virtual Box
* https://www.virtualbox.org/wiki/Downloads

install 64bit ubuntu/xubuntu
* http://ubuntulinux.jp/News/ubuntu1404-ja-remix/
* http://mirror.anl.gov/pub/ubuntu-iso/CDs-Xubuntu/14.04/release/

===============

## install git/docker.io (for ubuntu)

    $ sudo apt-get update
    $ sudo apt-get install git
    $ sudo apt-get install docker.io
    $ sudo ln -sf /usr/bin/docker.io /usr/local/bin/docker
    $ sudo sed -i '$acomplete -F _docker docker' /etc/bash_completion.d/docker.io

dockerグループに自分のidを追加

    $ sudo vigr
    $ sudo vigr -s # 必要ならこちらも

ここで再ログイン or 再起動
idコマンドで、dockerグループに加入していることを確認

    uid=1000(your-id) gid=1000(your-id) groups=1000(your-id),4(adm),24(cdrom),27(sudo),30(dip),46(plugdev),108(lpadmin),124(sambashare),126(docker)

goldrush-dockerのセットアップ

    mkdir ~/git
    cd ~/git
    git clone https://github.com/goldrush/goldrush-docker.git
    cd goldrush-docker
    ./init_grdev.sh [あなたのGithubユーザー]

初期化処理が走り、ownerユーザーでプロンプトが出ます。

    cd /work/goldrush
    rails s

rails プロセスが起動します。
ブラウザーでDockerを動かしているHOSTのアドレスにアクセスします。

    例: http://192.168.0.123:13000/

ログイン画面が表示されれば成功です。

## sambaを用いた共有ファイルへのアクセス

Windowsのエクスプローラーで、Dockerを動かしているHOSTのアドレスにアクセスします。

    例: \\192.168.0.123\goldrush

共有フォルダが表示されれば成功です。

## MySQLへのアクセス

Dockerを動かしているHOSTのアドレスにアクセスします。

    例: mysql -u grdev -p -h 192.168.0.123 -P 13306 grdev


## rootでの作業

ふつうにsudoできます。ownerのpasswordは、ownerです。

## その他使い方

Dockerのプロセスは、「CTRL+P,CTRL+Q」を連続して押すことで抜けることができます(detach)。
この時、バックグラウンドでDockerプロセスは動き続けます。

こんな感じです。

     $ docker ps
     CONTAINER ID IMAGE                   COMMAND                CREATED        STATUS       NAMES
     264415ff8e61 goldrush/grdev:latest   /bin/bash -x /work/t   38 minutes ago Up 2 minutes grdev1

これは、プロセスが動いているので、railsやmysql、共有ドライブにアクセスできる状態です。
プロンプトに復帰するには、docker attachを使います。

    $ docker attach 26

26はCONTAINER IDです。重複がなければ、全て入力しなくとも動きます。

プロンプトを、CTRL+Dもしくは、exitで抜けた場合、docker containerは停止します。この際に起動していたプロセスもすべて強制終了するので気をつけてください。
復帰するには、docker startを使います。

    $ docker start -i 26

-iオプションによって、プロンプトに復帰することができます。

## goldrush-docker再初期化の注意

goldrush-dockerは、init_grdev.shを叩くことでいつでも初期化できます。但し、注意点があります。

1. 古いdocker containerは、削除すること
  1. 「docker rm [CONTAINER ID]」で削除できます。起動中のcontainerの場合は、最初に「docker stop [CONTAINER ID]」で停止してから削除してください。
1. mysqlディレクトリを削除すること
  1. goldrush-dockerの直下にできているmysqlディレクトリは、初期化するために邪魔なので削除します。「rm -rf mysql」で削除できます。


## for goldrush-docker developer

Dockerfileを編集してください。

    docker build -t goldrush/grdev .
    docker push goldrush/grdev

事前にDockerHubのgoldrushアカウントでログインする必要があります。

開発中は自分のアカウントにpushしても良いと思います。その場合、init_grdev.shの「goldrush/grdev」となっている場所を自分のアカウントに書き換えてください。




