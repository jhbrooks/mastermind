# This module handles human behavior for Mastermind
# * Game must implement:
#   * make_move(section, mark)
#   * once_per_slot
module MastermindHuman
  def human_select_and_make_moves_in(section, valid_options)
    puts
    puts "Mark options: #{valid_options.join(', ')}."
    once_per_slot { make_move(section, human_mark(valid_options)) }
  end

  def human_mark(valid_options)
    puts "Please select a mark for slot #{state.current_slot}."
    mark = gets.chomp!.upcase
    if !(valid_options.include?(mark))
      puts "Invalid entry! Please try again."
      human_mark(valid_options)
    else
      return mark
    end
  end
end
