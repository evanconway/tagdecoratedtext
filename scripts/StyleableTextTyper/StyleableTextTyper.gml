// feather ignore all

/**
 * @param {Struct.__TagDecoratedTextStyleable} text
 * @param {Struct.StyleableTextAnimator} animator
 * @ignore
 */
function StyleableTextTyper(text, animator) constructor {
	/// @ignore
	typer_text = text;
	/// @ignore
	typer_animator = animator;
	
	if (typer_animator.text != typer_text) show_error("Given animator for StyleableTextTyper does not reference given StyleableText!", true);
	/// @ignore
	time_ms = 0;
	
	// mapping between indexes of chars and typing information
	/// @ignore
	character_typing_params = array_create(typer_text.character_array_length, {
		time_between_types_ms: 5,
		chars_per_type: 1
	});
	
	/**
	 * @param {real} index_start
	 * @param {real} index_end inclusive
	 * @param {real} new_time_between_types_ms
	 * @param {real} new_chars_per_type
	 * @ignore
	 */
	set_character_indexes_typing_params = function(index_start, index_end, new_time_between_types_ms, new_chars_per_type) {
		var params = {
			time_between_types_ms: new_time_between_types_ms,
			chars_per_type: new_chars_per_type
		};
		for (var i = index_start; i <= index_end; i++) character_typing_params[i] = params;
	};
	
	// mapping between indexes of chars and array of entry animations for said chars
	/// @ignore
	entry_animations_map = {};
	/// @ignore
	add_type_animation_at = function(index, animation_enum, aargs) {
		if (!struct_exists(entry_animations_map, index)) struct_set(entry_animations_map, index, []);
		array_push(struct_get(entry_animations_map, index), { animation_enum, aargs });
	};
	
	/*
	When typing a char, we check if there are any type animations mapped to it. If so we add a new
	animation of that type with associated aargs to the animator.
	*/
	/// @ignore
	start_type_animation_at = function(index) {
		if (!struct_exists(entry_animations_map, index)) return;
		var animations = struct_get(entry_animations_map, index);
		for (var i = 0; i < array_length(animations); i++) {
			typer_animator.add_animation(animations[i].animation_enum, index, index, animations[i].aargs);
		}
	};
	
	// callback function invoked when type occurs
	/// @ignore
	on_type = function() {
		// default is blank function
	};
	/// @ignore
	punctuation_pause_map = {};
	/// @ignore
	set_character_pause = function(character, pause_time_ms) {
		if (string_length(character) != 1) show_error("set_character_pause received string for character with length not equal to 1", true);
		struct_set(punctuation_pause_map, character, pause_time_ms);
	};

	// pause timings for individual character indexes
	/// @ignore
	character_pause_map = {};
	/// @ignore
	set_character_index_pause = function(index, pause_time) {
		struct_set(character_pause_map, index, pause_time);
	};
	
	// on_type callbacks for individual character indexes
	/// @ignore
	character_on_type_map = {};
	/// @ignore
	set_character_index_on_type = function(index, callback) {
		struct_set(character_on_type_map, index, callback);
	};
	
	// Characters are hidden by default. They get "typed" by leaving the range of hidden indexs.
	// Initially no characters are hidden. User must manually tell typing to "reset".
	/// @ignore
	pages_hide_start_end = [];
	for (var i = 0; i <= typer_text.text_page_index_max; i++) {
		array_push(pages_hide_start_end, {
			index_current: typer_text.text_page_char_index_end[i] + 1,
			index_end: typer_text.text_page_char_index_end[i]
		});
	}
	/// @ignore
	reset_typing = function() {
		time_ms = 0;
		typer_animator.remove_finishable_animations();
		for (var i = 0; i < array_length(pages_hide_start_end); i++) {
			pages_hide_start_end[i].index_current = typer_text.text_page_char_index_start[i];
		}
	};
	/// @ignore
	finish_typing_current_page = function() {
		time_ms = 0;
		typer_animator.remove_finishable_animations();
		pages_hide_start_end[typer_text.text_page_index].index_current = typer_text.text_page_char_index_end[typer_text.text_page_index] + 1;
	};
	/// @ignore
	finish_typing_all_pages = function() {
		time_ms = 0;
		typer_animator.remove_finishable_animations();
		for (var i = 0; i <= typer_text.text_page_index_max; i++) {
			pages_hide_start_end[i].index_current = typer_text.text_page_char_index_end[i] + 1;
		}
	}
	
	// a page is considered "typed" if the current hide index is greater than the end index
	/// @ignore
	get_current_page_finished = function() {
		return pages_hide_start_end[typer_text.text_page_index].index_current > typer_text.text_page_char_index_end[typer_text.text_page_index];
	}
	/// @ignore
	current_typing_params = character_typing_params[0];
	/// @ignore
	update = function(update_time_ms = 1000/game_get_speed(gamespeed_fps)) {
		var hide = pages_hide_start_end[typer_text.text_page_index];
		if (hide.index_current > hide.index_end) return;
		time_ms -= update_time_ms;
		if (time_ms > 0) {
			text_apply_alpha(typer_text, hide.index_current, hide.index_end, 0);
			return;
		}
		
		while (time_ms <= 0 && hide.index_current <= hide.index_end) {
			time_ms += current_typing_params.time_between_types_ms;
			var can_type_chars = true;
			var chars_typed = 0;
			while (can_type_chars) {
				if (character_typing_params[hide.index_current] != current_typing_params) {
					time_ms = 0;
					current_typing_params = character_typing_params[hide.index_current];
					can_type_chars = false;
				}
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
				while (hide.index_current <= hide.index_end && typer_text.character_array[hide.index_current].char == " ") {
					hide.index_current++;
				}
				if (hide.index_current > hide.index_end || chars_typed >= current_typing_params.chars_per_type) {
					can_type_chars = false;
				}
			}
		}

		on_type();
		text_apply_alpha(typer_text, hide.index_current, hide.index_end, 0);
		if (hide.index_current > hide.index_end) time_ms = 0; // avoid pauses on next page
	};
}
