module Chess
  module Pieces
    class Pawn < Base

      # E.g. what does it mean to go 'forward' for a black pawn?
      RELATIVE_DIRECTIONS = {
        :white => {
          :forward => 'n',
          :forward_right => 'ne',
          :forward_left => 'nw'
        },
        :black => {
          :forward => 's',
          :forward_right => 'sw',
          :forward_left => 'se'
        }
      }

      # Where do the pawns start?
      HOME_ROW = {
        :white => 2,
        :black => 7
      }

      # The pawn does not have a simple movement pattern, so this method is
      # overriden
      def possible_squares
        possible_squares = []
        possible_squares << square_in_direction_unless_occupied(forward)
        
        # Forward two squares from the starting line
        if current_square.row == home_row and @board[current_square + forward].nil?
          possible_squares << square_in_direction_unless_occupied(forward * 2)
        end
        
        # Take diagonally forward one square
        for diagonal in [forward_right, forward_left]
          square = current_square + diagonal
          next if square.nil? # Don't go off the side of the board
          if other_piece = @board[square] and color != other_piece.color
            possible_squares << square
          end
        end

        

        possible_squares.compact
      end
    private
      def adjacent_opposite_color_pawns
        [@board[current_square + 'e'], @board[current_square + 'w']].select do |piece|
          piece.is_a?(Pawn) and piece.color != color
        end
      end

      def square_in_direction_unless_occupied(direction)
        square = (current_square + direction)
        return (square.nil? or @board[square]) ? nil : square
      end

      def home_row
        HOME_ROW[color]
      end

      def method_missing(method)
        if direction = RELATIVE_DIRECTIONS[color][method]
          return direction
        end
        super(method)
      end
    end
  end
end