# encoding: utf-8
require "./board"
require "./piece"
require "./player"

class Game
  
  attr_reader :board
  
  def initialize(player1, player2)
    @board = Board.new(true)
    player1.color = :b
    player2.color = :r
    @players = [player1, player2]
  end
  
  def play
    until won?
      board.render
      begin
        start_pos, move_seq = @players.first.make_move
        check_start_pos(start_pos)
        
        board[start_pos].perform_moves(move_seq)
      rescue InvalidMoveError => e
        puts e.message
        retry
      end
        
      @players.rotate!
    end
    
    board.render
    puts "Game over!"
  end
  
  def won?
    board.pieces(:b).empty? || board.pieces(:r).empty?
  end
  
  def check_start_pos(pos)
    if board.empty?(pos)
      raise InvalidMoveError, "No piece at #{pos}!"
    elsif board[pos].color != @players.first.color
      raise InvalidMoveError, "Thats not your piece!"
    end
  end
    
end

if __FILE__ == $PROGRAM_NAME
  g = Game.new(HumanPlayer.new("John"), HumanPlayer.new("Jim"))
  g.play
end