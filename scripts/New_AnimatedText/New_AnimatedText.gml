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

function New_Animation(animation_enum, index_start, index_end, aargs) {
	animation_index_start = _index_start;
	animation_index_end = _index_end;
	params = aargs;
	
	update = function() {};
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
	 * @param {real} _animation_enum_value entry in the ANIMATED_TEXT_ANIMATIONS enum
	 * @param {real} _index_start index of first character animation acts on
	 * @param {real} _index_end index of last character animation acts on
	 * @param {array} _aargs array of parameters for this animation
	 * @ignore
	 */
	 /*
	add_animation = function(animation_enum_value, _index_start, _index_end, _aargs) {
		array_push(animations, new AnimatedTextAnimation(_animation_enum_value, text, _index_start, _index_end, _aargs));
	}
	*/
}
