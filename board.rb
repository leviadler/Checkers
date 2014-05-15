# encoding: utf-8
require './piece.rb'

class Board

  BOARD_SIZE = 8

  def initialize(setup = false)
    @grid = Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE) }
    setup_board if setup
  end

  def render
    puts  "   0  1  2  3  4  5  6  7"
    BOARD_SIZE.times do |x|
      print "#{x} "
      BOARD_SIZE.times do |y|
        if self[[x,y]]
          print "[#{self[[x,y]]}]"
        else
          print "[ ]"
        end
      end
      print "\n"
    end

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
    pos.all? { |coord| coord.between?(0, 7) }
  end

  def has_opponent?(my_color, pos)
    self[pos] && self[pos].color != my_color
  end

  # not sure if needed
  def pieces
    @grid.flatten.compact
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