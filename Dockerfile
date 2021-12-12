FROM ruby:3.0.2
ARG PGHOST
ARG PGUSER
ARG PGPASS
ARG RACK_ENV
ARG RAILS_ENV
ARG HOST
ARG PORT
# Install node 14-LTS and yarn
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get update -qq && apt-get install -qq --no-install-recommends \
    nodejs libpq-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
RUN npm install -g yarn@1
RUN gem update --system
RUN gem install bundler
ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install

RUN bundle install --jobs 20 --retry 5
ADD . $APP_HOME
RUN rm -Rf config/master.key
RUN rm -Rf config/credentials.yml.enc
EXPOSE 80
EXPOSE 5432
ENV RAILS_MASTER_KEY=f415e5348fb282cf2b76191c4be198bc
ENV SECRET_KEY_BASE=f415e5348fb282cf2b76191c4be198bc
RUN env

ENTRYPOINT ["bundle", "exec"]
RUN RAILS_ENV=production bundle exec bin/rails db:create
RUN RAILS_ENV=production bundle exec bin/rails db:migrate
RUN RAILS_ENV=production bundle exec bin/rails assets:precompile
CMD ["bin/rails", "s", "--port", "80", "-b", "0.0.0.0"]
