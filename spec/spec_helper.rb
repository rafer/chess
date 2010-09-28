$LOAD_PATH << File.join(File.dirname(__FILE__),"..","lib") 
module TextBoardHelpers
  # A syntactically sweet wrapper around...
  def this_board(board_string)
    board = Chess::Board.new
    starter = Chess::StartingPositions::FromString.new(board_string)
    starter.setup(board)
    return board
  end


  def these_squares(board_string)
    remove_leading_tabs_and_newline!(board_string)    

    selected_squares = []

    # The rows, with row 8 first, row 1 last
    rows = board_string.split("\n")
    for row_index in Chess::Board::ROW_RANGE
      # Get the lowest numbered row
      row = rows.pop

      squares = row.split(' ')
      for column_index in Chess::Board::COLUMN_RANGE
        # Get the lowest 'lettered' columm
        square = squares.shift
        selected_squares << Chess::Square.new(column_index, row_index) unless square == '.'
      end
    end

    return selected_squares
  end

private
  # Helper to allow board-like representations to be indented
  def remove_leading_tabs_and_newline!(board_string)
    board_string.gsub!(/^[\s]+/ ,"")
    board_string.gsub!(/\n\Z/, '')
  end
end

require 'spec' 
require 'chess'

