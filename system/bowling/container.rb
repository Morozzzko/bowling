# frozen_string_literal: true

require 'dry/system/container'
require 'dry/system/loader/autoloading'

module Bowling
  class Container < Dry::System::Container
    use :env, inferrer: -> { ENV.fetch('RACK_ENV', 'development').to_sym }

    configure do |config|
      config.root = File.join(__dir__, '../..')

      config.component_dirs.default_namespace = 'bowling'
      config.component_dirs.add_to_load_path = true

      config.component_dirs.add 'lib' do |dir|
        dir.auto_register = proc do |component|
          !component.path.include?('api/application')
        end
      end

      config.inflector = Dry::Inflector.new do |inflections|
        inflections.acronym('API')
      end
    end
  end
end
