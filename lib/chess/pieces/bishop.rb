module Chess
  module Pieces
    class Bishop < Base 
      self.base_movements = %w[ne se sw nw]
      self.repeater = true
    end
  end
end