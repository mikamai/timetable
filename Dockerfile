FROM ruby:2.4-alpine as builder
USER root

RUN apk update && apk add --no-cache build-base gcc postgresql-dev nodejs yarn git tzdata file imagemagick

ENV RAILS_ENV production
ENV NODE_ENV production

ARG SECRET_KEY_BASE
RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install --binstubs --deployment --without development test

COPY . .

RUN bundle exec rails assets:clean && bundle exec rails assets:precompile

RUN rm -rf node_modules tmp/cache app/assets vendor/assets lib/assets spec

# RUNTIME IMAGE

FROM ruby:2.4-alpine

RUN apk update && apk add --no-cache postgresql-libs tzdata file imagemagick nodejs

ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true

RUN mkdir /app
WORKDIR /app

RUN addgroup -g 1000 -S app \
 && adduser -u 1000 -S app -G app
USER app

COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=builder --chown=app:app /app /app

RUN chmod -R 777 public


