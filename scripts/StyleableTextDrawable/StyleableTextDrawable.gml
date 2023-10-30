global.drawables_drawn = 0;

/**
 * Get a new StyleableTextDrawable instance.
 * @param {array<struct.StyleableTextCharacter>} _character_array reference to a StyleableTextCharacter array
 * @param {real} _index_start index of first character this drawable references, inclusive
 * @param {real} _index_end index of last character this drawable references, inclusive
 * @ignore
 */
function StyleableTextDrawable(_character_array, _index_start, _index_end) constructor {
	if (_index_start < 0) {
		show_error("cannot create drawable with start index less than 0", true);
	}
	if (_index_end >= array_length(_character_array)) {
		show_error("cannot create drawable with end index greater than or equal to length of character array", true);
	}
	
	/// @ignore
	character_array = _character_array;
	/// @ignore
	index_start = _index_start;
	/// @ignore
	index_end = _index_end;
	/// @ignore
	next = undefined;
	/// @ignore
	previous = undefined;
	/// @ignore
	style = new StyleableTextStyle();
	/// @ignore
	sprite = spr_styleable_text_sprite_default;
	/// @ignore
	init_styles = function() {
		if (index_start < array_length(character_array)) {
			style.set_to(character_array[index_start].style);
			sprite = character_array[index_start].sprite;
		}
	};
	
	/// @ignore
	content = "";
	
	/// @ignore
	calculate_content = function() {
		content = "";
		for (var _i = index_start; _i <= index_end; _i++) {
			content += character_array[_i].character;
			character_array[_i].drawable = self;
		}
		init_styles();
	};
	/// @ignore
	calculate_content();
	/// @ignore
	get_index_start = function() {
		return index_start;
	};
	/// @ignore
	get_index_end = function() {
		return index_end;
	};
	
	/**
	 * @param {real} _new_index_end the new ending index in the character array of this drawable
	 * @ignore
	 */
	set_index_end = function(_new_index_end) {
		index_end = _new_index_end;
		calculate_content();
	};
	
	/// @ignore
	is_hidden = function() {
		return character_array[get_index_start()].hidden;
	}
	
	/**
	 * Split drawable at index on the left. [abc] split at index 1 becomes [a]-[bc]
	 * @param {real} _index index to split at
	 * @ignore
	 */
	split_left_at_index = function(_index) {
		if (_index < get_index_start() || _index > get_index_end()) show_error("cannot split index outside of drawable range", true);
		
		if (get_index_start() == _index) return;
		 // think of this drawable as now ending at _index - 1, create new link to right
		var _new_right = new StyleableTextDrawable(character_array, _index, get_index_end());
		set_index_end(_index - 1);
		
		_new_right.previous = self;
		_new_right.next = next;
		if (_new_right.next != undefined) _new_right.next.previous = _new_right;
		
		next = _new_right;
	};
	
	/**
	 * Split drawable at index on the right. [abc] split at index 1 becomes [ab]-[c]
	 * @param {real} _index index to split at
	 * @ignore
	 */
	split_right_at_index = function(_index) {
		if (_index < get_index_start() || _index > get_index_end()) show_error("cannot split index outside of drawable range", true);
		
		if (get_index_end() == _index) return;
		// think of this drawable as now ending at _index, create new link to right
		var _new_right = new StyleableTextDrawable(character_array, _index + 1, get_index_end());
		set_index_end(_index);
		
		_new_right.previous = self;
		_new_right.next = next;
		if (_new_right.next != undefined) _new_right.next.previous = _new_right;
		
		next = _new_right;
	};
	
	/**
	 * Returns true if this drawable can merge with the next drawable in the linked list.
	 * @ignore
	 */
	can_merge_with_next = function() {
		if (next == undefined) return false;
		if (is_hidden() != next.is_hidden()) return false;
		if (!style.is_equal(next.style)) return false;
		if (sprite != spr_styleable_text_sprite_default) return false;
		if (next.sprite != spr_styleable_text_sprite_default) return false;
		if (character_array[get_index_start()].line_index != character_array[next.get_index_start()].line_index) return false;
		return true;
	}
	
	/// @ignore
	merge_with_next = function() {
		if (!can_merge_with_next()) return;
		var _next = next;
		next = _next.next;
		if (_next.next != undefined) _next.next.previous = self;
		set_index_end(_next.get_index_end());
	};
	
	/**
	 * Draw this drawables contents and the given position.
	 * @param {real} _x x position
	 * @param {real} _y y position
	 * @ignore
	 */
	draw = function(_x, _y) {
		global.drawables_drawn++;
		if (is_hidden()) {
			init_styles();
			return;
		}
		/*
		For now we only use default styles, and for that we only
		need the first character referenced, because we can be
		sure this will be the same for all characters in range
		thanks to our merging logic.
		*/
		var _char = character_array[index_start];
		var _draw_x = _x + _char.position_x + style.mod_x;
		var _draw_y = _y + _char.position_y + style.mod_y;
		if (sprite == spr_styleable_text_sprite_default) {
			var _originals = {
				font: draw_get_font(),
				alpha: draw_get_alpha(),
				color: draw_get_color()
			};
			draw_set_font(style.font);
			draw_set_alpha(style.alpha);
			draw_set_color(style.style_color);
			draw_text_transformed(_draw_x, _draw_y, content, style.scale_x, style.scale_y, style.mod_angle);
			draw_set_font(_originals.font);
			draw_set_alpha(_originals.alpha);
			draw_set_color(_originals.color);
		} else {
			draw_sprite_ext(sprite, 0, _draw_x, _draw_y, style.scale_x, style.scale_y, style.mod_angle, style.style_color, style.alpha);
		}
	};
}
