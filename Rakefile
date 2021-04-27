# frozen_string_literal: true

require 'bundler/setup'
require_relative 'system/bowling/container'

require 'rom/sql/rake_task'

namespace :db do
  task :setup do
    Bowling::Container.init :persistence
  end
end
