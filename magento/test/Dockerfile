FROM ruby:2.3.0


RUN apt-get update && apt-get install -y \
    libxml2-dev libxslt1-dev \
    libqt4-webkit libqt4-dev xvfb \
 && rm -rf /var/lib/apt/lists/*

# for nokogiri

ENV APP_HOME /myapp
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN bundle install

ADD . $APP_HOME
