module Chess
  class Board
    ROW_RANGE = 1..8
    COLUMN_RANGE = 'a'..'h'

    def initialize
      clear
    end
    
    # Creates a new move object, binds it the board and executes it. The Board
    # class is responsible for everything that goes on here, this is simply a
    # convenience method.
    def move(*args)
      move = Move.new(*args)
      move.bind(self)
      move.execute
    end

    # Return the contents of the square at column, row
    # column is a letter in COLUMN_RANGE (e.g. a  or d),
    # row is number in ROW_RANGE (note that this number probably doesn't start at 0)
    def at( square )
      square = Square.from(square)
      row_index = square.row - ROW_RANGE.first
      @squares[self.numeric_column_index(square.column)][row_index]
    end

    # Removes the contents of the given square and returns it
    def pick_up( square )
      square = Square.from(square)

      @piece = at( square )
      @piece.unbind if @piece

      set_at( square, nil )
      return @piece
    end

    # Adds the given piece to the given square 
    # Raises an ArgumentError if the piece is already on the board or if piece.nil? or if
    # another piece occupies the given square (that other piece must be picked_up first)
    def place( square, piece )
      square = Square.from(square)
      
      # Makes sure that this piece (i.e. the object) is not already on this board
      unless pieces.select{|p| p.equal? piece}.size == 0
        raise ArgumentError, "cannot place the same piece object (#{piece.color} #{piece.to_s}) the board twice"
      end
      
      raise ArgumentError, "cannot place a piece on another piece's square" unless at( square ).nil?
      raise ArgumentError, "cannot place nil on the board" if piece.nil?

      set_at( square, piece )
      piece.bind(self)
    end
    
    # Returns the square of the given piece, nil if it is not present
    def square_of( piece )
      # Return the square if the piece at that square is the same as the given piece
      squares.each{|square|  return square if at( square ).equal? piece}
      return nil
    end

    # Returns an array of all of the pieces on the board
    def pieces
      ROW_RANGE.map{|r| COLUMN_RANGE.map{|c| at( Square.new(c, r) )}}.flatten.compact
    end

    # Returns all of the pieces in the given row as an arra
    def row(row)
      COLUMN_RANGE.map{|column| at( Square.new(column, row) )}
    end

    #Remove all of the pieces from the board
    def clear
      # The pieces are set up as @squares[rows][columns]
      @squares = Array.new( COLUMN_RANGE.count ){ Array.new( ROW_RANGE.count ){ nil } }      
    end

    # If passed a piece: returns the square that piece occupies or nil if it isn't on the board (like square_of)
    # 
    # If passed a square: returns the contents of that square (either a piece of nil)
    def [](piece_or_square)
      if piece_or_square.class.ancestors.include?(Chess::Pieces::Base)
        return self.square_of(piece_or_square)
      end
      
      square = Square.from(piece_or_square)
      return self.at(square)
    end
    
    # An alias for place
    def []=(square, piece)
      place(square, piece)
    end

    def ==(other_board)
      for square in squares
        return false unless self[square] == other_board[square]
      end
      return true
    end

    # Turns a letter in COLUMN_RANGE into an index (starting at 0)
    def numeric_column_index(column)
      column[0] - COLUMN_RANGE.first[0]
    end

    def to_s
      row_strings = []

      # Iterate through rows in reverse: we want the last row to be first
      for row in ROW_RANGE.to_a.reverse
        row_string = COLUMN_RANGE.map{ |column| at( Square.new(column, row) ) }

        # Nil becomes '.' otherwise leave it to the pieces to decide it's display
        row_string.map!{|s| s ? s.to_s : '.'}

        row_strings << row_string.join(" ")
      end
      return row_strings.join("\n")
    end

    alias inspect to_s

  private
    def squares
      # Returns all of the squares on the board
      ROW_RANGE.map{|r| COLUMN_RANGE.map{|c| Square.new(c, r) }}.flatten
    end
    
    # Set the given thing at the given column and row
    # It's exactly like place, but less safe (i.e. can set nil, etc)
    def set_at( square , thing)
      row_index = square.row - ROW_RANGE.first
      @squares[self.numeric_column_index(square.column)][row_index] = thing
    end

  end
end