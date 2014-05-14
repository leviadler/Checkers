class Piece
  
  UP_SLIDES = [[-1, -1], [-1, 1]]
  DOWN_SLIDES = [[-2, -2], [-2, 2]]
  UP_JUMPS = [[],[]]
  DOWN_JUMPS = [[].,[]]
  
  def initialize(color, position, board)
    @color = color
    @position = position
    @king = false
    @board = board
    board[position] = self
  end
  
  def perform_slide
    
  end
  
  def perform_jump
    
  end
  
  def move_diffs
    if king
      forward + backward
    elsif black
      forward
    elsif red
      backward
    end
  end
  
  def maybe_promote
    
  end
      
end