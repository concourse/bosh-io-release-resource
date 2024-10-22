ARG base_image
ARG builder_image=paketobuildpacks/build-jammy-base

FROM ${builder_image} AS tests
USER root
RUN apt update && apt upgrade -y -o Dpkg::Options::="--force-confdef"
RUN apt update && apt install -y --no-install-recommends \
  wget \
  curl \
  ca-certificates \
  jq \
  ruby-full \
  && rm -rf /var/lib/apt/lists/*
ADD assets/ /opt/resource/
RUN wget "https://github.com/moparisthebest/static-curl/releases/download/v8.10.1/curl-amd64" -O /opt/resource/curl
RUN chmod +x /opt/resource/*
ADD . /resource
WORKDIR /resource
RUN gem install bundler -v 2.1.4
RUN bundle install --local && bundle exec rspec

FROM ${base_image} AS resource
USER root

COPY --from=busybox:uclibc /bin/mktemp /bin/
COPY --from=busybox:uclibc /bin/mkdir /bin/
COPY --from=busybox:uclibc /bin/sha256sum /bin/
COPY --from=busybox:uclibc /bin/sha1sum /bin/
COPY --from=stedolan/jq /usr/local/bin/jq /bin/
COPY --from=tests /opt/resource/curl /bin/

ADD assets/ /opt/resource/
RUN chmod +x /opt/resource/*

FROM resource
