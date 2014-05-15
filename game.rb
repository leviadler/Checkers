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
    
end

if __FILE__ == $PROGRAM_NAME
  g = Game.new(HumanPlayer.new("John"), HumanPlayer.new("Jim"))
  g.play
end