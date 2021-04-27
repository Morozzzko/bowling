# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem 'dry-struct'
gem 'dry-system', '~> 0.19.0'
gem 'oj'
gem 'puma'
gem 'roda'

group :lint do
  gem 'rubocop'
  gem 'rubocop-rspec'
end

group :test do
  gem 'rack-test'
  gem 'rspec'
  gem 'simplecov'
end

group :tools do
  gem 'rubocop-daemon'
  gem 'solargraph'
end
