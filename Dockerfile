# Multi-stage build for Render.com free tier (and local Docker).
# Stage 1: Node — install Frontend pin and compile Sass
# Stage 2: Bundle install
# Stage 3: Runtime — Puma + assets + baseline

FROM node:22-bookworm AS styles
WORKDIR /build
COPY package.json package-lock.json ./
RUN npm ci
COPY styles ./styles
COPY scripts ./scripts
RUN npm run build:styles

FROM ruby:3.3.4-bookworm AS gems
WORKDIR /app
RUN apt-get update && apt-get install -y --no-install-recommends \
      build-essential \
      libbrotli-dev \
  && rm -rf /var/lib/apt/lists/*
COPY Gemfile Gemfile.lock ./
ENV BUNDLE_WITHOUT="development:test" \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle
RUN bundle install --jobs 4

FROM ruby:3.3.4-slim-bookworm
WORKDIR /app
# libbrotli1 is required at runtime by the brotli native gem (rack-brotli).
RUN apt-get update && apt-get install -y --no-install-recommends \
      libyaml-0-2 \
      libbrotli1 \
  && rm -rf /var/lib/apt/lists/*

ENV RAILS_ENV=production \
    RACK_ENV=production \
    DEMOS_ENABLED=true \
    BUNDLE_WITHOUT="development:test" \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    RAILS_LOG_TO_STDOUT=true \
    RAILS_SERVE_STATIC_FILES=true

COPY --from=gems /usr/local/bundle /usr/local/bundle
COPY --from=styles /build/node_modules/govuk-frontend ./node_modules/govuk-frontend
COPY --from=styles /build/dist ./dist

COPY Gemfile Gemfile.lock ./
COPY config ./config
COPY app ./app
COPY lib ./lib
COPY baseline ./baseline
COPY styles ./styles
COPY public ./public
COPY bin ./bin
COPY config.ru Rakefile ./

RUN mkdir -p tmp/pids tmp/cache log \
  && chmod +x bin/rails bin/rake

EXPOSE 3000
CMD ["bash", "-c", "exec bundle exec puma -C config/puma.rb -b tcp://0.0.0.0:${PORT:-3000}"]
