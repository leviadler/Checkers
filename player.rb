require './errors'

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
    start_pos = get_input("Which piece would you like to move? (ex. 2,7)")
    
    move_seq = []
    
    loop do
      move_seq << get_input("Where would you like to move to?")
      puts "Make another move? (y/n)"
      another_move = gets.chomp
      break if another_move.downcase != "y"
    end
    
    [start_pos, move_seq]
  end
  
  def get_input(message)
    begin
      puts message
      input = gets.chomp.squeeze.split(",")
      pos = input.map { |i| Integer(i) }
      
      if input.count != 2
        raise InvalidInputError, "Invalid input!"
      end
      
      pos
    rescue InvalidInputError, ArgumentError
      puts "Invalid input! Please enter 2 numbers seperated by a comma."
      retry
    end
      
  end
  
end