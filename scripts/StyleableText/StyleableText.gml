/**
 * Get a new StyleableText instance.
 * @param {string} _source source string
 * @param {real} _width max width of text before line breaks occur
 * @ignore
 */
function StyleableText(_source, _width = -1) constructor {
	if (string_length(_source) == 0) {
		show_error("Cannot create StyleableText with empty string!", true);
	}
	/// @ignore
	character_array = [];
	for (var _i = 1; _i <= string_length(_source); _i++) {
		array_push(character_array, new StyleableTextCharacter(string_char_at(_source, _i)));
	}
	
	/*
	Width is determined automatically if not given by the user. If width is specified then
	the width will be used to determine line breaks. Heigh is always automatically
	calculated.
	*/
	auto_calculate_width = _width < 0;
	
	/// @ignore
	width = _width;
	/// @ignore
	height = 0; // calculated automatically
	/// @ignore
	get_width = function() {
		return width;
	}
	/// @ignore
	get_height = function() {
		return height;
	}
	
	/**
	 * Sets the line index for characters in the given range.
	 * @param {real} _index_start start index 
	 * @param {real} _index_end end index
	 * @param {real} _line_index the line index to give the characters
	 * @ignore
	 */
	characters_set_line_index = function(_index_start, _index_end, _line_index) {
		for (var _i = _index_start; _i <= _index_end; _i ++) {
			character_array[_i].line_index = _line_index;
		}
	};
	
	/*
	A mapping of line indexes to width of trailing spaces on said lines. Used to 
	draw center and right aligned text.
	*/
	/// @ignore
	alignment_offsets = ds_map_create();
	/// @ignore
	calculate_xy = function() {
		/*
		Here we determine line breaks by setting a different line_index to characters. However, if width
		is given as less than 0 than there will be no line breaks, the text will be a single line, and the
		width will be set to the width of the resulting single line.
		*/
		var _line_index = -1; // start at -1 to account for line break on first word (very small widths or super large words)
		var _line_width = 0;
		var _word_index_start = 0;
		var _word_index_end = -1; // -1 if word has not started
		var _word_width = 0;
		
		for (var _i = 0; _i < array_length(character_array); _i++) {
			var _char = character_array[_i];
			
			// if space or new line, word is over
			if (_char.character == " " || _char.new_line) {
				// if word is too big for line, start new line
				if (!auto_calculate_width && _line_width + _word_width > width) {
					_line_index++;
					_line_width = 0;
				}
				
				_line_index = _line_index < 0 ? 0 : _line_index; // ensure first line index is 0
				
				// add word to current line
				characters_set_line_index(_word_index_start, _word_index_end, _line_index);
				_line_width += _word_width;
				_word_width = 0;
				_word_index_end = -1; // mark word as not started
				
				// if new line triggered, start new line
				if (_char.new_line) {
					_line_index++;
					_line_width = 0;
				}
				
				// add character to current line
				characters_set_line_index(_i, _i, _line_index);
				_line_width += _char.get_width();
				
				// if character is not space, start word
				// (happens when new line triggered by character.new_line and not space)
				if (_char.character != " ") {
					_word_index_start = _i;
					_word_width += _char.get_width();
					_word_index_end = _i;
				}
				
			// otherwise add to current word
			} else {
				// start new word if one has not been started
				if (_word_index_end < 0) _word_index_start = _i;
				_word_width += _char.get_width();
				_word_index_end = _i;
			}
		}
		
		// set last word line index
		// if word is too big for line, start new line
		if (!auto_calculate_width && _line_width + _word_width > width) {
			_line_index++;
		}
		
		// in cases with very little text, line_index can not even be advanced, ensure it's at least 0 for last word
		_line_index = _line_index < 0 ? 0 : _line_index; // ensure first line index is 0
			
		// add word to current line
		characters_set_line_index(_word_index_start, _word_index_end, _line_index);
		
		// determine line dimensions
		var _line_heights = ds_map_create();
		var _line_widths = ds_map_create();
		var _width = 0;
		var _current_line_index = 0;
		var _max_width = 0;
		for (var _i = 0; _i < array_length(character_array); _i++) {
			var _char = character_array[_i];
			// heights
			if (!ds_map_exists(_line_heights, _char.line_index)) {
				ds_map_set(_line_heights, _char.line_index, _char.get_height());
			} else {
				if (ds_map_find_value(_line_heights, _char.line_index) < _char.get_height()) {
					ds_map_set(_line_heights, _char.line_index, _char.get_height());
				}
			}
			
			// width
			if (_char.line_index == _current_line_index) {
				_width += _char.get_width();
				_max_width = max(_max_width, _width);
			} else {
				ds_map_set(_line_widths, _current_line_index, _width);
				_width = _char.get_width();
				_max_width = max(_max_width, _width);
				_current_line_index = _char.line_index;
			}
		}
		
		ds_map_set(_line_widths, _current_line_index, _width);
		
		// set width if auto calculating
		if (auto_calculate_width) {
			width = _max_width;
		}
		
		// calculate height
		height = 0;
		for (var _i = 0; _i < ds_map_size(_line_heights); _i++) {
			height += ds_map_find_value(_line_heights, _i);
		}
		
		// set xy positions and end of line offsets
		var _x = 0;
		var _y = 0;
		_current_line_index = character_array[0].line_index;
		var _trailing_space_width = 0;
		for (var _i = 0; _i < array_length(character_array); _i++) {			
			var _char = character_array[_i];
			if (_char.line_index != _current_line_index) {
				ds_map_set(alignment_offsets, _current_line_index, width - (ds_map_find_value(_line_widths, _current_line_index) - _trailing_space_width));
				_trailing_space_width = 0;
				_x = 0;
				_y += ds_map_find_value(_line_heights, _current_line_index);
				_current_line_index = _char.line_index;
			} else {
				_trailing_space_width = _char.character == " " ? _trailing_space_width + _char.get_width() : 0;
			}
			_char.position_x = _x;
			_x += _char.get_width();
			_char.position_y = _y;
		}
		
		// handle alignment offset of last character
		ds_map_set(alignment_offsets, _current_line_index, width - (ds_map_find_value(_line_widths, _current_line_index) - _trailing_space_width));
		
		ds_map_destroy(_line_heights);
		ds_map_destroy(_line_widths);
	};
	/// @ignore
	drawables = undefined;
	/// @ignore
	init_drawables = function() {
		calculate_xy();
		var _result = undefined;
		var _result_end = undefined;
		var _index_start = 0;
		var _index_end = 0;
		for (var _i = 1; _i < array_length(character_array); _i++) {
			var _char_checking = character_array[_i];
			var _char_against = character_array[_index_start];
			var _sprite_values_allow_merge = _char_checking.sprite == spr_styleable_text_sprite_default && _char_against.sprite == spr_styleable_text_sprite_default;
			var _style_values_allow_merge = _char_checking.style.is_equal(_char_against.style);
			var _line_indexes_allow_merge = _char_checking.line_index == _char_against.line_index;
			if (_sprite_values_allow_merge && _style_values_allow_merge && _line_indexes_allow_merge) {
				_index_end = _i;
			} else {
				var _drawable = new StyleableTextDrawable(character_array, _index_start, _index_end);
				if (_result == undefined) {
					_result = _drawable;
					_result_end = _drawable;
				} else {
					_result_end.next = _drawable;
					_drawable.previous = _result_end;
					_result_end = _drawable;
				}
				_index_start = _i;
				_index_end = _i;
			}
		}
		
		var _drawable = new StyleableTextDrawable(character_array, _index_start, _index_end);
		if (_result == undefined) {
			_result = _drawable;
			_result_end = _drawable;
		} else {
			_result_end.next = _drawable;
			_drawable.previous = _result_end;
			_result_end = _drawable;
		}
		
		drawables = _result;
	};
	/// @ignore
	init_drawables();
	
	/**
	 * Get the drawable instance that's drawing character at the given index.
	 * @param {real} _index character index
	 * @ignore
	 */
	get_drawable_for_character_at = function(_index) {
		return character_array[_index].drawable;
	};
	
	/**
	 * Splits the drawables linked list at the given indexes so a drawable starts at _index_start and one ends at _index_end.
	 * @param {real} _index_start
	 * @param {real} _index_end
	 * @ignore
	 */
	split_drawables_at = function(_index_start, _index_end) {
		var _start_drawable = get_drawable_for_character_at(_index_start);
		_start_drawable.split_left_at_index(_index_start);
		var _end_drawable = get_drawable_for_character_at(_index_end);
		_end_drawable.split_right_at_index(_index_end);
	};
	
	/**
	 * Merges all drawables with given index range, as well as at the ends.
	 * @param {real} _index_start
	 * @param {real} _index_end
	 * @ignore
	 */
	merge_drawables_at = function(_index_start, _index_end) {
		var _merging_drawable = get_drawable_for_character_at(_index_start);
		/*
		If drawable at _index_start begins with _index_start, we need to set it back to previous to
		make sure that _index_start is also merged. The only scenario we don't do this is if previous
		is undefined (the drawable is the start of the linked list).
		*/
		if (_merging_drawable.get_index_start() == _index_start && _merging_drawable.previous != undefined) {
			_merging_drawable = _merging_drawable.previous;
		}
		/* 
		Now we merge drawables left -> right until the drawable we're merging has and end_index greater
		than the given, or end_index equals the given and next is undefined (at end of list).
		*/
		var _cursor = _merging_drawable;
		while (_cursor.get_index_end() < _index_end || _cursor.get_index_end() == _index_end && _cursor.next != undefined) {
			if (_cursor.can_merge_with_next()) {
				_cursor.merge_with_next();
			} else {
				_cursor = _cursor.next;
			}
		}
	}
	
	/**
	 * Draw this StyleableText instance at the given x and y positions.
	 * @param {real} _x x position
	 * @param {real} _y y position
	 * @ignore
	 */
	draw = function(_x, _y, _alignment = fa_left) {
		var _cursor = drawables;
		while (_cursor != undefined) {
			var _drawable_line_index = _cursor.character_array[_cursor.get_index_start()].line_index;
			var _alignment_offset = ds_map_find_value(alignment_offsets, _drawable_line_index);
			if (_alignment == fa_left) _alignment_offset = 0;
			if (_alignment == fa_center) _alignment_offset = floor(_alignment_offset / 2);
			if (_alignment != fa_left && _alignment != fa_center && _alignment != fa_right) _alignment = 0;
			_cursor.draw(_x + _alignment_offset, _y);
			_cursor = _cursor.next;
		}
	};
	
	// set default styles
	/// @ignore
	set_default_sprite = function(_index, _sprite) {
		if (is_string(_sprite)) {
			var _asset_type = asset_get_type(_sprite);
			if (_asset_type != asset_sprite) show_error("gave none sprite asset name for sprite command", true);
			// Feather disable once GM1043
			_sprite = asset_get_index(_sprite);
		}
		character_array[_index].sprite = _sprite;
		init_drawables();
	};
	/// @ignore
	set_default_scale_x = function(_index_start, _index_end, _scale_x) {
		for (var _i = _index_start; _i <= _index_end; _i++) {
			character_array[_i].style.scale_x = _scale_x;
		}
		init_drawables();
	};
	/// @ignore
	set_default_scale_y = function(_index_start, _index_end, _scale_y) {
		for (var _i = _index_start; _i <= _index_end; _i++) {
			character_array[_i].style.scale_y = _scale_y;
		}
		init_drawables();
	};
	/// @ignore
	set_default_font = function(_index_start, _index_end, _font) {
		if (is_string(_font)) {
			var _asset_type = asset_get_type(_font);
			if (_asset_type != asset_font) show_error("gave none font asset name for font command", true);
			// Feather disable once GM1043
			_font = asset_get_index(_font);
		}
		
		for (var _i = _index_start; _i <= _index_end; _i++) {
			character_array[_i].style.font = _font;
		}
		init_drawables();
	};
	/// @ignore
	set_default_color = function(_index_start, _index_end, _color) {
		for (var _i = _index_start; _i <= _index_end; _i++) {
			character_array[_i].style.style_color = _color;
		}
		init_drawables();
	};
	/// @ignore
	set_default_alpha = function(_index_start, _index_end, _alpha) {
		for (var _i = _index_start; _i <= _index_end; _i++) {
			character_array[_i].style.alpha = _alpha;
		}
		init_drawables();
	};
	/// @ignore
	set_default_mod_x = function(_index_start, _index_end, _mod_x) {
		for (var _i = _index_start; _i <= _index_end; _i++) {
			character_array[_i].style.mod_x = _mod_x;
		}
		init_drawables();
	};
	/// @ignore
	set_default_mod_y = function(_index_start, _index_end, _mod_y) {
		for (var _i = _index_start; _i <= _index_end; _i++) {
			character_array[_i].style.mod_y = _mod_y;
		}
		init_drawables();
	};
	/// @ignore
	set_default_mod_angle = function(_index_start, _index_end, _mod_angle) {
		for (var _i = _index_start; _i <= _index_end; _i++) {
			character_array[_i].style.mod_angle = _mod_angle;
		}
		init_drawables();
	};
	
	// affect temporary styles
	/// @ignore
	set_sprite = function(_index, _sprite) {
		split_drawables_at(_index, _index);
		get_drawable_for_character_at(_index).sprite = _sprite;
	};
	/// @ignore
	set_scale_x = function(_index_start, _index_end, _scale_x) {
		split_drawables_at(_index_start, _index_end);
		var _cursor = get_drawable_for_character_at(_index_start);
		while (_cursor != undefined && _cursor.get_index_end() <= _index_end) {
			_cursor.style.scale_x *= _scale_x;
			_cursor = _cursor.next;
		}
	};
	/// @ignore
	set_scale_y = function(_index_start, _index_end, _scale_y) {
		split_drawables_at(_index_start, _index_end);
		var _cursor = get_drawable_for_character_at(_index_start);
		while (_cursor != undefined && _cursor.get_index_end() <= _index_end) {
			_cursor.style.scale_y *= _scale_y;
			_cursor = _cursor.next;
		}
	};
	/// @ignore
	set_font = function(_index_start, _index_end, _font) {
		split_drawables_at(_index_start, _index_end);
		var _cursor = get_drawable_for_character_at(_index_start);
		while (_cursor != undefined && _cursor.get_index_end() <= _index_end) {
			_cursor.style.font = _font;
			_cursor = _cursor.next;
		}
	};
	/// @ignore
	set_color = function(_index_start, _index_end, _color) {
		split_drawables_at(_index_start, _index_end);
		var _cursor = get_drawable_for_character_at(_index_start);
		while (_cursor != undefined && _cursor.get_index_end() <= _index_end) {
			_cursor.style.style_color = _color;
			_cursor = _cursor.next;
		}
	};
	/// @ignore
	set_alpha = function(_index_start, _index_end, _alpha) {
		split_drawables_at(_index_start, _index_end);
		var _cursor = get_drawable_for_character_at(_index_start);
		while (_cursor != undefined && _cursor.get_index_end() <= _index_end) {
			_cursor.style.alpha *= _alpha;
			_cursor = _cursor.next;
		}
	};
	/// @ignore
	set_mod_x = function(_index_start, _index_end, _mod_x) {
		split_drawables_at(_index_start, _index_end);
		var _cursor = get_drawable_for_character_at(_index_start);
		while (_cursor != undefined && _cursor.get_index_end() <= _index_end) {
			_cursor.style.mod_x += _mod_x;
			_cursor = _cursor.next;
		}
	};
	/// @ignore
	set_mod_y = function(_index_start, _index_end, _mod_y) {
		split_drawables_at(_index_start, _index_end);
		var _cursor = get_drawable_for_character_at(_index_start);
		while (_cursor != undefined && _cursor.get_index_end() <= _index_end) {
			_cursor.style.mod_y += _mod_y;
			_cursor = _cursor.next;
		}
	};
	/// @ignore
	set_mod_angle = function(_index_start, _index_end, _mod_angle) {
		split_drawables_at(_index_start, _index_end);
		var _cursor = get_drawable_for_character_at(_index_start);
		while (_cursor != undefined && _cursor.get_index_end() <= _index_end) {
			_cursor.style.mod_angle += _mod_angle;
			_cursor = _cursor.next;
		}
	};
	
	/**
	 * Get if character at given index is hidden.
	 * @param {real} _index character index
	 * @ignore
	 */
	get_character_hidden = function(_index) {
		return character_array[_index].hidden;
	};
	
	/**
	 * Set hidden state of character at given index.
	 * @param {real} _index character index
	 * @param {bool} _hidden new hidden value of character
	 * @ignore
	 */
	set_character_hidden = function(_index, _hidden) {
		if (get_character_hidden(_index) == _hidden) return;
		split_drawables_at(_index, _index);
		character_array[_index].hidden = _hidden;
		merge_drawables_at(_index, _index);
	};
	
	/**
	 * @param {real} _index_start
	 * @param {real} _index_end
	 * @param {bool} _hidden
	 * @ignore
	 */
	set_characters_hidden = function(_index_start, _index_end, _hidden) {
		for (var _i = _index_start; _i <= _index_end; _i++) {
			set_character_hidden(_i, _hidden);
		}
	};
	
	/**
	 * @param {real} _index
	 * @param {bool} _new_line
	 * @ignore
	 */
	set_new_line_at = function(_index, _new_line) {
		character_array[_index].new_line = _new_line;
		init_drawables();
	};
}
