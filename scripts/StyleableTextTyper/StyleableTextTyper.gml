/**
 * @param {Struct.New_StyleableText} text
 * @param {Struct.StyleableTextAnimator} animator
 */
function StyleableTextTyper(text, animator) constructor {
	typer_text = text;
	typer_animator = animator;
	
	if (typer_animator.text != typer_text) show_error("Given animator for StyleableTextTyper does not reference given StyleableText!", true);
	
	time_between_types_ms = 80;
	time_ms = 0;
	chars_per_type = 2.4;
	
	// mapping between indexes of chars and array of entry animations for said chars
	entry_animations_map = {};
	
	add_type_animation_at = function(index, animation_enum, aargs) {
		if (!struct_exists(entry_animations_map, index)) struct_set(entry_animations_map, index, []);
		array_push(struct_get(entry_animations_map, index), { animation_enum, aargs });
	};
	
	/*
	When typing a char, we check if there are any type animations mapped to it. If so we add a new
	animation of that type with associated aargs to the animator.
	*/
	start_type_animation_at = function(index) {
		if (!struct_exists(entry_animations_map, index)) return;
		var animations = struct_get(entry_animations_map, index);
		for (var i = 0; i < array_length(animations); i++) {
			typer_animator.add_animation(animations[i].animation_enum, index, index, animations[i].aargs);
		}
	};
	
	// callback function invoked when type occurs
	on_type = function() {
		// default is blank function
	};
	
	punctuation_pause_map = {};
	
	struct_set(punctuation_pause_map, ".", 800);
	struct_set(punctuation_pause_map, "!", 800);
	struct_set(punctuation_pause_map, "?", 800);
	struct_set(punctuation_pause_map, ",", 500);
	struct_set(punctuation_pause_map, ":", 500);
	struct_set(punctuation_pause_map, ";", 500);
	struct_set(punctuation_pause_map, "-", 500);

	// pause timings for individual character indexes
	character_pause_map = {};
	
	set_character_index_pause = function(index, pause_time) {
		struct_set(character_pause_map, index, pause_time);
	};
	
	// on_type callbacks for individual character indexes
	character_on_type_map = {};
	
	set_character_index_on_type = function(index, callback) {
		struct_set(character_on_type_map, index, callback);
	};
	
	// Characters are hidden by default. They get "typed" by leaving the range of hidden indexs.
	// Initially no characters are hidden. User must manually tell typing to "reset".
	pages_hide_start_end = [];
	for (var i = 0; i <= typer_text.text_page_index_max; i++) {
		array_push(pages_hide_start_end, {
			index_current: typer_text.text_page_char_index_end[i] + 1,
			index_end: typer_text.text_page_char_index_end[i]
		});
	}
	
	reset_typing = function() {
		time_ms = 0;
		typer_animator.remove_finishable_animations();
		for (var i = 0; i < array_length(pages_hide_start_end); i++) {
			pages_hide_start_end[i].index_current = typer_text.text_page_char_index_start[i];
		}
	};
	
	finish_typing_current_page = function() {
		time_ms = 0;
		typer_animator.remove_finishable_animations();
		pages_hide_start_end[typer_text.text_page_index].index_current = typer_text.text_page_char_index_end[typer_text.text_page_index] + 1;
	};
	
	// a page is considered "typed" if the current hide index is greater than the end index
	get_current_page_finished = function() {
		return pages_hide_start_end[typer_text.text_page_index].index_current > typer_text.text_page_char_index_end[typer_text.text_page_index];
	}
	
	update = function(update_time_ms = 1000/game_get_speed(gamespeed_fps)) {
		var hide = pages_hide_start_end[typer_text.text_page_index];
		if (hide.index_current >= hide.index_end) return;
		time_ms -= update_time_ms;
		if (time_ms >= 0) {
			text_apply_alpha(typer_text, hide.index_current, hide.index_end, 0);
			return;
		}
		time_ms = time_between_types_ms;
		var can_type_chars = true;
		var chars_typed = 0;
		while (can_type_chars) {
			if (struct_exists(punctuation_pause_map, typer_text.character_array[hide.index_current].char)) {
				time_ms = struct_get(punctuation_pause_map, typer_text.character_array[hide.index_current].char);
				can_type_chars = false;
			}
			if (struct_exists(character_pause_map, hide.index_current)) {
				time_ms = struct_get(character_pause_map, hide.index_current);
				can_type_chars = false;
			}
			if (struct_exists(character_on_type_map, hide.index_current)) {
				struct_get(character_on_type_map, hide.index_current)();
			}
			start_type_animation_at(hide.index_current);
			hide.index_current++;
			chars_typed++;
			while (hide.index_current < hide.index_end && typer_text.character_array[hide.index_current].char == " ") {
				hide.index_current++;
			}
			if (hide.index_current >= hide.index_end || chars_typed >= chars_per_type) {
				can_type_chars = false;
			}
		}
		on_type();
		text_apply_alpha(typer_text, hide.index_current, hide.index_end, 0);
		if (hide.index_current >= hide.index_end) time_ms = 0; // avoid pauses on next page
	};
}
