# encoding: utf-8
require './board'
require './errors'
require 'colorize'

class Piece

  UP_SLIDES = [[-1, -1], [-1, 1]]
  UP_JUMPS = [[-2, -2], [-2, 2]]
  DOWN_SLIDES = [[1, -1],[1, 1]]
  DOWN_JUMPS = [[2, -2],[2, 2]]

  attr_accessor :color, :position, :board

  def initialize(color, position, board, king = false)
    @color = color
    @position = position
    @king = king
    @board = board
    board[position] = self
  end

  def dup(new_board)
    Piece.new(self.color, self.position, new_board, @king)
  end

  def perform_moves(move_sequence)
    if valid_move_seq?(move_sequence)
      perform_moves!(move_sequence)
    else
      raise InvalidMoveError, "Invalid Move Sequence or Jump Available!"
    end
  end

  def jump_available?
    board.pieces(color).any? { |piece| !piece.generate_jumps.empty? }
  end

  protected
  def perform_moves!(move_sequence)
    if move_sequence.count == 1
      unless perform_slide(move_sequence[0]) || perform_jump(move_sequence[0])
        raise InvalidMoveError, "Invalid move! Cannot move to #{move_sequence[0]}."
      end
    else
      move_sequence.each do |move|
        unless perform_jump(move)
          raise InvalidMoveError, "Invalid move! Cannot move to #{move}."
        end
      end
    end
  end

  def valid_move_seq?(move_sequence)
    new_board = board.dup
    begin
      new_board[position].perform_moves!(move_sequence)
    rescue InvalidMoveError => e
      raise e
      return false
    end

    true
  end

  def perform_slide(end_pos)
    slide_positions = generate_slides
    if slide_positions.include?(end_pos)
      raise InvalidMoveError, "Invalid move. Jump available!" if jump_available?

      board[self.position] = nil
      board[end_pos] = self

      maybe_promote
      return true
    end

    false
  end

  def perform_jump(end_pos)
    jump_positions = generate_jumps

    if jump_positions.include?(end_pos)
      pos_jumping = pos_jumping(position, end_pos)

      board[self.position] = nil
      board[end_pos] = self

      board[pos_jumping] = nil
      add_to_jump_count

      maybe_promote
      return true
    end

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

  def add_to_jump_count
    color_jumped = color == :b ? :r : :b
    board.add_to_jumped(color_jumped)
  end

  def maybe_promote
    if color == :b && position.first == 0
      @king = true
    elsif color == :r && position.first == 7
      @king = true
    end
  end

  def to_s
    if @king
      color == :b ? "♚" : "♚".colorize(:red)
    else
      color == :b ? "◉" : "◉".colorize(:red)
    end
  end

end


# For testing
if __FILE__ == $PROGRAM_NAME
  b = Board.new(true)
  b.render
  b[[2,1]].perform_moves([[3,2]])
  b.render
  b[[5,2]].perform_moves([[4,3]])
  b.render
  b[[4,3]].perform_moves([[2,1]])
  b.render
  b[[1,2]].perform_moves([[3,0]])
  b.render
  b[[5,0]].perform_moves([[4,1]])
  b.render
  b[[7,4]] = nil
  b.render

  b[[3,0]].perform_moves([[5,2], [7,4]])
  b.render

  b[[5,6]].perform_moves([[4,5]])
  b.render

  b[[7,4]].perform_moves([[5,6], [3,4]])
  b.render
end