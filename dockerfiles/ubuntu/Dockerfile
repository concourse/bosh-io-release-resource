ARG base_image

FROM ${base_image} AS resource
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
  && rm -rf /var/lib/apt/lists/*
ADD . /resource
WORKDIR /resource
RUN gem install bundler -v 2.1.4
RUN bundle install --local && bundle exec rspec

FROM resource
