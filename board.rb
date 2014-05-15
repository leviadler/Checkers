# encoding: utf-8
require './piece.rb'
require 'colorize'

class Board

  BOARD_SIZE = 8

  def initialize(setup = false)
    @grid = Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE) }
    setup_board if setup
    
    @reds_jumped = 0
    @blacks_jumped = 0
  end

  def render
    system "clear"
    puts  "   0  1  2  3  4  5  6  7"
    BOARD_SIZE.times do |x|
      print "#{x} "
      BOARD_SIZE.times do |y|
        str = self[[x,y]] ? " #{self[[x,y]]} " : "   "
        if (x + y).odd?
          print str.colorize(:background => :light_black)
        else
          print str.colorize( :background => :red)
        end
      end
      print "\n"
    end
    puts "  " + (" ◉" * @reds_jumped).colorize(:red) + (" ◉" * @blacks_jumped)
  end

  def [](pos)
    x, y = pos
    @grid[x][y]
  end

  def []=(pos, piece)
    x, y = pos
    @grid[x][y] = piece
    piece.position = pos if piece
  end

  def empty?(pos)
    self[pos].nil?
  end
  
  def dup
    new_board = Board.new
    self.pieces.each { |piece| piece.dup(new_board) }
    new_board
  end

  def on_board?(pos)
    pos.all? { |coord| coord.between?(0, BOARD_SIZE-1) }
  end

  def has_opponent?(my_color, pos)
    self[pos] && self[pos].color != my_color
  end

  def pieces(color = nil)
    if color
      @grid.flatten.compact.select {|piece| piece.color == color}
    else
      @grid.flatten.compact
    end
  end
  
  def add_to_jumped(color)
    if color == :b
      @blacks_jumped += 1
    else
      @reds_jumped += 1
    end
  end

  def setup_board
    (0..2).each { |row| fill_row(row, :r) }
    (5..7).each { |row| fill_row(row, :b) }
  end

  def fill_row(row, color)
    @grid[row].each_index do |index|
      Piece.new(color, [row, index], self) if (row + index).odd?
    end
  end

end