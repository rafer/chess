module Chess
  class Move
    class IllegalMove < ArgumentError; end
    
    def initialize(origin, destination)
      @origin = origin
      @destination = destination
    end
    
    def bind(board)
      @board = board
      @piece = board[@origin]
      @mover = @piece.color
      @captured_piece = board[@destination]
    end

  # All of the methods below this only apply if the move has been bound
    attr_reader :mover
    attr_reader :captured_piece
    
    def legal?
      @piece.move_to?(@destination)
    end
    
    def execute
      raise IllegalMove unless legal?
      piece = board.pick_up(@origin)
      captured_piece = board.pick_up(@destination)
      board.place(@destination, piece)
    end

    def undo
      piece = board.pick_up(@destination)
      board.place(@origin, piece)
      board.place(@destination, @captured_piece) if @captured_piece
    end

  private
    def board
      raise 'This move has not been bound to a board' if @board.nil?
      return @board
    end
  end
end