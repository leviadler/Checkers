
class Player
  
  attr_accessor :color
  attr_reader :name
  
  def initialize(name)
    @name = name
    @color = nil
  end
  
  def color_to_s
    color == :r ? "Red" : "Black"
  end
  
end

class HumanPlayer < Player
  
  def make_move
    puts "Hi #{@name}, you are #{color_to_s}."
    puts "Which piece would you like to move? (ex. 2,7)"
    start_pos = get_input
    
    move_seq = []
    
    loop do
      puts "Where would you like to move to?"
      move_seq << get_input
      puts "Make another move? (y/n)"
      another_move = gets.chomp
      break if another_move.downcase != "y"
    end
    
    [start_pos, move_seq]
  end
  
  def get_input
    input = gets.chomp.squeeze.split(",")
    input.map { |i| Integer(i) }
  end
  
  
end