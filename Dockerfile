FROM ruby:2.6.3-alpine3.8

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

WORKDIR /app

RUN gem install bundler -v 2 --no-doc

# Copy dependency manifest
COPY Gemfile Gemfile.lock /app/

RUN bundle update --bundler
RUN bundle install --jobs $(nproc) --retry 3 --without development test \
      && rm -rf /usr/local/bundle/bundler/gems/*/.git /usr/local/bundle/cache/

COPY package.json yarn.lock /app/

RUN yarn install

ENV NODE_ENV production
ENV RAILS_ENV production
ENV RAILS_LOG_TO_STDOUT true

COPY . /app/

RUN bundle exec rails webpacker:verify_install
RUN SECRET_KEY_BASE=nein bundle exec rails assets:precompile

RUN chmod +x ./bin/entrypoint.sh

ENTRYPOINT ["./bin/entrypoint.sh"]