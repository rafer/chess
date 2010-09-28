module Chess
  module StartingPositions
    class FromString
      def initialize(board_string)
        @board_string = board_string
        remove_leading_tabs_and_newline
      end
      
      def setup(board)
        rows = @board_string.split("\n").reverse # First line will be highest
        
        (rows.zip(Chess::Board::ROW_RANGE.to_a)).each do |row, row_index|
          columns = row.split(' ')
          (columns.zip(Chess::Board::COLUMN_RANGE.to_a)).each do |content, column_index|
            unless content == '.'
              square = Square.new(column_index, row_index)
              board[square] = Pieces::Base.from_character(content)
            end
          end
        end
        
      end
      
    private
      def remove_leading_tabs_and_newline
        @board_string.gsub!(/^[\s]+/ ,"")
        @board_string.gsub!(/\n\Z/, '')
      end
    end
  end
end