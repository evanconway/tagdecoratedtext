enum ANIMATED_TEXT_ANIMATIONS {
	FADEIN,
	RISEIN,
	FADE,
	SHAKE,
	TREMBLE,
	CHROMATIC,
	WCHROMATIC,
	WAVE,
	FLOAT,
	BLINK
}

// DEFAULTs
global.animated_text_default_fadein_duration = 200;

global.animated_text_default_risein_duration = 200;
global.animated_text_default_risein_offset = 5;

global.animated_text_default_fade_alpha_min = 0.3;
global.animated_text_default_fade_alpha_max = 1;
global.animated_text_default_fade_cycle_time_ms = 1000;

global.animated_text_default_shake_time_ms = 60;
global.animated_text_default_shake_magnitude = 1;

global.animated_text_default_tremble_time_ms = 80;
global.animated_text_default_tremble_magnitude = 1;

global.animated_text_default_chromatic_change_ms = 32;
global.animated_text_default_chromatic_steps_per_change = 10;
global.animated_text_default_chromatic_char_offset = -30;

global.animated_text_default_wchromatic_change_ms = 32;
global.animated_text_default_wchromatic_steps_per_change = 10;

global.animated_text_default_wave_cycle_time_ms = 1000;
global.animated_text_default_wave_magnitude = 3;
global.animated_text_default_wave_char_offset = 0.5;

global.animated_text_default_float_cycle_time_ms = 1000;
global.animated_text_default_float_magnitude = 3;

global.animated_text_default_blink_alpha_min = 0.2;
global.animated_text_default_blink_alpha_max = 1;
global.animated_text_default_blink_cycle_time_ms = 1000;

/**
 * @param {Struct.New_StyleableText} styleable_text
 * @param {real} animation_enum
 * @param {real} index_start
 * @param {real} index_end
 * @param {array} aargs array of parameters for this animation
 */
function New_Animation(styleable_text, animation_enum, index_start, index_end, aargs) constructor {
	text = styleable_text;
	animation_index_start = index_start;
	animation_index_end = index_end;
	params = aargs;
	
	can_finish = false;
	finished = false;
	
	time_ms = 0;
	
	update = function(update_time_ms) {};
	
	if (animation_enum == ANIMATED_TEXT_ANIMATIONS.FADEIN) {
		can_finish = true;
		alpha = 0;
		duration = global.animated_text_default_fadein_duration;
		
		if (array_length(params) == 1) {
			duration = params[0];
		} else if (array_length(params) != 0) {
			show_error("Improper number of args for fadein animation!", true);
		}
		
		/// @param {real} update_time_ms
		update = function(update_time_ms) {
			time_ms += update_time_ms;
			var drawn_alpha = min(1, time_ms/duration);
			if (drawn_alpha == 1) finished = true;
			text_set_alpha(text, animation_index_end, animation_index_end, drawn_alpha);
			if (finished) text.merge_drawables_at_index_range(animation_index_start, animation_index_end);
		};
	}
	
	if (animation_enum == ANIMATED_TEXT_ANIMATIONS.RISEIN) {
		can_finish = true;
		duration = global.animated_text_default_risein_duration;
		offset = global.animated_text_default_risein_offset;
		
		if (array_length(params) == 2) {
			duration = params[0];
			offset = params[1];
		} else if (array_length(params) != 0) {
			show_error("Improper number of args for risein animation!", true);
		}

		update = function(update_time_ms) {
			time_ms += update_time_ms;
			var drawn_offset = max(0, offset - time_ms/duration*offset);
			if (drawn_offset == 0) finished = true;
			text_set_offset_y(text, animation_index_start, animation_index_end, drawn_offset);
			if (finished) text.merge_drawables_at_index_range(animation_index_start, animation_index_end);
		};
	}
	
	if (animation_enum == ANIMATED_TEXT_ANIMATIONS.FADE) {
		alpha_min = global.animated_text_default_fade_alpha_min;
		alpha_max = global.animated_text_default_fade_alpha_max;
		cycle_time = global.animated_text_default_fade_cycle_time_ms;
		
		if (array_length(params) == 3) {
			alpha_min = params[0];
			alpha_max = params[1];
			cycle_time = params[2];
		} else if (array_length(params) != 0) {
			show_error("Improper number of args for fade animation!", true);
		}
		
		update = function(update_time_ms) {
			time_ms += update_time_ms;
			var check = time_ms % (cycle_time * 2);
			if (check <= cycle_time) {
				check = cycle_time - check;
			} else {
				check -= cycle_time;
			}
			var alpha = alpha_min + check/cycle_time * (alpha_max - alpha_min);
			text_set_alpha(text, animation_index_start, animation_index_end, alpha);
		};
	}
}


/**
 * @param {Struct.New_StyleableText} text
 */
function StyleableTextAnimator(styleable_text) constructor {
	text = styleable_text;
	
	animations = {}; // struct used as mapping of ids to animations
	
	get_new_animation_id = function() {
		return struct_names_count(animations);
	};
	
	/**
	 * @param {real} animation_enum
	 * @param {real} index_start
	 * @param {real} index_end
	 * @param {array} aargs array of parameters for this animation
	 */
	add_animation = function(animation_enum, index_start, index_end, aargs) {
		struct_set(animations, get_new_animation_id(), new New_Animation(text, animation_enum, index_start, index_end, aargs));
	};
	
	update = function(update_time_ms = 1000 / game_get_speed(gamespeed_fps)) {
		var animation_ids = struct_get_names(animations);
		for (var i = 0; i < array_length(animation_ids); i++)  {
			var animation = struct_get(animations, animation_ids[i]);
			animation.update(update_time_ms);
			if (animation.can_finish && animation.finished) struct_remove(animations, animation_ids[i]);
		}
	};
}
