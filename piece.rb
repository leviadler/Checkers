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
      return true
    end
    raise "invalid slide"
    false
  end

  def perform_jump(end_pos)
    jump_positions = generate_jumps

    if jump_positions.keys.include?(end_pos)
      board[self.position] = nil
      board[end_pos] = self
      pos_jumping = jump_positions[end_pos]
      board[pos_jumping] = nil
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
    jump_positions = {}
    
    x, y = position
    move_and_jump_pos = move_diffs.last.zip(move_diffs.first)
    p move_and_jump_pos

    move_and_jump_pos.each do |move, jumping|
      new_position = [x + move.first, y + move.last]
      pos_jumping = [x + jumping.first, y + jumping.last]

      if valid_jump?(new_position, pos_jumping)
        jump_positions[new_position] = pos_jumping
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