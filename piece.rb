# encoding: utf-8
require './board'

class Piece
  
  UP_SLIDES = [[-1, -1], [-1, 1]]
  UP_JUMPS = [[-2, -2], [-2, 2]]
  DOWN_SLIDES = [[1, -1],[1, 1]]
  DOWN_JUMPS = [[2, -2],[2, 2]]
  
  attr_accessor :color, :position, :board
  
  def initialize(color, position, board)
    @color = color
    @position = position
    @king = false
    @board = board
    board[position] = self
  end
  
  def perform_slide
    generate_slides(move_diffs.first)
    
  end
  
  def perform_jump
    generate_jumps(move_diffs.last)
    
  end
  
  def move_diffs
    if @king
      [DOWN_SLIDES + UP_SLIDES, DOWN_JUMPS + UP_JUMPS]
    elsif color == :b
      [DOWN_SLIDES, DOWN_JUMPS]
    else
      [UP_SLIDES, UP_JUMPS]
    end
  end
  
  def generate_slides(moves)
    x, y = position
    slide_positions = []
    
    moves.each do |a, b|
      new_position = [x + a, y + b]
      slide_positions << new_position unless board.valid_move?
    end
    
    slide_positions
  end
  
  def generate_jumps(moves)
    
  end
  
  def maybe_promote
    if color == :b && position.last == 7
      @king = true    
    elsif color == :r && position.last == 0
      @king = true
    end
  end
  
  def to_s
    if @king
      color == :b ? "♚" : "♔"
    else
      color == :b ? "◉" : "◎"
    end
  end
      
end