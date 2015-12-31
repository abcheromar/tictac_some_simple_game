  # !/usr/bin/env ruby

  #abcher omar Flatiron Fellowship 2013 code challenge 

  # This is a simple Tic Tac Toe I made in the past 3 days
  # The game is played against the computer using the console
  # You can run it with 'ruby tic.rb' on the console and it shoud be fine
  # The code is pretty basic. It's the best I could make this week with
  # some help from my childhood Tic Tac Toe memories and some googling
  #I have spent the last two days when I had time trying to implement
  # the minimax algorithm here at http://en.wikipedia.org/wiki/Minimax
  #i wanted to make tic tac toe the computer will always win
  #Sadly I am submitting the game w/o the algorithm that would make it
  #owesome: i don't fully understand the recurstions involved so far
  #There is some C code examples and pseudocode but I didnt implement it. 
  # #In this version the computer randonly selects out of the 9 game
  # slots and wins only when the human player is not watching out
  #or it gets luck.
  #let's play!


class Game_of_tic

 def initialize()

  #these insrance vars are only called on the first run.
  def game_launcher()
    @computer = "computer"
    @human    = "human"
    @computer_score = 0
    @human_score = 0
    @game_turns = 0
    who_goes_first()
  end

  # this method initializes game board and winning combinations array 
  # and randonly chooses who will go first and take 'X'

  def who_goes_first()
    @board = {one: "#", two: "#", three: "#",
      four: "#", five: "#",six: "#", seven: "#", 
      eight: "#", nine: "#"}

    @winnng_combo = [
      [:one, :two, :three],[:four, :five, :six], [:seven, :eight, :nine], 
      [:one, :four, :seven], [:two, :five, :eight],[:three, :six, :nine],
      [:one, :five, :nine], [:three, :five, :seven] ]

    if rand() < 0.5 
      @computer_mark = "X"; @human_mark = "O"
      computer_play()
    else  
      @human_mark = "X"; @computer_mark = "O" 
      human_play()
    end    
  end

  #this one handles the computer turn and passes the ball back.
  def computer_play()
    @empties = []
    @board.map do |k,v| 
      @empties << k if v != 'X' && v != 'O' 
    end
    
    @comp_marks = [] 
    @board.map do |k,v| 
      @comp_marks << v if v == @computer_mark
    end

    @hum_marks = []
    @board.collect do |k,v| 
      @hum_marks << v if v == @human_mark
    end

    @random_slot = @empties[rand(0..@empties.length-1)]
      puts "-" * 50
      puts "Computer is playing: #{@computer_mark}"
      puts "Computer takes number:#{@random_slot}"
      puts "Computer score is: #{@computer_score}"
      @board[@random_slot] = @computer_mark
      gamer_setup()
      update_board(@human)
  end

  #simple game display for looks as I dont have web-based version
  def gamer_setup()
    puts "-" * 50
    puts ""
    puts   "       #{@board[:one]}  | #{@board[:two]} |  #{@board[:three]}"
    puts   "      ----|---|----"
    puts   "       #{@board[:four]}  | #{@board[:five]} |  #{@board[:six]}"
    puts   "      ----|---|----"
    puts   "       #{@board[:seven]}  | #{@board[:eight]} |  #{@board[:nine]}"
    puts ""
    puts "-" * 50
    sleep(1) # i use this pause so game changes can be somewhat seen
     
  end  

  #show updates when computer takes first turn
  def set_up()
   puts "-" * 50
   puts "We are playing a game of TIC TAC TOE"
   puts "The computer is busy thinking..."
   puts "please wait..."
   sleep(1)
   puts "Here is the computer's move:"
  end

  #this one handles the human input and calls helpers to update board
  def human_play()
    if @game_turns == 0  
       @game_turns += 1
       greeter()
       valid_slot?()
    else 
       gamer_setup()
       valid_slot?()
      end
  end

  #say hi to human, capitalize name too
  def greeter()
    puts "-" * 50
    puts "-" * 50
    puts "Hi, your name is..?"
    @human_name = gets.chomp().capitalize
    puts "Let's play game of TIC TAC TOES,#{@human_name}"  
    gamer_setup()
       
  end 

  #makes sure inputs are good, that is, they
  #correspond to empty slots that exists in the board
  def valid_slot?()
    puts "Choose an empty slot from these above"
    puts "Type one, two, three and so on"
    puts "The 3x3 board stands for the 9 numbers:1..9"
    puts "Game is won when either human or comnputer 
           creates a row"
    @slot = gets.chomp() 
    slot =  @slot.to_sym

    if @board.keys.include?(slot) && @board[slot] == "#"
      puts "Human is playing:#{@human_mark}"
      puts "Human takes number:#{@slot}"
      puts "Human score is: #{@human_score}"
      @board[slot] = @human_mark
      gamer_setup
      update_board(@computer)
    else
      puts " "
      puts "Choose a number that is not taken!"
      gamer_setup
      puts " "
      valid_slot?()

    end
  end

  #this one orchestrates the action for human and computer
  def update_board(player)
    game_status()
    if player == @computer
      computer_play()
    elsif !@board.values.include?(@human_mark)
      human_play()
    else
        valid_slot?()
    end
  end

  #this method, the largest, updates the game for each play
  #and reports game status to the human 
  def game_status()

    @comp_slots = []
    @board.map do |k,v| 
       @comp_slots << k if v == @computer_mark
    end

    @hum_slots = []
    @board.map do |k,v| 
      @hum_slots << k if v == @human_mark
    end

    @winnng_combo.each do |sub_array|
      if (sub_array & @hum_slots).length == 3
        puts "Success for human!"
        @human_score +=1 
        puts "Human score is #{@human_score}"
        restart_game()
      elsif (sub_array & @comp_slots).length == 3
        puts "Success for computer indeed!"
         @computer_score += 1 
         puts "Computer score is #{@computer_score}"
         restart_game()
       elsif !@board.values.include?("#")

          puts "It's a draw!"
          puts "Score for #{@human_name} is #{@human_score}"
          puts "Score for computer is #{@computer_score}"
          puts "Let'd do it again!"

          restart_game()
       
       end
    end
  end

  #let's play again! 
  def restart_game()
    puts "wanna play again,#{@human_name}?"
    puts "Type (y / yes) to play. Or type (n / no) to leave."
    answer = gets.chomp
    if answer == "n" || answer == "no" 
      abort("Good bye!")

    elsif answer == "y" || answer == "yes" 
      puts "ok..."
      who_goes_first()
    else 
      puts 'Please choose to play or leave.'
      restart_game()   
      end
  end

  game_launcher()
 end 
end

#create game instance
game = Game_of_tic.new
