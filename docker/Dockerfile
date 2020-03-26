FROM ruby:2.5.7
MAINTAINER "Christoph Fabianek" christoph@ownyourdata.eu

WORKDIR /usr/src/app
ENV RAILS_ROOT $WORKDIR

COPY Gemfile $WORKDIR

RUN bundle install --without development test && \
	gem install bundler

COPY . .

RUN bundle update

CMD ["rails", "server", "-b", "0.0.0.0"]

EXPOSE 3000
