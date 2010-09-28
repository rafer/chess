module Chess
  module Pieces
    class King < Base
      self.base_movements = %w[n ne e se s sw w nw]
    end
  end
end