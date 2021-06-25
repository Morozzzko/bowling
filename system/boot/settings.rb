# frozen_string_literal: true

require 'dry/system/components'

Bowling::Container.boot(:settings, from: :system) do
  settings do
    key :database_url, (::Types::FilledString.default { 'sqlite://tmp/bowling.sqlite3' })
  end
end
