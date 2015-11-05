var search_data = {"index":{"searchIndex":["breakerai","makerai","mastermind","board","game","player","state","mastermindcomputer","mastermindhuman","board_code()","board_full?()","board_graphic()","board_graphic()","board_slot()","calculate_remaining_slots()","chosen_slots()","code()","code_strings()","computer_select_and_make_moves_in()","create()","current_code()","full?()","gather_last_turn_info()","human_mark()","human_select_and_make_moves_in()","make_informed_moves()","make_match_moves()","make_moves_to_gather_info()","make_partial_match_moves()","make_random_moves()","make_random_moves_from()","match?()","new()","new()","new()","new()","partial_match?()","previous_turn_section_mark()","process_info()","remaining_options()","retry_if_repeat()","score()","score_matches()","score_partial_matches()","score_strings()","section_mark()","set_row_decently()","set_score_perfectly()","slot()","sort_score()","start()","target_code()","target_code_freqs()","target_codes_graphic()","target_graphic()","update()","update()","win?()","readme"],"longSearchIndex":["breakerai","makerai","mastermind","mastermind::board","mastermind::game","mastermind::player","mastermind::state","mastermindcomputer","mastermindhuman","mastermind::state#board_code()","mastermind::state#board_full?()","mastermind::board#board_graphic()","mastermind::state#board_graphic()","mastermind::state#board_slot()","breakerai#calculate_remaining_slots()","breakerai#chosen_slots()","mastermind::board#code()","mastermind::board#code_strings()","mastermindcomputer#computer_select_and_make_moves_in()","mastermind::game::create()","mastermind::state#current_code()","mastermind::board#full?()","breakerai#gather_last_turn_info()","mastermindhuman#human_mark()","mastermindhuman#human_select_and_make_moves_in()","breakerai#make_informed_moves()","breakerai#make_match_moves()","breakerai#make_moves_to_gather_info()","breakerai#make_partial_match_moves()","makerai#make_random_moves()","breakerai#make_random_moves_from()","mastermind::state#match?()","mastermind::board::new()","mastermind::game::new()","mastermind::player::new()","mastermind::state::new()","mastermind::state#partial_match?()","breakerai#previous_turn_section_mark()","breakerai#process_info()","breakerai#remaining_options()","breakerai#retry_if_repeat()","mastermind::board#score()","makerai#score_matches()","makerai#score_partial_matches()","mastermind::board#score_strings()","makerai#section_mark()","breakerai#set_row_decently()","makerai#set_score_perfectly()","mastermind::board#slot()","mastermind::state#sort_score()","mastermind::game#start()","mastermind::board#target_code()","mastermind::state#target_code_freqs()","mastermind::board#target_codes_graphic()","mastermind::state#target_graphic()","mastermind::board#update()","mastermind::state#update()","mastermind::state#win?()",""],"info":[["BreakerAI","","BreakerAI.html","","<p>This module handles codebreaker AI\n<p>Game must implement:\n<p>make_move(section, mark)\n"],["MakerAI","","MakerAI.html","","<p>This module handles codemaker AI\n<p>Game must implement:\n<p>make_move(section, mark)\n"],["Mastermind","","Mastermind.html","","<p>This module wraps a Mastermind game in its own namespace\n"],["Mastermind::Board","","Mastermind/Board.html","","<p>This class handles board information\n"],["Mastermind::Game","","Mastermind/Game.html","","<p>This class operates a Mastermind game\n"],["Mastermind::Player","","Mastermind/Player.html","","<p>This class handles player information\n<p>type should be :human or :computer (others will result in computer …\n\n"],["Mastermind::State","","Mastermind/State.html","","<p>This class handles game state information\n"],["MastermindComputer","","MastermindComputer.html","","<p>This module handles computer behavior for Mastermind.\n<p>Game must implement:\n<p>make_move(section, mark)\n"],["MastermindHuman","","MastermindHuman.html","","<p>This module handles human behavior for Mastermind\n<p>Game must implement:\n<p>make_move(section, mark)\n"],["board_code","Mastermind::State","Mastermind/State.html#method-i-board_code","(row)",""],["board_full?","Mastermind::State","Mastermind/State.html#method-i-board_full-3F","()",""],["board_graphic","Mastermind::Board","Mastermind/Board.html#method-i-board_graphic","(line_width)",""],["board_graphic","Mastermind::State","Mastermind/State.html#method-i-board_graphic","(line_width)",""],["board_slot","Mastermind::State","Mastermind/State.html#method-i-board_slot","(row, column, section)",""],["calculate_remaining_slots","BreakerAI","BreakerAI.html#method-i-calculate_remaining_slots","()",""],["chosen_slots","BreakerAI","BreakerAI.html#method-i-chosen_slots","()",""],["code","Mastermind::Board","Mastermind/Board.html#method-i-code","(row)",""],["code_strings","Mastermind::Board","Mastermind/Board.html#method-i-code_strings","(line_width)",""],["computer_select_and_make_moves_in","MastermindComputer","MastermindComputer.html#method-i-computer_select_and_make_moves_in","(section, valid_options)",""],["create","Mastermind::Game","Mastermind/Game.html#method-c-create","(breaker_type, maker_type, turns, slots)",""],["current_code","Mastermind::State","Mastermind/State.html#method-i-current_code","()",""],["full?","Mastermind::Board","Mastermind/Board.html#method-i-full-3F","()",""],["gather_last_turn_info","BreakerAI","BreakerAI.html#method-i-gather_last_turn_info","()",""],["human_mark","MastermindHuman","MastermindHuman.html#method-i-human_mark","(valid_options)",""],["human_select_and_make_moves_in","MastermindHuman","MastermindHuman.html#method-i-human_select_and_make_moves_in","(section, valid_options)",""],["make_informed_moves","BreakerAI","BreakerAI.html#method-i-make_informed_moves","(section)",""],["make_match_moves","BreakerAI","BreakerAI.html#method-i-make_match_moves","(remaining_options, chosen_slots, section)",""],["make_moves_to_gather_info","BreakerAI","BreakerAI.html#method-i-make_moves_to_gather_info","(section, valid_options)",""],["make_partial_match_moves","BreakerAI","BreakerAI.html#method-i-make_partial_match_moves","(remaining_options, chosen_slots, section)",""],["make_random_moves","MakerAI","MakerAI.html#method-i-make_random_moves","(section, valid_options)",""],["make_random_moves_from","BreakerAI","BreakerAI.html#method-i-make_random_moves_from","(section, valid_options)",""],["match?","Mastermind::State","Mastermind/State.html#method-i-match-3F","(code_mark, target_mark)",""],["new","Mastermind::Board","Mastermind/Board.html#method-c-new","(turns, slots)",""],["new","Mastermind::Game","Mastermind/Game.html#method-c-new","(breaker, maker, board)",""],["new","Mastermind::Player","Mastermind/Player.html#method-c-new","(name, type)",""],["new","Mastermind::State","Mastermind/State.html#method-c-new","(current_player, current_turn, current_slot, board)",""],["partial_match?","Mastermind::State","Mastermind/State.html#method-i-partial_match-3F","(code_mark)",""],["previous_turn_section_mark","BreakerAI","BreakerAI.html#method-i-previous_turn_section_mark","(section)",""],["process_info","BreakerAI","BreakerAI.html#method-i-process_info","()",""],["remaining_options","BreakerAI","BreakerAI.html#method-i-remaining_options","(section)",""],["retry_if_repeat","BreakerAI","BreakerAI.html#method-i-retry_if_repeat","(section)",""],["score","Mastermind::Board","Mastermind/Board.html#method-i-score","(code)",""],["score_matches","MakerAI","MakerAI.html#method-i-score_matches","(section, valid_options)",""],["score_partial_matches","MakerAI","MakerAI.html#method-i-score_partial_matches","(section, valid_options)",""],["score_strings","Mastermind::Board","Mastermind/Board.html#method-i-score_strings","()",""],["section_mark","MakerAI","MakerAI.html#method-i-section_mark","(section)",""],["set_row_decently","BreakerAI","BreakerAI.html#method-i-set_row_decently","(section, valid_options)",""],["set_score_perfectly","MakerAI","MakerAI.html#method-i-set_score_perfectly","(section, valid_options)",""],["slot","Mastermind::Board","Mastermind/Board.html#method-i-slot","(row, column, section)",""],["sort_score","Mastermind::State","Mastermind/State.html#method-i-sort_score","()",""],["start","Mastermind::Game","Mastermind/Game.html#method-i-start","()",""],["target_code","Mastermind::Board","Mastermind/Board.html#method-i-target_code","()",""],["target_code_freqs","Mastermind::State","Mastermind/State.html#method-i-target_code_freqs","()",""],["target_codes_graphic","Mastermind::Board","Mastermind/Board.html#method-i-target_codes_graphic","(line_width)",""],["target_graphic","Mastermind::State","Mastermind/State.html#method-i-target_graphic","(line_width)",""],["update","Mastermind::Board","Mastermind/Board.html#method-i-update","(row, column, section, mark)",""],["update","Mastermind::State","Mastermind/State.html#method-i-update","(section, color_mark)",""],["win?","Mastermind::State","Mastermind/State.html#method-i-win-3F","()",""],["README","","README_md.html","","<p>mastermind\n<p>Mastermind implementation in Ruby\n"]]}}