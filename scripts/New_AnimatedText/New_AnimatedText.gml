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
	
	update = function() {};
	
	if (animation_enum == ANIMATED_TEXT_ANIMATIONS.FADEIN) {
		can_finish = true;
		alpha = 0;
		update = function() {
			alpha += 0.02;
			if (alpha >= 1) finished = true;
			text_set_alpha(text, animation_index_end, animation_index_end, alpha);
			if (finished) text.merge_drawables_at_index_range(animation_index_start, animation_index_end);
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
	
	update = function() {
		var animation_ids = struct_get_names(animations);
		for (var i = 0; i < array_length(animation_ids); i++)  {
			var animation = struct_get(animations, animation_ids[i]);
			animation.update();
			if (animation.can_finish && animation.finished) struct_remove(animations, animation_ids[i]);
		}
	};
}
