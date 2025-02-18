FROM ruby:2.5

MAINTAINER Marten Veldthuis

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install --no-install-recommends -y supervisor && \
    apt-get clean

WORKDIR /app

ADD ./Gemfile /app
ADD ./Gemfile.lock /app
RUN bundle install --without development test

ADD ./ /app
ADD ./docker/supervisord.conf /etc/supervisor/conf.d/interventions.conf

RUN (git log --format="%H" -n 1 > public/commit_id.txt)

EXPOSE 80
ENTRYPOINT /app/docker/start.sh
