# Stage for dependencies installation
FROM ruby:2.6.3-alpine3.8 as builder

# Install alpine packages
RUN apk add --no-cache \
  build-base \
  busybox \
  ca-certificates \
  cmake \
  curl \
  git \
  tzdata \
  gnupg1 \
  graphicsmagick \
  libffi-dev \
  libsodium-dev \
  nodejs \
  yarn \
  openssh-client \
  postgresql-dev \
  tzdata

# Define WORKDIR
WORKDIR /app

# Use bunlder to avoid exit with code 1 bugs while doing integration test
RUN gem install bundler -v 2.0.1 --no-doc

# Copy dependency manifest
COPY Gemfile Gemfile.lock /app/

# Install Ruby dependencies
RUN bundle update --bundler
RUN bundle install --jobs $(nproc) --retry 3 --without development test \
      && rm -rf /usr/local/bundle/bundler/gems/*/.git /usr/local/bundle/cache/

# Copy JavaScript dependencies
COPY package.json yarn.lock /app/

# Install JavaScript dependencies
RUN yarn install