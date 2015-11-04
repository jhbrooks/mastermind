# This module handles computer AI for Mastermind
# * Game must implement:
#   * make_move(move)
#   * slots
# * Game.state must implement:
#   * current_turn
#   * current_slot, current_slot=
#   * board_slot(row, column, section)
#   * match_freqs
#   * match?
#   * partial_match?
module MastermindAI
  def computer_select_and_make_moves_in(section, valid_options)
    if section == :scores
      set_score_perfectly(section, valid_options)
    elsif section == :codes
      set_row_decently(section, valid_options)
    else
      make_random_moves(section, valid_options)
    end
  end

  def set_score_perfectly(section, valid_options)
    state.match_freqs.clear
    score_matches(section, valid_options)
    score_partial_matches(section, valid_options)
  end

  def score_matches(section, valid_options)
    slots.times do |i|
      state.current_slot = i + 1
      code_mark = state.board_slot(state.current_turn, state.current_slot, :codes)
      target_mark = state.board_slot(state.current_turn, state.current_slot, :target_codes)
      if state.match?(code_mark, target_mark)
        make_move(section, valid_options[0])
        state.match_freqs[code_mark] += 1
      else
        make_move(section, valid_options[2])
      end
    end
    state.match_freqs.each do |mark, freq|
      state.cummulative_match_freqs[mark] += freq
    end
  end

  def score_partial_matches(section, valid_options)
    slots.times do |i|
      state.current_slot = i + 1
      code_mark = state.board_slot(state.current_turn, state.current_slot, :codes)
      target_mark = state.board_slot(state.current_turn, state.current_slot, :target_codes)
      if state.partial_match?(code_mark) && !(state.match?(code_mark, target_mark))
        make_move(section, valid_options[1])
        state.match_freqs[code_mark] += 1
      end
    end
  end

  def set_row_decently(section, valid_options)
    total_matches = state.cummulative_match_freqs.reduce(0) do |c, (mark, freq)|
      c + freq
    end
    if total_matches < slots
      mark = valid_options[state.current_turn - 1]
      slots.times do |i|
        state.current_slot = i + 1
        make_move(section, mark)
      end
    elsif total_matches == slots && state.gathering_info
      state.gathering_info = false
      state.cummulative_match_freqs.each do |mark, freq|
        freq.times do  
          state.current_options << mark
        end
      end
      make_random_moves_from(section, state.current_options)
    else
      make_informed_moves(section)
    end
  end

  def make_informed_moves(section)
    remaining_options = []
    previous_turn_code = state.board_code(state.current_turn - 1)
    previous_turn_code.each do |mark|
      remaining_options << mark
    end

    score_freqs = Hash.new(0)
    previous_turn_score = state.board_score(state.current_turn - 1)
    previous_turn_score.each do |mark|
      score_freqs[mark] += 1
    end

    remaining_indices = []
    slots.times do |i|
      remaining_indices << (i + 1)
    end

    chosen_indices = []
    score_freqs[score_marks[0]].times do
      chosen_index = remaining_indices[rand(remaining_indices.length)]
      chosen_indices << chosen_index
      remaining_indices.delete(chosen_index)
    end

    slots.times do |i|
      state.current_slot = i + 1
      if chosen_indices.include?(state.current_slot)
        chosen_mark = previous_turn_code[state.current_slot - 1]
        make_move(section, chosen_mark)
        remaining_options.delete_at(remaining_options.find_index(chosen_mark))
      end
    end

    slots.times do |i|
      state.current_slot = i + 1
      if !(chosen_indices.include?(state.current_slot))
        chosen_mark = remaining_options[rand(remaining_options.length)]
        make_move(section, chosen_mark)
        remaining_options.delete_at(remaining_options.find_index(chosen_mark))
      end
    end

    # retry if repeat
    previous_board_codes = []
    (state.current_turn - 1).times do |i|
      previous_board_codes << state.board_code(i + 1)
    end
    if previous_board_codes.include?(state.current_code)
      make_informed_moves(section)
    end
  end

  def make_random_moves_from(section, valid_options)
    remaining_options = []
    valid_options.each do |mark|
      remaining_options << mark
    end
    slots.times do |i|
      state.current_slot = i + 1
      chosen_mark = remaining_options[rand(remaining_options.length)]
      make_move(section, chosen_mark)
      remaining_options.delete_at(remaining_options.find_index(chosen_mark))
    end
  end

  def make_random_moves(section, valid_options)
    slots.times do |i|
      state.current_slot = i + 1
      make_move(section, (valid_options[rand(valid_options.length)]))
    end
  end
end
