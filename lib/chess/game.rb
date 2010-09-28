# A game represents an ordered sequence of legal moves.
#
# You can ask it things like:
# Is this game over?
# What was the conclusion?
# Who's move is it?
# Who moved last?
module Chess
  class Game
    class OutOfTurnError < ArgumentError; end

    attr_reader :board
    def initialize(starting_position)
      @moves = []
      @board = Board.new
      starting_position.setup(@board)
    end

    def whos_turn?
      @moves.count.even? ? :white : :black
    end
    
    def apply(move)
      move.bind(@board)

      raise OutOfTurnError unless move.mover == whos_turn?

      move.execute
      
      @moves << move
    end
    

  end
end