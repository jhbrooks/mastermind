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
    @valid_scores = %w(B W -)
    @state = State.new(maker, 1, 1, board)
  end

  def start
    set_target_row
    take_breaker_turn
  end

  private

  attr_reader :breaker, :maker, :turns, :slots,
              :line_width, :valid_colors, :valid_scores, :state

  def set_target_row
    if state.current_player.type == :human
      human_select_and_make_moves_in(:target_rows, valid_colors)
    else
      computer_select_and_make_moves_in(:target_rows, valid_colors)
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
    draw_board
    puts "It is #{state.current_player.name}'s turn.".center(line_width)
    score_row
    state.sort_score_row
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
    if state.current_player.type == :human
      human_select_and_make_moves_in(:score_rows, valid_scores)
    else
      computer_select_and_make_moves_in(:score_rows, valid_scores)
    end
  end

  def select_and_make_moves_in(section)
    if state.current_player.type == :human
      human_select_and_make_moves_in(section, valid_colors)
    else
      computer_select_and_make_moves_in(section, valid_colors)
    end
  end

  def human_select_and_make_moves_in(section, valid_options)
    puts
    puts "Color options: #{valid_options.join(', ')}."
    slots.times do |i|
      state.current_slot = i + 1
      make_move(section, human_mark(valid_options))
    end
  end

  def computer_select_and_make_moves_in(section, valid_options)
    if section == :score_rows
      state.match_freqs.clear
      slots.times do |i|
        state.current_slot = i + 1
        current_row_mark = state.board_slot(state.current_turn, state.current_slot, :rows)
        current_target_mark = state.board_slot(state.current_turn, state.current_slot, :target_rows)
        if state.match?(current_row_mark, current_target_mark)
          make_move(section, valid_options[0])
          state.match_freqs[current_row_mark] += 1
        else
          make_move(section, valid_options[2])
        end
      end
      slots.times do |i|
        state.current_slot = i + 1
        current_row_mark = state.board_slot(state.current_turn, state.current_slot, :rows)
        current_target_mark = state.board_slot(state.current_turn, state.current_slot, :target_rows)
        if state.partial_match?(current_row_mark) && !(state.match?(current_row_mark, current_target_mark))
          make_move(section, valid_options[1])
          state.match_freqs[current_row_mark] += 1
        end
      end
    else
      slots.times do |i|
        state.current_slot = i + 1
        make_move(section, (valid_options[rand(valid_options.length)]))
      end
    end
  end

  def human_mark(valid_options)
    puts "Please select a color for slot #{state.current_slot}."
    mark = gets.chomp!.upcase
    if !(valid_options.include?(mark))
      puts "Invalid color! Please try again."
      human_mark(valid_options)
    else
      return mark
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
  attr_accessor :current_player, :current_turn, :current_slot, :match_freqs

  def initialize(current_player, current_turn, current_slot, board)
    @current_player = current_player
    @current_turn = current_turn
    @current_slot = current_slot
    @match_freqs = Hash.new(0)
    @board = board
  end

  def board_graphic(line_width)
    board.board_graphic(line_width)
  end

  def target_graphic(line_width)
    board.target_rows_graphic(line_width)
  end

  def update(section, color_mark)
    board.update(current_turn, current_slot, section, color_mark)
  end

  def win?
    current_row == board.target_rows[0]
  end

  def board_full?
    board.full?
  end

  def board_slot(row, column, section)
    board.slot(row, column, section)
  end

  def match?(current_row_mark, current_target_mark)
    current_row_mark == current_target_mark
  end

  def partial_match?(current_row_mark)
    p current_row_mark
    p match_freqs
    p board.target_rows[0]
    p target_row_freqs
    board.target_rows[0].include?(current_row_mark) &&
      match_freqs[current_row_mark] < target_row_freqs[current_row_mark]
  end

  def target_row_freqs
    marks_and_freqs = Hash.new(0)
    board.target_rows[0].each do |mark|
      marks_and_freqs[mark] += 1
    end
    marks_and_freqs
  end

  def sort_score_row
    board.score_rows[board.turns - current_turn].sort!.reverse!
  end

  private

  attr_reader :board

  def current_row
    board.row(current_turn)
  end
end

# This class handles board information
class Board
  attr_reader :turns, :slots, :target_rows, :score_rows

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
    @score_rows = []
    turns.times do
      @score_rows << []
      slots.times do
        @score_rows[-1] << " "
      end
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
      target_rows[0][column - 1] = color_mark
    else
      score_rows[turns - row][column - 1] = color_mark
    end
  end

  def slot(row, column, section)
    if section == :rows
      return rows[turns - row][column - 1]
    else
      return target_rows[0][column - 1]
    end
  end

  def row(row)
    rows[turns - row]
  end

  def board_graphic(line_width)
    board_strings = []
    stored_score_row_strings = score_row_strings
    row_strings(line_width).each_with_index do |row_string, i|
      board_strings << ("#{row_string} #{stored_score_row_strings[i]}")
    end
    dash_string = ("--#{'-' * slots}#{'---' * (slots - 1)}")
    board_strings.join("\n#{dash_string.center(line_width)}\n")
  end

  def row_strings(line_width)
    row_strings = rows.map do |row|
      row_string = "{ #{row.join(' | ')} }"
      row_string.rjust((line_width / 2) + (row_string.length / 2))
    end
    row_strings
  end

  def score_row_strings
    score_row_strings = score_rows.map do |score_row|
      "[#{score_row.join(':')}]"
    end
    score_row_strings
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

g = Game.default_new(:human, :computer, 8, 4)
g.start
