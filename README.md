# My Shortener
Simple URL shortener made with Rails, React.js and Webpack

## Tools and versions:

* Ruby - 3.0.2
* Rails - 6.1.0
* PostgreSQL - 12
* Node.js - 14.0.0
* Yarn - 1.22.5
* React.js - 17.0.2 (via Webpacker)

## Setting up dev and test environments:

* Install all tools according their versions above;
* Set up the environment variables enlisted in `config/database.yml`;

* Run `yarn`;
* Run `bundle exec rails db:create RAILS_ENV=development`;
* Run `bundle exec rails db:migrate RAILS_ENV=development`;
* Run `bundle exec rails db:create RAILS_ENV=test`;
* Run `bundle exec rails db:migrate RAILS_ENV=test`;
* You can run the tests for the backend `bundle exec rspec`;
* Run `bundle exec rails assets:precompile`;
* You can start the development server (running at localhost:3000) with `bundle exec rails s RAILS_ENV=development`;

## Running in production (assuming you are running it in a different computing instance than previously)
* Set up the following environment variables with the `production` value: RAILS\_ENV and RACK\_ENV;
* Set up the environment variables enlisted in `config/database.yml`;
* Install the connection lib for Postgres (in Ubuntu 20, it is called libpq-dev);
* Run `bundle install`;
* Run `yarn`;
* Run `bundle exec rails db:create`;
* Run `bundle exec rails db:migrate`;
* Run `bundle exec rails assets:precompile`;
* Start puma server as a deamon (make sure you have enough permissions and firewall rules done) with `bundle exec puma -p 80`;
