require "./mastermind_human"
require "./mastermind_computer"

# This class operates a Mastermind game
class Game
  include MastermindHuman
  include MastermindComputer

  def self.create(breaker_type, maker_type, turns, slots)
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
    @code_marks = %w(R O Y G I V)
    @score_marks = %w(B W -)
    @state = State.new(maker, 1, 1, board)
  end

  def start
    set_section(:target_codes, code_marks)
    advance_player
    take_breaker_turn
  end

  private

  attr_reader :breaker, :maker, :turns, :slots,
              :line_width, :code_marks, :score_marks, :state

  def set_section(section, valid_options)
    if state.current_player.type == :human
      human_select_and_make_moves_in(section, valid_options)
    else
      computer_select_and_make_moves_in(section, valid_options)
    end
  end

  def take_breaker_turn
    draw_board
    puts "It is #{state.current_player.name}'s turn.".center(line_width)
    set_section(:codes, code_marks)
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
    set_section(:scores, score_marks)
    state.sort_score
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

  def once_per_slot
    slots.times do |i|
      state.current_slot = i + 1
      yield
    end
  end

  def make_move(section, mark)
    state.update(section, mark)
  end

  def win
    draw_target
    draw_board
    puts "*** #{state.current_player.name} has won! ***".center(line_width)
    puts
  end

  def draw_target
    puts
    puts state.target_graphic(line_width)
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
  attr_accessor :current_player, :current_turn, :current_slot, :gathering_info,
                :match_freqs, :running_match_freqs, :current_options

  def initialize(current_player, current_turn, current_slot, board)
    @current_player = current_player
    @current_turn = current_turn
    @current_slot = current_slot
    @gathering_info = true
    @match_freqs = Hash.new(0)
    @running_match_freqs = Hash.new(0)
    @current_options = []
    @board = board
  end

  def board_graphic(line_width)
    board.board_graphic(line_width)
  end

  def target_graphic(line_width)
    board.target_codes_graphic(line_width)
  end

  def update(section, color_mark)
    board.update(current_turn, current_slot, section, color_mark)
  end

  def win?
    current_code == board.target_code
  end

  def board_full?
    board.full?
  end

  def board_slot(row, column, section)
    board.slot(row, column, section)
  end

  def board_code(row)
    board.code(row)
  end

  def match?(code_mark, target_mark)
    code_mark == target_mark
  end

  def partial_match?(code_mark)
    board.target_code.include?(code_mark) &&
      match_freqs[code_mark] < target_code_freqs[code_mark]
  end

  def target_code_freqs
    marks_and_freqs = Hash.new(0)
    board.target_code.each do |mark|
      marks_and_freqs[mark] += 1
    end
    marks_and_freqs
  end

  def sort_score
    board.score(current_turn).sort!.reverse!
  end

  def current_code
    board_code(current_turn)
  end

  private

  attr_reader :board
end

# This class handles board information
class Board
  attr_reader :turns, :slots

  def initialize(turns, slots)
    @turns = turns
    @slots = slots
    @codes = []
    @target_codes = [[]]
    @scores = []
    turns.times do
      @codes << []
      @scores << []
      slots.times do
        @codes[-1] << " "
        @scores[-1] << " "
      end
    end
    slots.times { @target_codes[-1] << " " }
  end

  def full?
    codes.all? do |code|
      code.none? { |slot| slot == " " }
    end
  end

  def update(row, column, section, mark)
    if section == :codes
      codes[turns - row][column - 1] = mark
    elsif section == :target_codes
      target_code[column - 1] = mark
    else
      scores[turns - row][column - 1] = mark
    end
  end

  def slot(row, column, section)
    if section == :codes
      return codes[turns - row][column - 1]
    elsif section == :target_codes
      return target_code[column - 1]
    else
      return scores[turns - row][column - 1]
    end
  end

  def code(row)
    codes[turns - row]
  end

  def target_code
    target_codes[0]
  end

  def score(code)
    scores[turns - code]
  end

  def board_graphic(line_width)
    board_strings = []
    stored_score_strings = score_strings
    code_strings(line_width).each_with_index do |code_string, i|
      board_strings << ("#{code_string} #{stored_score_strings[i]}")
    end
    dash_string = ("--#{'-' * slots}#{'---' * (slots - 1)}")
    board_strings.join("\n#{dash_string.center(line_width)}\n")
  end

  def code_strings(line_width)
    code_strings = codes.map do |code|
      code_string = "{ #{code.join(' | ')} }"
      code_string.rjust((line_width / 2) + (code_string.length / 2))
    end
    code_strings
  end

  def score_strings
    scores.map { |score| "[#{score.join(':')}]" }
  end

  def target_codes_graphic(line_width)
    "*** { #{target_code.join(' | ')} } ***".center(line_width)
  end

  private

  attr_reader :codes, :target_codes, :scores
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

g = Game.create(:computer, :human, 12, 4)
g.start
