// feather ignore all

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
	BLINK,
	TWITCH
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

global.animated_text_default_twitch_count = 3;
global.animated_text_default_twitch_magnitude = 1;
global.animated_text_default_twitch_offset_time_ms = 40;
global.animated_text_default_twitch_wait_min = 200;
global.animated_text_default_twitch_wait_max = 600;

/**
 * @param {Struct.__TagDecoratedTextStyleable} styleable_text
 * @param {real} animation_enum
 * @param {real} index_start
 * @param {real} index_end
 * @param {array} aargs array of parameters for this animation
 * @ignore
 */
function TagDecoratedTextAnimation(styleable_text, animation_enum, index_start, index_end, aargs) constructor {
	/// @ignore
	text = styleable_text;
	/// @ignore
	animation_index_start = index_start;
	/// @ignore
	animation_index_end = index_end;
	/// @ignore
	params = aargs;
	/// @ignore
	can_finish = false;
	/// @ignore
	finished = false;
	/// @ignore
	time_ms = 0;
	/// @ignore
	update = function(update_time_ms) {};
	
	// animations with other internal state must receive an updated reset function
	/// @ignore
	reset = function() {
		time_ms = 0;
	};
	
	if (animation_enum == ANIMATED_TEXT_ANIMATIONS.FADEIN) {
		can_finish = true;
		/// @ignore
		alpha = 0;
		/// @ignore
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
			text.drawable_apply_alpha(animation_index_start, animation_index_end, drawn_alpha);
			if (finished) text.merge_drawables_at_index_range(animation_index_start, animation_index_end);
		};
		
		reset = function() {
			time_ms = 0;
			alpha = 0;
		};
	}
	
	if (animation_enum == ANIMATED_TEXT_ANIMATIONS.RISEIN) {
		can_finish = true;
		/// @ignore
		duration = global.animated_text_default_risein_duration;
		/// @ignore
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
			text.drawable_add_offset_y(animation_index_start, animation_index_end, drawn_offset);
			if (finished) text.merge_drawables_at_index_range(animation_index_start, animation_index_end);
		};
	}
	
	if (animation_enum == ANIMATED_TEXT_ANIMATIONS.FADE) {
		/// @ignore
		alpha_min = global.animated_text_default_fade_alpha_min;
		/// @ignore
		alpha_max = global.animated_text_default_fade_alpha_max;
		/// @ignore
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
			text.drawable_apply_alpha(animation_index_start, animation_index_end, alpha);
		};
	}
	
	if (animation_enum == ANIMATED_TEXT_ANIMATIONS.SHAKE || animation_enum == ANIMATED_TEXT_ANIMATIONS.TREMBLE) {
		/// @ignore
		offset_time = animation_enum == ANIMATED_TEXT_ANIMATIONS.SHAKE ? global.animated_text_default_shake_time_ms : global.animated_text_default_tremble_time_ms;
		/// @ignore
		magnitude = animation_enum == ANIMATED_TEXT_ANIMATIONS.SHAKE ? global.animated_text_default_shake_magnitude : global.animated_text_default_tremble_magnitude;
		/// @ignore
		offset_individual_chars = animation_enum == ANIMATED_TEXT_ANIMATIONS.TREMBLE;
		/// @ignore
		offset_x_arr = array_create(offset_individual_chars ? animation_index_end - animation_index_start + 1 : 0);
		/// @ignore
		offset_y_arr = array_create(offset_individual_chars ? animation_index_end - animation_index_start + 1 : 0);
		/// @ignore
		calc_offsets = function() {
			for (var i = 0; i < array_length(offset_x_arr); i++) {
				offset_x_arr[i] = floor((magnitude + 1) * 2 * random(1)) - magnitude;
				offset_y_arr[i] = floor((magnitude + 1) * 2 * random(1)) - magnitude;
			}
		};
		calc_offsets();
		
		if (array_length(params) == 2) {
			offset_time = params[0];
			magnitude = params[1];
		} else if (array_length(params) != 0) {
			show_error("Improper number of args for shake/tremble animation!", true);
		}
		//// @ignore
		update = function(update_time_ms) {
			time_ms += update_time_ms;
			if (time_ms > offset_time) {
				calc_offsets();
				time_ms = 0;
			}
			if (offset_individual_chars) {
				for (var i = animation_index_start; i <= animation_index_end; i++) {
					text.drawable_add_offset_x(i, i, offset_x_arr[i - animation_index_start]);
					text.drawable_add_offset_y(i, i, offset_y_arr[i - animation_index_start]);
				}
			} else {
				text.drawable_add_offset_x(i, i, offset_x_arr[i - animation_index_start]);
				text.drawable_add_offset_y(i, i, offset_y_arr[i - animation_index_start]);
			}
		};
	}

	/// @ignore
	static red_at = function(index) {
		index = abs(index);
		index %= 1536;
		if (index >= 0 && index < 256) return 255;
		if (index >= 256 && index < 512) return 511 - index;
		if (index >= 512 && index < 768) return 0;
		if (index >= 768 && index < 1024) return 0;
		if (index >= 1024 && index < 1280) return index - 1024;
		if (index >= 1280 && index < 1536) return 255;
		return 0;
	}
	/// @ignore
	static green_at = function(index) {
		index = abs(index);
		index %= 1536;
		if (index >= 0 && index < 256) return index;
		if (index >= 256 && index < 512) return 255;
		if (index >= 512 && index < 768) return 255;
		if (index >= 768 && index < 1024) return 1023 - index;
		if (index >= 1024 && index < 1280) return 0;
		if (index >= 1280 && index < 1536) return 0;
		return 0;
	}
	/// @ignore
	static blue_at = function(index) {
		index = abs(index);
		index %= 1536;
		if (index >= 0 && index < 256) return 0;
		if (index >= 256 && index < 512) return 0;
		if (index >= 512 && index < 768) return index - 512;
		if (index >= 768 && index < 1024) return 255;
		if (index >= 1024 && index < 1280) return 255;
		if (index >= 1280 && index < 1536) return 1535 - index;
		return 0;
	}
	/// @ignore
	static get_chromatic_color_at = function(index) {
		var red = red_at(index);
		var green = green_at(index);
		var blue = blue_at(index);
		return make_color_rgb(red, green, blue);
	}
	
	if (animation_enum == ANIMATED_TEXT_ANIMATIONS.CHROMATIC || animation_enum == ANIMATED_TEXT_ANIMATIONS.WCHROMATIC) {
		/// @ignore
		change_ms = animation_enum == ANIMATED_TEXT_ANIMATIONS.CHROMATIC ? global.animated_text_default_chromatic_change_ms : global.animated_text_default_wchromatic_change_ms;
		/// @ignore
		steps_per_change = animation_enum == ANIMATED_TEXT_ANIMATIONS.CHROMATIC ? global.animated_text_default_chromatic_steps_per_change : global.animated_text_default_wchromatic_steps_per_change;
		/// @ignore
		char_offset = animation_enum == ANIMATED_TEXT_ANIMATIONS.CHROMATIC ? global.animated_text_default_chromatic_char_offset : 0;

		// use char offset to determine if chromatic or wchromatic
		if (char_offset == undefined) {
			if (array_length(params) == 2) {
				change_ms = params[0];
				steps_per_change = params[1];
			} else if (array_length(params) != 0) {
				show_error("Improper number of args for wchromatic animation!", true);
			}
		} else {
			if (array_length(params) == 3) {
				change_ms = params[0];
				steps_per_change = params[1];
				char_offset = params[2];
			} else if (array_length(params) != 0) {
				show_error("Improper number of args for chromatic animation!", true);
			}
		}

		update = function(update_time_ms) {
			time_ms += update_time_ms;
			var index = floor(time_ms/change_ms) * steps_per_change;
			
			// use char offset to determine if chromatic or wchromatic
			if (char_offset != 0) {
				for (var i = animation_index_start; i <= animation_index_end; i++) {
					text.drawable_set_color(i, i, get_chromatic_color_at(index + char_offset * i));
				}
			} else {
				text.drawable_set_color(animation_index_start, animation_index_end, get_chromatic_color_at(index));
			}	
		};
	}
	
	if (animation_enum == ANIMATED_TEXT_ANIMATIONS.WAVE || animation_enum == ANIMATED_TEXT_ANIMATIONS.FLOAT) {
		/// @ignore
		cycle_time = animation_enum == ANIMATED_TEXT_ANIMATIONS.WAVE ? global.animated_text_default_wave_cycle_time_ms : global.animated_text_default_float_cycle_time_ms;
		/// @ignore
		magnitude = animation_enum == ANIMATED_TEXT_ANIMATIONS.WAVE ? global.animated_text_default_wave_magnitude : global.animated_text_default_float_magnitude;
		/// @ignore
		char_offset = animation_enum == ANIMATED_TEXT_ANIMATIONS.WAVE ? global.animated_text_default_wave_char_offset : 0;
		
		// use char offset to determine if wave or float
		if (char_offset == undefined) {
			if (array_length(params) == 2) {
				cycle_time = params[0];
				magnitude = params[1];
			} else if (array_length(params) != 0) {
				show_error("Improper number of args for float animation!", true);
			}
		} else {
			if (array_length(params) == 3) {
				cycle_time = params[0];
				magnitude = params[1];
				char_offset = params[2];
			} else if (array_length(params) != 0) {
				show_error("Improper number of args for wave animation!", true);
			}
		}

		update = function(update_time_ms) {
			time_ms += update_time_ms;
			var time_into_cylce = time_ms % cycle_time;
			var percent = time_into_cylce / cycle_time;
			if (char_offset == 0) {
				var mod_y = sin(percent * -2 * pi) * magnitude;
				text.drawable_add_offset_y(animation_index_start, animation_index_end, mod_y);
			} else {
				for (var i = animation_index_start; i <= animation_index_end; i++) {
					var mod_y = sin(percent * -2 * pi + char_offset * i) * magnitude;
					text.drawable_add_offset_y(i, i, mod_y);
				}
			}
		};
	}
	
	if (animation_enum == ANIMATED_TEXT_ANIMATIONS.BLINK) {
		/// @ignore
		alpha_min = global.animated_text_default_blink_alpha_min;
		/// @ignore
		alpha_max = global.animated_text_default_blink_alpha_max;
		/// @ignore
		cycle_time = global.animated_text_default_blink_cycle_time_ms;
		
		if (array_length(params) == 3) {
			alpha_min = params[0];
			alpha_max = params[1];
			cycle_time = params[2];
		} else if (array_length(params) != 0) {
			show_error("Improper number of args for blink animation!", true);
		}

		update = function(update_time_ms) {
			time_ms += update_time_ms;
			if ((time_ms % (cycle_time * 2)) <= cycle_time) {
				text.drawable_apply_alpha(animation_index_start, animation_index_end, alpha_max);
			} else {
				text.drawable_apply_alpha(animation_index_start, animation_index_end, alpha_min);
			}
		};
	}
	
	if (animation_enum == ANIMATED_TEXT_ANIMATIONS.TWITCH) {
		/// @ignore
		count = global.animated_text_default_twitch_count;
		/// @ignore
		magnitude = global.animated_text_default_twitch_magnitude;
		/// @ignore
		offset_time = global.animated_text_default_twitch_offset_time_ms;
		/// @ignore
		wait_min = global.animated_text_default_twitch_wait_min;
		/// @ignore
		wait_max = global.animated_text_default_twitch_wait_max;
		
		if (array_length(params) == 5) {
			count = params[0]
			magnitude = params[1];
			offset_time = params[2];
			wait_min = params[3];
			wait_max = params[4];
		} else if (array_length(params) != 0) {
			show_error("Improper number of args for twitch animation!", true);
		}
		
		// make multiple sub-animations
		/// @ignore
		sub_animations = [];
		for (var a = 0; a < count; a++) {
			array_push(sub_animations, {
				text: text,
				index: irandom_range(animation_index_start, animation_index_end),
				offset_x: irandom_range(-1 * magnitude, magnitude),
				offset_y: irandom_range(-1 * magnitude, magnitude),
				magnitude: magnitude,
				wait_min: wait_min,
				wait_max: wait_max,
				offset_time: offset_time,
				animation_index_start: animation_index_start,
				animation_index_end: animation_index_end,
				state: 1, // 0: wait, 1: twitch
				time_ms: offset_time, // unlike other animations, we subtract time here
				update: function(update_time_ms) {
					time_ms -= update_time_ms;
					if (state == 0 && time_ms < 0) {
						time_ms = offset_time;
						offset_x = irandom_range(-1 * magnitude, magnitude);
						offset_y = irandom_range(-1 * magnitude, magnitude);
						index = irandom_range(animation_index_start, animation_index_end);
						state = 1;
					} else if (state == 1 && time_ms < 0) {
						text.drawable_add_offset_x(index, index, 0);
						text.drawable_add_offset_y(index, index, 0);
						text.merge_drawables_at_index_range(index, index);
						time_ms = irandom_range(wait_min, wait_max);
						state = 0;
					}
					if (state == 1) {
						text.drawable_add_offset_x(index, index, offset_x);
						text.drawable_add_offset_y(index, index, offset_y);
					}
				}
			});
		}
		
		update = function(update_time_ms) {
			for (var a = 0; a < array_length(sub_animations); a++) {
				sub_animations[a].update(update_time_ms);
			}
		};
		
		reset = function() {
			for (var a = 0; a < array_length(sub_animations); a++) {
				sub_animations[a].time_ms = offset_time;
				sub_animations[a].state = 1;
			}
		};
	}
}

