FROM ruby:2.4

ENV RAILS_ENV production
ENV SECRET_KEY_BASE "change me at startup"

RUN apt-get -yqq update \
  && apt-get install -yqq autoconf \
  build-essential \
  libreadline-dev \
  libssl-dev \
  libxml2-dev \
  libyaml-dev \
  libffi-dev \
  zlib1g-dev \
  git-core \
  curl \
  nodejs \
  libmagickcore-dev \
  libmagickwand-dev \
  libcurl4-openssl-dev \
  imagemagick \
  bison \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY Gemfile Gemfile.lock /app/
RUN bundle install --deployment --without development test

WORKDIR /app
COPY . /app
RUN bundle exec rake assets:precompile

VOLUME /app/public
EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
