module Chess
  module Pieces
    class Rook < Base
      self.base_movements = %w[n e s w]
      self.repeater = true
    end
  end
end