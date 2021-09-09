FROM ruby:3.0.2
# Install node 14-LTS and yarn
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get update -qq && apt-get install -qq --no-install-recommends \
    nodejs libpq-dev postgresql postgresql-contrib \
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

ENV PGHOST=0.0.0.0
ENV PGPASS=1234
ENV PGUSER=postgres
ENV RACK_ENV=production
ENV RAILS_ENV=production
ENV HOST='http://169.59.160.70'
ENV PORT=''
ENV RAILS_MASTER_KEY=f415e5348fb282cf2b76191c4be198bc
ENV SECRET_KEY_BASE=f415e5348fb282cf2b76191c4be198bc
RUN bundle install --jobs 20 --retry 5
ADD . $APP_HOME
RUN ls
RUN pwd
RUN rm -Rf config/master.key
RUN rm -Rf config/credentials.yml.enc
RUN su postgres
RUN psql -c "alter user postgres with password '1234'"
RUN su -
EXPOSE 8080
EXPOSE 5432

ENTRYPOINT ["bundle", "exec"]
RUN RAILS_ENV=production bundle exec bin/rails db:create
RUN RAILS_ENV=production bundle exec bin/rails db:migrate
RUN RAILS_ENV=production bundle exec bin/rails assets:precompile
CMD ["bin/rails", "s", "--port", "8080"]
