FROM ruby:2.5.7
MAINTAINER "Christoph Fabianek" christoph@ownyourdata.eu

WORKDIR /usr/src/app
ENV RAILS_ROOT $WORKDIR

COPY Gemfile $WORKDIR

RUN apt-get update && \
	apt-get install -y --no-install-recommends \
  		nodejs && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
	bundle install --without development test && \
	gem install bundler

COPY . .

RUN bundle update

CMD ["rails", "server", "-b", "0.0.0.0"]

EXPOSE 3000
