FROM ubuntu:trusty
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

RUN apt-get update && apt-get install -y software-properties-common python-software-properties
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C3173AA6
RUN apt-add-repository ppa:brightbox/ruby-ng
RUN apt-get update && apt-get install -y \
      build-essential ruby2.3 ruby2.3-dev \
      libxml2-dev libxslt1-dev zlib1g-dev \
      firefox xvfb \
      && rm -rf /var/lib/apt/lists/*

RUN gem update --system
RUN gem install bundler

ENV APP_HOME /myapp
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/

RUN bundle install

ADD . $APP_HOME
