# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem 'dry-system', '~> 0.19.0'
gem 'puma'
gem 'roda'

group :lint do
  gem 'rubocop'
end

group :test do
  gem 'rack-test'
  gem 'rspec'
  gem 'simplecov'
end

group :tools do
  gem 'rubocop-daemon'
  gem 'rubocop-rspec'
  gem 'solargraph'
end
