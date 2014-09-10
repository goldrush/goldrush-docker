#!/bin/bash

if [[ $1 ]];then
  GITHUB_USER=$1
else
  echo "please argment your github user or 'goldrush'"
  exit 1
fi

if [[ -d mysql ]];then
  echo "mysql dir exists. remove and retry it."
  exit 1
fi

if [[ -d goldrush ]];then
  (cd goldrush;git pull)
else
  git clone -b develop https://github.com/$GITHUB_USER/goldrush.git
  if [[ $? -ne 0 ]];then
    echo "git clone faild. check user $GITHUB_USER"
    exit 1
  fi
fi

if [[ -d sql ]];then
  svn up sql
else
  svn co --non-interactive --no-auth-cache --username docker --password docker99  https://svn.applicative.jp/svn/projects/Applicative/GoldRush/develop/sql/
fi

#docker pull goldrush/grdev
docker run -it -d --name grdev1 goldrush/grdev /bin/bash
docker stop grdev1
docker cp grdev1:/var/lib/mysql .
docker rm grdev1
docker run -it -d --name grdev1 -e OWNER_UID=`id -u` -e OWNER_GID=`id -g`  -v `pwd`/mysql:/var/lib/mysql -v `pwd`/goldrush:/work/goldrush -v `pwd`/sql:/work/sql -p 13000:3000 -p 13306:3306 goldrush/grdev /bin/bash -x /init.sh
docker attach grdev1

