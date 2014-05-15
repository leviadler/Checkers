# encoding: utf-8
require "./board"
require "./piece"
require "./player"
require 'colorize'
require 'yaml'

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
        
        if start_pos == :save
          save_game
        end
          
        check_start_pos(start_pos)
        
        board[start_pos].perform_moves(move_seq)
      rescue InvalidMoveError => e
        puts e.message
        retry
      end
        
      @players.rotate!
    end
    
    board.render
    puts "Game over! #{@players.last.name} (#{@players.last.color_to_s}) wins!"
  end
  
  def won?
    board.pieces(:b).empty? || board.pieces(:r).empty?
  end
  
  def check_start_pos(pos)
    if !board.on_board?(pos)
      raise InvalidMoveError, "#{pos} is not a possition on the board!"
    elsif board.empty?(pos)
      raise InvalidMoveError, "No piece at #{pos}!"
    elsif board[pos].color != @players.first.color
      raise InvalidMoveError, "Thats not your piece!"
    end
  end
  
  def save_game
    puts "Saving!".colorize(:red).blink
    File.write("saved_game.yml", YAML.dump(self))
    sleep(5)
    system "clear"
    exit
  end
  
  def self.load_game
    YAML.load_file("saved_game.yml").play
  end
    
end

if __FILE__ == $PROGRAM_NAME
  system "clear"
  puts "Would you like to load your last saved game? (y/n)"
  input = gets.chomp.downcase
  if input == "y"
    Game::load_game
  else
    puts "Player 1, Enter your name:"
    name1 = gets.chomp
    puts "Player 2, Enter your name:"
    name2 = gets.chomp
    g = Game.new(HumanPlayer.new(name1), HumanPlayer.new(name2))
    g.play
  end
end