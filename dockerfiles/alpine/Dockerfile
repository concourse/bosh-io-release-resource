ARG base_image=alpine:latest

FROM ${base_image} AS resource
RUN apk --no-cache add \
  bash \
  curl \
  gzip \
  jq \
  tar
ADD assets/ /opt/resource/
RUN chmod +x /opt/resource/*

FROM resource AS tests
RUN apk --no-cache add ruby ruby-libs ruby-bundler ruby-json
ADD . /resource
WORKDIR /resource
RUN bundle install --local && bundle exec rspec
FROM resource
