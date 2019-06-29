# ARG: https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact
ARG BUILDER_IMAGE_TAG
FROM $BUILDER_IMAGE_TAG as front-end-builder

# Define basic environment variables
ENV NODE_ENV production
ENV RAILS_ENV production
ENV RAILS_LOG_TO_STDOUT true

# Copy source code
COPY . /app/

# Build front-end assets
RUN bundle exec rails webpacker:verify_install
RUN SECRET_KEY_BASE=nein bundle exec rails assets:precompile

RUN rm -rf node_modules

FROM ruby:2.6.3-alpine3.8 as deploy

RUN apk add --no-cache \
  ca-certificates \
  curl \
  tzdata \
  gnupg1 \
  graphicsmagick \
  libsodium-dev \
  nodejs \
  postgresql-dev \
  bash

# Define basic environment variables
ENV NODE_ENV production
ENV RAILS_ENV production
ENV RAILS_LOG_TO_STDOUT true
# Defined for future testing
ENV RAILS_SERVE_STATIC_FILES true

RUN chmod +x ./bin/entrypoint.sh

# Define entrypoint
ENTRYPOINT ["./bin/entrypoint.sh"]