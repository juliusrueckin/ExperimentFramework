FROM ruby:2.5

# install Ruby on Rails
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# create and change to  working directory
WORKDIR /usr/src/app
COPY Gemfile /usr/src/app

# install gems from Gemfile
RUN bundle install

# clone application from github
RUN git clone https://github.com/juliusrueckin/ExperimentFramework.git .

# open port 300 for rails server
EXPOSE 3000

# start rails server
CMD ["rails", "server"]