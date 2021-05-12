# frozen_string_literal: true

require 'oj'

module Types
  include Dry.Types

  UID = Types::String.constrained(min_size: 5)
  FilledString = Types::String.constrained(min_size: 0)

  module JSON
    output = Types::String.constructor do |ruby_to_db|
      Oj.dump(ruby_to_db, mode: :compat)
    end

    input = Types.Array(Types::Integer).constructor do |raw_db_value|
      if raw_db_value.respond_to?(:to_ary)
        raw_db_value.to_ary
      else
        Oj.load(Types::String[raw_db_value]).map { |value| Types::Integer[value] }
      end
    end

    IntegerArray = output.meta(read: input)
  end
end
