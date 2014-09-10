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

  RUN apt-get install -y --no-install-recommends samba
  
  VOLUME ["/work/goldrush","/var/lib/mysql", "/work/tools"]
  
  EXPOSE 3000 3306 139
  
