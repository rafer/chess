require File.join(File.dirname(__FILE__), "..","spec_helper")

module Chess
  describe Square do
    it "should return the same square object if a square object is passed to 'from'" do
      square = Square.new('e7')
      Square.from(square).equal?(square).should == true
    end
    
    it "should return a new square object if a proper square string is passed to 'from'" do
      Square.from('b3').should == Square.new('b3')
      Square.from('b3').should == Square.new('b', 3)
    end
    
    it "should equal another square with the same row and column" do
      Square.new('b7').should == Square.new('b7')
    end
    
    it "should parse string based squares" do
      square = Square.new('a5')
      square.column.should == 'a'
      square.row.should == 5
    end

    it "should complain about bad string based squares" do
      ['', 'a', '5', 5, '5a','i5', 'a9', '55', 'aa'].each do |bad_square|
        lambda{Square.new(bad_square)}.should raise_error(Square::BadSquareError)
      end
    end
    
    it "should read (column, row) format" do
      square = Square.new('a5')
      square.column.should == 'a'
      square.row.should == 5      
    end

    it "should add single movements properly" do
      square = Square.new('c5')

      (square + 'n').should == Square.new('c6')
      (square + 'e').should == Square.new('d5')
      (square + 's').should == Square.new('c4')
      (square + 'w').should == Square.new('b5')
    end
    
    it "should add multiple movements properly" do
      square = Square.new('c5')

      (square + 'ne').should == Square.new('d6')
      (square + 'se').should == Square.new('d4')
      (square + 'sw').should == Square.new('b4')
      (square + 'nw').should == Square.new('b6')      

      (square + 'nne').should == Square.new('d7')
    end

    it "should report nil for additions that move the square off the board" do
      (Square.new('h8') + 'n').should == nil
      (Square.new('h8') + 'e').should == nil
    end
    
    it "should represent itself reasonably as a string" do
      Square.new('c7').to_s.should == 'c7'
    end

    it "should know it's own color" do
      dark_squares = %w[a1 b2 c3 a7 b8 e7 d4 f4 g1 h8 g5].map{|s| Square.new(s)}
      dark_squares.all?{|s| s.color == :dark }.should == true
      
      light_squares = %w[a2 a4 a8 b3 b7 c2 c6 d3 d5 e2 e8].map{|s| Square.new(s)}
      light_squares.all?{|s| s.color == :light }.should == true
    end
  end
end