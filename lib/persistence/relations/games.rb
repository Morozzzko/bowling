# frozen_string_literal: true

module Persistence
  module Relations
    class Games < ROM::Relation[:sql]
      schema(:games, infer: true)
    end
  end
end
