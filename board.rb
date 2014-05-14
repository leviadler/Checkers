class Board
  
  BOARD_SIZE = 8
  
  def initialize(setup = false)
    @grid = Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE) }
    #setup_board if setup
  end
  
  def render
    puts  "   0  1  2  3  4  5  6  7"
    BOARD_SIZE.times do |x|
      print "#{x} "
      BOARD_SIZE.times do |y|
        print "[#{x},#{y}]"
      end
      print "\n"
    end
        
  end
  
end