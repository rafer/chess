module Chess
  class Square
    class BadSquareError < ArgumentError; end

    @@square_pattern = /^([a-h])([0-8])$/

    attr_reader :row, :column

    def initialize(*args)
      # For things like 'a5'
      if match = @@square_pattern.match( args.first.to_s )
        @column = match[1]
        @row = match[2].to_i
        return
      end
      
      # for things like 'a', 5
      if Board::COLUMN_RANGE.include?( args[0] ) and Board::ROW_RANGE.include?( args[1] )
        @column = args[0]
        @row = args[1]
        return
      end

      raise BadSquareError
    end

    # Add a given movement (like 'nw' or 'nne' of 'w') to a square and return the new square
    # If the movement moves the square of the board, then nil will be returned
    def +( movements )
      movements = movements.split('')

      count = {}
      for direction in %w[n e s w]
        count[direction] = movements.select{|m| m == direction}.count
      end
      
      new_column = (column[0] + count['e'] - count['w']).chr
      new_row = row + count['n'] - count['s']

      return nil unless Board::COLUMN_RANGE.include?(new_column) and Board::ROW_RANGE.include?(new_row)

      Square.new(new_column, new_row)
    end
    
    # Two squares are considered equal if their respective rows and columns are equal.
    def ==( other_square )
      column == other_square.column and row == other_square.row
    end
    
    def color
      if (@row + (@column[0] - Board::COLUMN_RANGE.first[0])).even?
        return :light
      else
        return :dark
      end
    end
    
    def to_s
      "#{column}#{row}"
    end
    
    alias inspect to_s
    
    # Returns a square object
    # 
    # If the input is a square object, it simply returns that object.
    # Otherwise Square.new is used to construct a new square object
    def self.from(square)
      return square if square.class == self
      return Square.new(square)
    end
  end
end