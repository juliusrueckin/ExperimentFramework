FROM ruby:2.5

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        postgresql-client \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app
COPY Gemfile /usr/src/app
RUN bundle install
COPY . .

EXPOSE 3000
CMD ["rails", "server"]