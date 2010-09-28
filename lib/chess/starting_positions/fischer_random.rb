module Chess
  module StartingPositions
    class FischerRandom
      include Chess::Pieces
      attr_reader :board_id

      # Each array is [first_night_position, second_knight postion (after the frist night has been added, which is why values liek [1,1] are ok.)]
      KNIGHT_TABLE = [ [0,0], [0,1], [0,2], [0,3], [1,1], [1,2], [1,3], [2,2], [2,3], [3,3] ]

      def initialize(id = rand(960))
        @board_id = id.to_i
        @id_temp = id.to_i

        # Create the Home Row
        @home_row = Array.new(8)
        @home_row[mod_off_id(4) * 2] =  Bishop # Black bishop
        @home_row[mod_off_id(4) * 2 + 1] = Bishop # White bishop
        @home_row[random_open_space] = Queen

        # I decided to do the knight position using a table. It could have been done programatically but since the table only has 10 entries, doing it with a table seemed better than the complexity of the programmatic approach (which wasn't particularly simple.)
        knight_position = random_knight_position
        @home_row[open_space(knight_position[0])] = Knight
        @home_row[open_space(knight_position[1])] = Knight

        for piece in [Rook, King, Rook] #Rook, king, then rook
          @home_row[first_open_space] = piece
        end
      end
      
      def setup(board)
        [[1, :white], [8, :black]].each do |row, color|
          @home_row.each_with_index do |piece, column_index|
            square = Square.new((column_index + ?a).chr, row)
            board.place( square, piece.new(color))
          end
        end

        [[2, :white], [7, :black]].each do |row, color|
          for column in 'a'..'h'
            board.place( Square.new(column, row), Pawn.new(color))
          end
        end
      end

    private    

      # Returns the first (leftmost) open space in the home row
      def first_open_space
        open_space(0)
      end

      # Returns a random open space in the home row
      def random_open_space
        open_space(mod_off_id(@home_row.select{|x| x.nil?}.size))
      end

      # Returns the column of the nth open space in the home row, travelling from left to right.
      # "Tell me what column contains the 3rd open space, from left to right"
      def open_space(n)
        i = 0
        open_space_num = 0
        begin
          if @home_row[i].nil?
            return i if n == open_space_num
            open_space_num += 1
          end
          i += 1
        end while true
      end

      def random_knight_position
        return KNIGHT_TABLE[mod_off_id(10)]
      end

      # Returns a number between greater than or equal to 0 and less than mod, by extracting this number from @id_tem
      # This allows the board to be 'random' based on the id (i.e.) boards with the same id will always have the same layout.
      def mod_off_id(mod)
        n = @id_temp % mod
        @id_temp /= mod
        return n
      end

    end
  end
end