/// @ignore
function AnimatedText(_source_string, _width, _height) constructor {
	/// @ignore
	text = new StyleableText(_source_string, _width);
	/// @ignore
	get_character_count = function() {
		return array_length(text.character_array);
	};
	/// @ignore
	get_char_at = function(_index) {
		return text.character_array[_index].character;
	};
	/// @ignore
	animations = [];
	
	/**
	 * @func add_animation(_animation_enum_value, _index_start, _index_end, _aargs)
	 * @param {real} _animation_enum_value entry in the ANIMATED_TEXT_ANIMATIONS enum
	 * @param {real} _index_start index of first character animation acts on
	 * @param {real} _index_end index of last character animation acts on
	 * @param {array} _aargs array of parameters for this animation
	 * @ignore
	 */
	add_animation = function(_animation_enum_value, _index_start, _index_end, _aargs) {
		array_push(animations, new AnimatedTextAnimation(_animation_enum_value, text, _index_start, _index_end, _aargs));
	}
	
	/**
	 * Removes all entry animations.
	 * @ignore
	 */
	clear_entry_animations = function() {
		/// @param {Struct.AnimatedTextAnimation} _a
		var _f = function(_a) {
			return !_a.is_entry;
		};
		animations = array_filter(animations, _f);
	}
	
	/**
	 * Removes all entry animations and resets update time for all remaining animations.
	 * @ignore
	 */
	reset_animations = function() {
		clear_entry_animations();
		for (var _i = 0; _i < array_length(animations); _i++) {
			animations[_i].time_ms = 0;
		}
	}
	
	/**
	 * @param {real} _update_time_ms amount of time in ms to update animations by
	 * @ignore
	 */
	update = function(_update_time_ms) {
		// initialize the drawables of the underyling StyleableText instance
		var _cursor = text.drawables;
		while (_cursor != undefined) {
			_cursor.init_styles();
			_cursor = _cursor.next;
		}
		
		for (var _i = 0; _i < array_length(animations); _i++) {
			animations[_i].update_merge(_update_time_ms);
		}
		
		/// @param {Struct.AnimatedTextAnimation} _a
		var _f = function(_a) {
			return !_a.animation_finished;
		};
		
		animations = array_filter(animations, _f);
		
		for (var _i = 0; _i < array_length(animations); _i++) {
			animations[_i].update_split(_update_time_ms);
		}
		for (var _i = 0; _i < array_length(animations); _i++) {
			animations[_i].update_animate(_update_time_ms);
		}
	};
	
	/**
	 * @param {real} _x
	 * @param {real} _y
	 * @param {real} _alignment horizontal alignment
	 * @ignore
	 */
	draw = function(_x, _y, _alignment = fa_left) {
		text.draw(_x, _y, _alignment);
	};
}
