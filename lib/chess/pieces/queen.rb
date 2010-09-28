module Chess
  module Pieces
    class Queen < Base
      self.base_movements = %w[n ne e se s sw w nw]
      self.repeater = true
    end
  end
end