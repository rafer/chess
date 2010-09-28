module Chess
  module Pieces
    class Knight < Base
      self.base_movements = %w[nne nee see sse ssw sww nww nnw]
      self.character = 'n'
    end
  end
end