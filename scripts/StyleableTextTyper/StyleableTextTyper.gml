/**
 * @param {Struct.New_StyleableText} text
 * @param {Struct.StyleableTextAnimator} animator
 */
function StyleableTextTyper(text, animator) constructor {
	typer_text = text;
	typer_animator = animator;
	
	if (typer_animator.text != typer_text) show_error("Given animator for StyleableTextTyper does not reference given StyleableText!", true);
	
	hide_start = 0;
	hide_end = typer_text.character_array_length - 1;
	
	time_between_types_ms = 80;
	time_ms = time_between_types_ms;
	chars_per_type = 2.4;
	
	// mapping between indexes of chars and array of entry animations for said chars
	entry_animations_map = {};
	
	punctuation_pause_map = {};
	
	struct_set(punctuation_pause_map, ".", 800);
	struct_set(punctuation_pause_map, "!", 800);
	struct_set(punctuation_pause_map, "?", 800);
	struct_set(punctuation_pause_map, ",", 500);
	struct_set(punctuation_pause_map, ":", 500);
	struct_set(punctuation_pause_map, ";", 500);
	struct_set(punctuation_pause_map, "-", 500);
	
	update = function(update_time_ms = 1000/game_get_speed(gamespeed_fps)) {
		if (hide_start >= hide_end) return;
		time_ms -= update_time_ms;
		if (time_ms >= 0) {
			text_apply_alpha(typer_text, hide_start, hide_end, 0);
			return;
		}
		time_ms = time_between_types_ms;
		var can_type_chars = true;
		var chars_typed = 0;
		while (can_type_chars) {
			// add animations or other type char logic here
			if (struct_exists(punctuation_pause_map, typer_text.character_array[hide_start].char)) {
				time_ms += struct_get(punctuation_pause_map, typer_text.character_array[hide_start].char);
				can_type_chars = false;
			}
			hide_start++;
			chars_typed++;
			while (hide_start < hide_end && typer_text.character_array[hide_start].char == " ") {
				// more type char logic here
				hide_start++;
			}
			if (hide_start >= hide_end || chars_typed >= chars_per_type) {
				can_type_chars = false;
			}
		}
		text_apply_alpha(typer_text, hide_start, hide_end, 0);
	};
}
