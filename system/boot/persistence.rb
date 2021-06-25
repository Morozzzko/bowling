# frozen_string_literal: true

require 'types'

Bowling::Container.boot(:persistence) do |system|
  init do
    require 'sequel'
    require 'rom'
    require 'rom/sql'

    use :settings

    Sequel.database_timezone = :utc
    Sequel.application_timezone = :local

    rom_config = ROM::Configuration.new(
      :sql,
      system[:settings].database_url,
      extensions: %i[]
    )

    rom_config.plugin :sql, relations: :auto_restrictions

    container.register 'persistence.config', rom_config
    container.register 'persistence.db', rom_config.gateways[:default].connection
  end

  start do |system|
    config = container['persistence.config']

    config.auto_registration(system.root.join('lib/persistence'))

    container.register 'persistence.rom', ROM.container(config)
  end
end
