goldruch-docker
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


    
## 問題点

* ownerにsuしてしまっているので、root権限が必要な操作はできない。

