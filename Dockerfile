FROM ruby:3.1.2

RUN apt-get update && apt-get install -y nodejs yarn postgresql-client

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler
RUN bundle install
COPY . .

RUN curl https://deb.nodesource.com/setup_12.x | bash
RUN curl https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN rake assets:precompile
RUN rm -f tmp/pids/server.pid
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]