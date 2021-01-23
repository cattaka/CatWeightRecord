FROM ruby:2.5.5-buster

RUN apt-get update && \
    apt-get install -y yarnpkg && \
    apt-get clean
RUN ln -s /usr/bin/yarnpkg /usr/bin/yarn
RUN echo 'gem: --no-rdoc --no-ri' > ~/.gemrc

RUN gem install bundler -v "2.1.4"

# Install production dependencies.
WORKDIR /usr/src/app
COPY Gemfile Gemfile.lock ./
ENV BUNDLE_FROZEN=true
RUN bundle install

# Copy local code to the container image.
COPY . .

RUN yarn install

ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES 1
RUN bundle exec rails assets:precompile

# Run the web service on container startup.
CMD ["./start.sh"]
