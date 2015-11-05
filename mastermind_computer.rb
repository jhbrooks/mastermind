# This module handles codebreaker AI
# * Game must implement:
#   * make_move(section, mark)
#   * slots
#   * score_marks
#   * once_per_slot
# * Game.state must implement:
#   * current_turn
#   * gathering_info
#   * running_match_freqs
#   * current_slot
#   * board_slot(row, column, section)
#   * current_options
#   * board_code(row)
#   * current_code
module BreakerAI
  def set_row_decently(section, valid_options)
    gather_last_turn_info if state.current_turn > 1 && state.gathering_info

    total_matches = state.running_match_freqs.values.reduce(0, :+)
    if total_matches < slots
      make_moves_to_gather_info(section, valid_options)
    elsif total_matches >= slots && state.gathering_info
      process_info
      make_random_moves_from(section, state.current_options)
    else
      make_informed_moves(section)
    end
  end

  def gather_last_turn_info
    once_per_slot do
      if previous_turn_section_mark(:scores) == score_marks[0]
        state.running_match_freqs[previous_turn_section_mark(:codes)] += 1
      end
    end
  end

  def previous_turn_section_mark(section)
    state.board_slot((state.current_turn - 1), state.current_slot, section)
  end

  def make_moves_to_gather_info(section, valid_options)
    mark = valid_options[(state.current_turn - 1) % valid_options.length]
    once_per_slot { make_move(section, mark) }
  end

  def process_info
    state.gathering_info = false
    state.running_match_freqs.each do |mark, freq|
      freq.times { state.current_options << mark }
    end
  end

  def make_informed_moves(section)
    make_match_moves(remaining_options(section), chosen_slots, section)
    begin
      retry_if_repeat(section)
    rescue SystemStackError
      puts "\nThe computer is confused! It reminds you to watch your scoring."
      state.gathering_info = true
      state.running_match_freqs.clear
    end
  end

  def remaining_options(section)
    remaining_options = []
    once_per_slot { remaining_options << previous_turn_section_mark(section) }
    remaining_options
  end

  def chosen_slots
    remaining_slots = calculate_remaining_slots
    chosen_slots = []
    once_per_slot do
      next unless previous_turn_section_mark(:scores) == score_marks[0]
      chosen_slot = remaining_slots[rand(remaining_slots.length)]
      chosen_slots << chosen_slot
      remaining_slots.delete(chosen_slot)
    end
    chosen_slots
  end

  def calculate_remaining_slots
    remaining_slots = []
    slots.times { |i| remaining_slots << (i + 1) }
    remaining_slots
  end

  def make_match_moves(remaining_options, chosen_slots, section)
    once_per_slot do
      next unless chosen_slots.include?(state.current_slot)
      chosen_mark = previous_turn_section_mark(section)
      make_move(section, chosen_mark)
      remaining_options.delete_at(remaining_options.find_index(chosen_mark))
    end

    make_partial_match_moves(remaining_options, chosen_slots, section)
  end

  def make_partial_match_moves(remaining_options, chosen_slots, section)
    once_per_slot do
      next if chosen_slots.include?(state.current_slot)
      chosen_mark = remaining_options[rand(remaining_options.length)]
      make_move(section, chosen_mark)
      remaining_options.delete_at(remaining_options.find_index(chosen_mark))
    end
  end

  def retry_if_repeat(section)
    previous_board_codes = []
    (state.current_turn - 1).times do |i|
      previous_board_codes << state.board_code(i + 1)
    end
    repeat = previous_board_codes.include?(state.current_code)
    make_informed_moves(section) if repeat
  end

  def make_random_moves_from(section, valid_options)
    remaining_options = []
    valid_options.each { |mark| remaining_options << mark }
    once_per_slot do
      chosen_mark = remaining_options[rand(remaining_options.length)]
      make_move(section, chosen_mark)
      remaining_options.delete_at(remaining_options.find_index(chosen_mark))
    end
  end
end

# This module handles codemaker AI
# * Game must implement:
#   * make_move(section, mark)
#   * once_per_slot
# * Game.state must implement:
#   * current_turn
#   * current_slot
#   * board_slot(row, column, section)
#   * match_freqs
#   * match?
#   * partial_match?
module MakerAI
  def set_score_perfectly(section, valid_options)
    state.match_freqs.clear
    score_matches(section, valid_options)
    score_partial_matches(section, valid_options)
  end

  def score_matches(section, valid_options)
    once_per_slot do
      code_mark = section_mark(:codes)
      if state.match?(code_mark, section_mark(:target_codes))
        make_move(section, valid_options[0])
        state.match_freqs[code_mark] += 1
      else
        make_move(section, valid_options[2])
      end
    end
  end

  def score_partial_matches(section, valid_options)
    once_per_slot do
      code_mark = section_mark(:codes)
      next if state.match?(code_mark, section_mark(:target_codes))
      next unless state.partial_match?(code_mark)
      make_move(section, valid_options[1])
      state.match_freqs[code_mark] += 1
    end
  end

  def section_mark(section)
    state.board_slot(state.current_turn, state.current_slot, section)
  end

  def make_random_moves(section, valid_options)
    once_per_slot do
      make_move(section, (valid_options[rand(valid_options.length)]))
    end
  end
end

# This module handles computer behavior for Mastermind.
# * Game must implement:
#   * make_move(section, mark)
#   * slots
#   * score_marks
#   * once_per_slot
# * Game.state must implement:
#   * current_turn
#   * current_slot
#   * gathering_info
#   * running_match_freqs
#   * match_freqs
#   * match?
#   * partial_match?
#   * board_slot(row, column, section)
#   * board_code(row)
#   * current_options
#   * current_code
module MastermindComputer
  include BreakerAI
  include MakerAI

  def computer_select_and_make_moves_in(section, valid_options)
    if section == :scores
      set_score_perfectly(section, valid_options)
    elsif section == :codes
      set_row_decently(section, valid_options)
    else
      make_random_moves(section, valid_options)
    end
  end
end
