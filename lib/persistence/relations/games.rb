# frozen_string_literal: true

module Persistence
  module Relations
    class Games < ROM::Relation[:sql]
      schema(:games, infer: true) do
        associations do
          has_many :frames
        end
      end
    end
  end
end
