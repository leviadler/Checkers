require './errors'

class Player
  
  attr_accessor :color
  attr_reader :name, :color_to_s
  
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
    puts "Type 'save' at any time to save game and exit."
    start_pos = get_input("Which piece would you like to move? (ex. 2,7)")
    
    return :save if start_pos == :save
    
    move_seq = []
    
    loop do
      move_seq << get_input("Where would you like to move to?")
      
      return :save if move_seq.include?(:save)
      
      puts "Make another move? (y/n)"
      another_move = gets.chomp
      break if another_move.downcase != "y"
    end
    
    [start_pos, move_seq]
  end
  
  def get_input(message)
    begin
      puts message
      # checking for save
      input = gets.chomp
      return :save if input.downcase == "save"
      
      input = input.squeeze.split(",")
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