/**
 * @param {Struct.StyleableText} styleable_text
 * @ignore
 */
function StyleableTextAnimator(styleable_text) constructor {
	/// @ignore
	text = styleable_text;
	/// @ignore
	animations = {}; // struct used as mapping of ids to animations
	/// @ignore
	next_animation_id = 0;
	/// @ignore
	get_new_animation_id = function() {
		var result = next_animation_id;
		next_animation_id++;
		return result;
	};
	
	/**
	 * @param {real} animation_enum
	 * @param {real} index_start
	 * @param {real} index_end
	 * @param {array} aargs array of parameters for this animation
	 * @ignore
	 */
	add_animation = function(animation_enum, index_start, index_end, aargs) {
		struct_set(animations, get_new_animation_id(), new TagDecoratedTextAnimation(text, animation_enum, index_start, index_end, aargs));
	};
	/// @ignore
	update = function(update_time_ms = 1000 / game_get_speed(gamespeed_fps)) {
		var animation_ids = struct_get_names(animations);
		for (var i = 0; i < array_length(animation_ids); i++)  {
			var animation = struct_get(animations, animation_ids[i]);
			animation.update(update_time_ms);
			if (animation.can_finish && animation.finished) struct_remove(animations, animation_ids[i]);
		}
	};
	/// @ignore
	remove_finishable_animations = function() {
		var animation_ids = struct_get_names(animations);
		for (var i = 0; i < array_length(animation_ids); i++)  {
			var animation = struct_get(animations, animation_ids[i]);
			if (animation.can_finish) struct_remove(animations, animation_ids[i]);
		}
	};
	
	// reset the state of all animations, finishable animations are removed
	/// @ignore
	reset = function() {
		var animation_ids = struct_get_names(animations);
		for (var i = 0; i < array_length(animation_ids); i++)  {
			var animation = struct_get(animations, animation_ids[i]);
			if (animation.can_finish) struct_remove(animations, animation_ids[i]);
			else animation.reset();
		}
	};
}
