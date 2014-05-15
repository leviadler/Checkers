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

  def perform_slide(end_pos)
    slide_positions = generate_slides
    if slide_positions.include?(end_pos)
      board[self.position] = nil
      board[end_pos] = self
      
      maybe_promote
      return true
    end
    raise "invalid slide"
    false
  end

  def perform_jump(end_pos)
    jump_positions = generate_jumps

    if jump_positions.include?(end_pos)
      pos_jumping = pos_jumping(position, end_pos)
      
      board[self.position] = nil
      board[end_pos] = self
      
      board[pos_jumping] = nil
      
      maybe_promote
      return true
    end
    raise "invalid jump"
    false
  end

  def move_diffs
    if @king
      [DOWN_SLIDES + UP_SLIDES, DOWN_JUMPS + UP_JUMPS]
    elsif color == :b
      [UP_SLIDES, UP_JUMPS]
    else
      [DOWN_SLIDES, DOWN_JUMPS]
    end
  end

  def generate_slides
    x, y = position
    slide_positions = []

    move_diffs.first.each do |a, b|
      new_position = [x + a, y + b]
      if valid_move?(new_position)
        slide_positions << new_position
      end
    end

    slide_positions
  end

  def generate_jumps
    jump_positions = []
    
    x, y = position

    move_diffs.last.each do |move|
      new_position = [x + move.first, y + move.last]
      pos_jumping = pos_jumping(position, new_position)

      if valid_jump?(new_position, pos_jumping)
        jump_positions << new_position
      end
    end

    jump_positions
  end
  
  
  def valid_move?(pos)
    board.on_board?(pos) && board.empty?(pos)
  end

  def valid_jump?(pos, pos_jumping)
    valid_move?(pos) && board.has_opponent?(self.color, pos_jumping)
  end
  
  def pos_jumping(start_pos, end_pos)
    [(start_pos.first + end_pos.first) / 2, (start_pos.last + end_pos.last) / 2 ]
  end

  def maybe_promote
    if color == :b && position.first == 7
      @king = true
    elsif color == :r && position.first == 0
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

if __FILE__ == $PROGRAM_NAME
  b = Board.new(true)
  b.render
  b[[2,1]].perform_slide([3,2])
  b.render
  b[[5,2]].perform_slide([4,3])
  b.render
  b[[4,3]].perform_jump([2,1])
  b.render
  b[[1,2]].perform_jump([3,0])
  b.render
  b[[0,1]].perform_slide([1,0])
end