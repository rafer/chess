module Chess
  module Pieces
    class Base      
      class << self
        attr_writer :base_movements
        def base_movements
          @base_movements ||= []
        end
        
        attr_writer :repeater
        def repeater?
          @repeater ||= false
        end

        attr_writer :character
        def character
          # Default to the first letter of the class name
          @character ||= self.to_s.split('::').last[0,1].downcase
        end

      end
      
      attr_reader :color

      def initialize(color)
        @color = color
      end

      def ==(other_piece)
        self.class == other_piece.class and self.color == other_piece.color
      end
      
      # White pieces are uppercase, black are lower
      def self.from_character(string)
        piece_class = piece_classes.find{|c| c.character == string.downcase}
        return nil unless piece_class
        string == string.upcase ? piece_class.new(:white) : piece_class.new(:black)
      end

      def to_s
        color == :white ? self.class.character.upcase : self.class.character
      end

    # All of the methods below this require that the piece be bound to a board
      def bind(board)
        @board = board
      end
      
      def unbind
        @board = nil
      end
      
      def move_to?(square)
        square = Square.from(square)
        return possible_squares.include?( square )
      end

      def possible_squares
        squares = []
        for movement in self.class.base_movements
          # Sorry everybody, I'm gonna name this variable s. It represents the square that is currently
          # being examined, similar to a variable like i. Can anybody think of something better to name this? -RLH
          s = current_square

          while s += movement
            if board.at(s)
              if board.at(s).color == color
                # If the piece on this square is the same color as this piece, then stop looking
                break
              else
                # If the piece on this square is a different color, then that piece can be taken, but the piece can't advance anymore
                squares << s
                break
              end
            end
            squares << s
            break unless self.class.repeater?
          end
        end
        return squares
      end

    private
      def board
        raise 'This piece has not been bound to a board' if @board.nil?
        return @board
      end
    
      # Tricky way to get all of the subclasses of piece without registering them
      def self.piece_classes
        piece_classes = []
        ObjectSpace.each_object(Class) do |klass|
          next unless klass.superclass == self
          piece_classes << klass
        end
        return piece_classes
      end

      def current_square
        board.square_of(self)
      end
    end
  end
end