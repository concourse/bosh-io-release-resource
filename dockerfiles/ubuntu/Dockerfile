FROM ubuntu:bionic AS resource

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    jq \
  && rm -rf /var/lib/apt/lists/*

ADD assets/ /opt/resource/
RUN chmod +x /opt/resource/*

FROM resource AS tests
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    ruby-full \
    ruby-bundler \
  && rm -rf /var/lib/apt/lists/*
ADD . /resource
WORKDIR /resource
RUN gem update --system && gem install bundler #switch to bundle 2.1.4
RUN bundle install --local \
  && bundle exec rspec
FROM resource
