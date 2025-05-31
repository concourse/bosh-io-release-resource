ARG base_image=cgr.dev/chainguard/wolfi-base

ARG BUILDPLATFORM
FROM --platform=${BUILDPLATFORM} ${base_image} AS tests
RUN apk --no-cache add \
    curl \
    ca-certificates \
    jq \
    ruby \
    cmd:rspec

ADD assets/ /opt/resource/
RUN chmod +x /opt/resource/*
ADD . /resource
WORKDIR /resource
RUN gem install bundler -v 2.6
RUN bundle install --local && bundle exec rspec

FROM ${base_image} AS resource
RUN apk --no-cache add \
    ca-certificates \
    jq \
    curl

ADD assets/ /opt/resource/
RUN chmod +x /opt/resource/*

FROM resource
