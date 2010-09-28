module Chess
  module StartingPositions
    class Standard
      include Chess::Pieces
      HOME_ROW = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]

      # Place the pieces in the traditional starting positions
      def setup(board)
        ('a'..'h').each_with_index do |column, index|
          # Set up the home rows
          [[1, :white], [8, :black]].each do |row, color|
            piece = HOME_ROW[index].new(color)
            board.place( Square.new(column, row), piece )
          end
      
          # Setup the pawns
          [[2, :white], [7,:black]].each do |row, color|
            piece = Pawn.new(color)
            board.place( Square.new(column, row), piece)
          end
        end
      end
    end
  end
end