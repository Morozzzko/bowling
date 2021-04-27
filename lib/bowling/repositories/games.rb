# frozen_string_literal: true

require 'bowling/repository'
require 'bowling/game'

module Bowling
  module Repositories
    class Games < Repository[:games]
      def [](uid)
        root.where(uid: uid).map_to(Bowling::Game).one!
      end
    end
  end
end
