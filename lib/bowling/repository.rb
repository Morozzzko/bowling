# frozen_string_literal: true

require 'rom/repository'

module Bowling
  class Repository < ROM::Repository::Root
    include Bowling::Injector[container: 'persistence.rom']
  end
end
