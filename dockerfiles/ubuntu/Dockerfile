FROM ubuntu:bionic AS resource

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    jq \
  && rm -rf /var/lib/apt/lists/*

ADD assets/ /opt/resource/
RUN chmod +x /opt/resource/*

FROM resource AS tests
RUN apt-get update && apt-get install ruby-full ruby-bundler -y
ADD . /resource
WORKDIR /resource
RUN ls -asl /opt/resource
RUN bundle install --local
RUN bundle exec rspec

FROM resource
