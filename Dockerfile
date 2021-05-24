FROM ruby:3.0.1

COPY . bowling

WORKDIR bowling

RUN bundle install

EXPOSE 9292

ENTRYPOINT ["bundle", "exec", "rackup", "-o", "0.0.0.0"]
