FROM ubuntu:latest

  RUN apt-get update
  
  RUN apt-get install -y --force-yes build-essential curl git
  RUN apt-get install -y --force-yes zlib1g-dev libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt-dev libmysqlclient-dev ruby-dev imagemagick libmagickcore-dev libmagickwand-dev subversion mysql-server mysql-client libmysqlclient-dev

  RUN git clone https://github.com/sstephenson/rbenv.git /root/.rbenv
  RUN git clone https://github.com/sstephenson/ruby-build.git /root/.rbenv/plugins/ruby-build
  RUN ./root/.rbenv/plugins/ruby-build/install.sh
  ENV PATH /root/.rbenv/bin:$PATH
  RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh # or /etc/profile
  
  RUN rbenv install 1.9.3-p545
  RUN rbenv global 1.9.3-p545
  RUN rbenv rehash
  
  RUN apt-get install -y 
  
  RUN gem install mysql2 -v '0.3.11'
  RUN gem install bundler
  RUN gem install rmagick --no-rdoc --no-ri
  
  RUN svn co --non-interactive --no-auth-cache --username kato-r --password kato+r https://svn.applicative.jp/svn/projects/Applicative/GoldRush/develop/sql/
  
  RUN mkdir work
  RUN cd work && git clone https://github.com/jomjomni/goldrush.git
  RUN cd work/goldrush && bundle install
  RUN cp work/goldrush/config/database.yml.org work/goldrush/config/database.yml
  
  RUN /etc/init.d/mysql start && cd sql && mysql -u root < CreateDatabase.SQL && mysql -u grdev -p grdev --password=grdev < InitData.SQL && cd ~/work/goldrush && rake db:fixtures:load FIXTURES_PATH=fixtures/develop
  
  EXPOSE 3000
  
  CMD ["/etc/init.d/mysql start", "/work/goldrush rails s"]
  