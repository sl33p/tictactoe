#just to say hello
require 'socket'

# TicTacToe class 
class TicTacToe
   
# intitialise the game by showing a flashy intro, setting up a new player   
   def initialise
     intro
     pick_player.new
     new_board
     show_board
   end

   # a hash of positions with empty values to kick things off
   def new_board
     @board = {'a1'=>' ','a2'=>' ','a3'=>' ','b1'=>' ','b2'=>' ','b3'=>' ','c1'=>' ','c2'=>' ','c3'=>' '}
   end
   
   
    # this method shows a new screen with the board and an optional message
    def show_board(msg = '')
    clr
    puts "    A   B   C  "
    puts "  -------------"
    puts "1 | #{@board["a1"]} | #{@board["b1"]} | #{@board["c1"]} |"
    puts "  -------------"
    puts "2 | #{@board["a2"]} | #{@board["b2"]} | #{@board["c2"]} |"    
    puts "  -------------"
    puts "3 | #{@board["a3"]} | #{@board["b3"]} | #{@board["c3"]} |"
    puts "  -------------"
    puts msg
    end

   # time to make a move. If your move is valid the computer gets to make their move, else it calls itself recursively 
   def make_move
      show_board("Let's put your #{@marker} on the board by\ntyping the letter-number coordinate.\n\n")
      the_move = gets.chomp
      if valid_move(the_move,@marker) then
        show_board("You picked #{the_move}. Great spot!")
        cpu_move  
        return
      else
        puts "That's not a valid move. Please specify your desired position"
        puts "using the letter-number coordinate system, e.g. A1 or C2."
        make_move
      end
      
   end
   
   def cpu_move
    #Set the computer to the anti-marker of the opponent
    @cpumarker = @marker == 'X' ? "O" : "X"
    #shuffle the board 
    tmp = Hash[@board.to_a.shuffle]
    # …and find the first empty spot. We're making a simpleton computer opponent. 
    tmp.each do |key, val|
      if val == ' '
        if valid_move(key,@cpumarker) then  
          sleep 2
          show_board("Computer picked #{key}. Freaky!")
          sleep 2
          make_move
        else
          cpu_move
        end
      end
    end   
   end
   
   
   def valid_move(the_move,the_marker)
    # place the X O marker on the board if the slot is free
    if @board[the_move] ==' '
      @board[the_move] = the_marker
      
      # check if we have a draw and ask for a new game
      if check_draw
        show_board("It sure looks like a draw, dang!")
        new_game_perhaps
      end
      
      # check if someone won and ask for a new game
      if check_did_someone_win(the_marker) 
        show_board("It looks like we have a winner\nCongratulations to #{the_marker}")
        new_game_perhaps
      end

     
      return TRUE   
     
      end
    return FALSE
   end
   
   
   # improvement: this should really not start everything over again, 
   # but rather remember you and let you play another game
   def new_game_perhaps
   
      puts "Do you want to play again? (answer Y or N)"
      reply = gets.chomp 
      if reply.upcase == "Y"
          game = TicTacToe.new
          game.initialise
      # no checks, you can type anything here. Only Y or y gives you a new game
      else
        puts "OK, #{@player}. Thanks for playing. Bye."
        exit
      end
   end
   
   
  # This is an example of something that could do with a proper test
  # checking for the presence of an empty slot on the board and returning TRUE 
  # if there's no empty places left
  def check_draw
    !@board.has_value?(" ")
  end
  
  # checking the 8 winning combinations, hardcoded, against the markers on the board. 
  # a full set gets you a win. Returns true
  def check_did_someone_win(the_marker)
   
    @winningCombos = [['a1','a2','a3'], ['b1','b2','b3'],['c1','c2','c3'], ['a1','b1','c1'],['a2','b2','c2'], ['a3','b3','c3'],['a1','b2','c3'], ['a3','b2','c1']]

    @winningCombos.any? do |combo|
      combo.all? {|pos| @board[pos] == the_marker}
    end   
  end
   
  # Introductions and picking if you're player X or player O 
  def pick_player
       
    puts "Let's play Tic Tac Toe!"
    puts "But first, let's get acquainted. I am your computer #{Socket.gethostname}"
    puts "What's your name?
    "

    # if you don't pick a name we'll pick a greeting for you
    @player = gets.chomp
      if @player == ''
      @player = 'Human friend'
    end
    
    # getting cracking already
    clr 
    puts "A pleaure to see you, #{@player}."
    puts "Please choose if you want to play as X or O"
    puts "by pressing the corresponding key on your keyboard.
    "
    input = ''
    until input == "x" || input =="o" do
      input = gets.chomp.upcase
      if input == "X" || input == "O"
        @marker = input
        puts "Thanks #{@player}, you picked #{@marker}, what's your move?\n"
        new_board
        make_move
      else
        puts "that's not an X or an O. Try again"
      end
    end
  end
   
   
   
   # Let's set the tone with an ANSI banner.
   # ==================================================================
   def intro
   clr
   puts"
████████╗██╗ ██████╗████████╗ █████╗  ██████╗████████╗ ██████╗ ███████╗
╚══██╔══╝██║██╔════╝╚══██╔══╝██╔══██╗██╔════╝╚══██╔══╝██╔═══██╗██╔════╝
   ██║   ██║██║        ██║   ███████║██║        ██║   ██║   ██║█████╗  
   ██║   ██║██║        ██║   ██╔══██║██║        ██║   ██║   ██║██╔══╝  
   ██║   ██║╚██████╗   ██║   ██║  ██║╚██████╗   ██║   ╚██████╔╝███████╗
   ╚═╝   ╚═╝ ╚═════╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝   ╚═╝    ╚═════╝ ╚══════╝
                                                                       "
   sleep 2
   end
   
  # ==================================================================
  # clearing the terminal made the gameplay a little easier to follow
  
   def clr
   system("clear")
   end
    
 end
 
 # kicking off
 game = TicTacToe.new
 game.initialise
