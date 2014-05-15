# encoding: utf-8
require "./board"
require "./piece"

class Game
  
  attr_reader :board
  
  def initialize(player1, player2)
    @board = Board.new(true)
    @players = [player1, player2]
  end
  
  def play
    until won?
      board.render
      begin
        player.first.make_move
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