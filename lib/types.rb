# frozen_string_literal: true

module Types
  include Dry.Types

  UID = Types::String.constrained(min_size: 5)
  FilledString = Types::String.constrained(min_size: 0)
end
