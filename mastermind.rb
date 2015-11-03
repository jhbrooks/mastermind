# This class operates a Mastermind game
class Game
  def self.default_new(breaker_type, maker_type, turns, slots)
    Game.new(Player.new("Player 1", breaker_type),
             Player.new("Player 2", maker_type),
             Board.new(turns, slots))
  end

  def initialize(breaker, maker, board)
    @breaker = breaker
    @maker = maker
    @turns = board.turns
    @slots = board.slots
    @line_width = 80
    @valid_colors = %w(R O Y G I V)
    @state = State.new(maker, 1, 1, board)
  end

  def start
    set_target_row
    take_breaker_turn
  end

  private

  attr_reader :breaker, :maker, :turns, :slots,
              :line_width, :valid_colors, :state

  def set_target_row
    if state.current_player.type == :human
      human_select_and_make_moves_in(:target_rows)
    else
      computer_select_and_make_moves_in(:target_rows)
    end
    advance_player
  end

  def take_breaker_turn
    draw_board
    puts "It is #{state.current_player.name}'s turn.".center(line_width)
    select_and_make_moves_in(:rows)
    if state.win?
      win
    else
      advance_player
      take_maker_turn
    end
  end

  def take_maker_turn
    puts
    puts "It is #{state.current_player.name}'s turn.".center(line_width)
    score_row
    if state.board_full?
      win
    else
      advance_player
      advance_turn
      take_breaker_turn
    end
  end

  def draw_board
    puts
    puts state.board_graphic(line_width)
    puts
  end

  def score_row
    puts
    puts "#{state.current_player.name} doesn't bother to score the last row!"
  end

  def select_and_make_moves_in(section)
    if state.current_player.type == :human
      human_select_and_make_moves_in(section)
    else
      computer_select_and_make_moves_in(section)
    end
  end

  def human_select_and_make_moves_in(section)
    puts
    puts "Color options: #{valid_colors.join(', ')}."
    slots.times do |i|
      state.current_slot = i + 1
      make_move(section, human_color_mark)
    end
  end

  def computer_select_and_make_moves_in(section)
    slots.times do |i|
      state.current_slot = i + 1
      make_move(section, (valid_colors[rand(valid_colors.length)]))
    end
  end

  def human_color_mark
    puts "Please select a color for slot #{state.current_slot}."
    color_mark = gets.chomp!.upcase
    if !(valid_colors.include?(color_mark))
      puts "Invalid color! Please try again."
      human_color_mark
    else
      return color_mark
    end
  end

  def make_move(section, color_mark)
    state.update(section, color_mark)
  end

  def win
    puts
    puts state.target_graphic(line_width)
    draw_board
    puts "*** #{state.current_player.name} has won! ***".center(line_width)
    puts
  end

  def advance_player
    state.current_player = next_player
  end

  def advance_turn
    state.current_turn += 1
  end

  def next_player
    state.current_player == breaker ? maker : breaker
  end
end

# This class handles game state information
class State
  attr_accessor :current_player, :current_turn, :current_slot

  def initialize(current_player, current_turn, current_slot, board)
    @current_player = current_player
    @current_turn = current_turn
    @current_slot = current_slot
    @board = board
  end

  def board_graphic(line_width)
    board.rows_graphic(line_width)
  end

  def target_graphic(line_width)
    board.target_rows_graphic(line_width)
  end

  def update(section, color_mark)
    board.update(current_turn, current_slot, section, color_mark)
  end

  def win?
    last_turn_row == board.target_rows[0]
  end

  def board_full?
    board.full?
  end

  private

  attr_reader :board

  def last_turn_row
    board.row(current_turn)
  end
end

# This class handles board information
class Board
  attr_reader :turns, :slots, :target_rows

  def initialize(turns, slots)
    @turns = turns
    @slots = slots
    @rows = []
    turns.times do
      @rows << []
      slots.times do
        @rows[-1] << " "
      end
    end
    @target_rows = [[]]
    slots.times do
      @target_rows[-1] << " "
    end
  end

  def full?
    rows.all? do |row|
      row.none? { |slot| slot == " " }
    end
  end

  def update(row, column, section, color_mark)
    if section == :rows
      rows[turns - row][column - 1] = color_mark
    elsif section == :target_rows
      target_rows[row - 1][column - 1] = color_mark
    else
      puts "Score section not yet implemented."
    end
  end

  def row(row)
    rows[turns - row]
  end

  def rows_graphic(line_width)
    row_graphic_strings = rows.map do |row|
      "{ #{row.join(' | ')} }".center(line_width)
    end
    dash_string = ("--#{'-' * slots}#{'---' * (slots - 1)}")
    row_graphic_strings.join("\n#{dash_string.center(line_width)}\n")
  end

  def target_rows_graphic(line_width)
    "*** { #{target_rows[0].join(' | ')} } ***".center(line_width)
  end

  private

  attr_reader :rows
end

# This class handles player information
# * type should be :human or :computer (others will result in computer behavior)
class Player
  attr_reader :name, :type

  def initialize(name, type)
    @name = name
    @type = type
  end
end

g = Game.default_new(:computer, :human, 12, 4)
g.start
