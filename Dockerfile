FROM ubuntu:latest

  ENV DEBIAN_FRONTEND noninteractive
  RUN apt-get update
  
  RUN apt-get install -y --no-install-recommends build-essential curl git
  RUN apt-get install -y --no-install-recommends zlib1g-dev libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt-dev libmysqlclient-dev ruby-dev imagemagick libmagickcore-dev libmagickwand-dev subversion mysql-server mysql-client libmysqlclient-dev
  RUN apt-get install -y --no-install-recommends mysql-server && service mysql stop
  RUN apt-get clean

  RUN git clone https://github.com/sstephenson/rbenv.git /root/.rbenv
  RUN git clone https://github.com/sstephenson/ruby-build.git /root/.rbenv/plugins/ruby-build
  RUN ./root/.rbenv/plugins/ruby-build/install.sh
  ENV PATH /root/.rbenv/bin:$PATH
  RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh # or /etc/profile
  
  RUN RUBY_CONFIGURE_OPTS="--with-readline-dir=/usr --with-openssl-dir=/usr/bin" rbenv install 1.9.3-p547
  RUN rbenv global 1.9.3-p547
  RUN rbenv rehash
  
  RUN echo 'gem: --no-rdoc --no-ri' >> /.gemrc
  RUN gem install mysql2 -v '0.3.11'
  RUN gem install bundler
  RUN gem install rmagick --no-rdoc --no-ri
  RUN mkdir -p /work/goldrush
  RUN mkdir -p /work/sql
  RUN cd /work && git clone -b develop https://github.com/goldrush/goldrush.git
  RUN cd /work/goldrush && bundle install

  RUN service mysql start && echo "grant all privileges on *.* to root;" | mysql -u root && service mysql stop

  RUN sed -i -e "s/bind-address/#bind-address/g" -e "s/= mysql/= owner/g" /etc/mysql/my.cnf

# checkout the private repository by readonly user.
#  RUN svn co --non-interactive --no-auth-cache --username docker --password docker99  https://svn.applicative.jp/svn/projects/Applicative/GoldRush/develop/sql/
  
#  RUN echo "#!/bin/bash\n\ngroupadd -g \$OWNER_GID owner\nif [[ \$? -ne 9 ]];then\nuseradd -d /work/goldrush -u \$OWNER_UID -g owner owner\nchown owner -R /var/run/mysqld /var/log/mysql*\nservice mysql start\ncd /work/sql\nmysql -u root < CreateDatabase.SQL && mysql -u grdev -p grdev --password=grdev < InitData.SQL\ncp /work/goldrush/config/database.yml{.org,}\ncd /work/goldrush\nbundle install\nrake db:fixtures:load FIXTURES_PATH=fixtures/develop\nfi\n/bin/bash" > /init.sh
#  RUN chmod 755 /init.sh

#  RUN cd work && git clone https://github.com/jomjomni/goldrush.git
#  RUN cd work/goldrush && bundle install
#  RUN cp work/goldrush/config/database.yml.org work/goldrush/config/database.yml
  
#  RUN /etc/init.d/mysql start && cd sql && mysql -u root < CreateDatabase.SQL && mysql -u grdev -p grdev --password=grdev < InitData.SQL && cd ~/work/goldrush && rake db:fixtures:load FIXTURES_PATH=fixtures/develop

  RUN apt-get install -y --no-install-recommends samba
  
  VOLUME ["/work/goldrush","/var/lib/mysql", "/work/tools"]
  
  EXPOSE 3000 3306 139
  
