# frozen_string_literal: true

require 'rom/factory'

Factory = ROM::Factory.configure do |config|
  config.rom = Bowling::Container['persistence.rom']
end

require 'securerandom'

Dir[File.join(__dir__, './factories/**/*.rb')].each { require _1 }
