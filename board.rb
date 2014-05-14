# encoding: utf-8
require './piece.rb'

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
  
  def [](pos)
    x, y = pos
    @grid[x][y]
  end
  
  def []=(pos, value)
    x, y = pos
    @grid[x][y] = value
  end
  
  def valid_move?(pos)
    pos.all? { |coord| coord.between?(0,7) }
  end
  
end