goldruch-docker
===============
install vmware
VMware player
https://my.vmware.com/jp/web/vmware/free#desktop_end_user_computing/vmware_player/6_0
Virtual Box
https://www.virtualbox.org/wiki/Downloads

install 64bit ubuntu/xubuntu
http://ubuntulinux.jp/News/ubuntu1404-ja-remix/
http://mirror.anl.gov/pub/ubuntu-iso/CDs-Xubuntu/14.04/release/

===============
install git/docker.io
sudo apt-get update
sudo apt-get install git
sudo apt-get install docker.io

mkdir ~/work
cd ~/work
git clone https://github.com/jomjomni/goldrush-docker.git
cd goldrush-docker

docker build . -t goldrush
docker run -i -t -p 80:3000 -d goldrush /bin/bash
docker cp :/work/goldrush ~/work/
docker attach goldrush

===============
/etc/init.d/mysql start
cd /work/goldrush
rails s

===============
ブラウザでlocalhostにアクセスする。

問題点
・svnのログイン情報とgithubの情報が汎用的に操作できない。DockerFileに環境変数を盛り込む方法がないのかどうか。
・Dockerにattach後mysqlを立ち上げないといけない。
