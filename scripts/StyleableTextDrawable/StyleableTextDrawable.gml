global.drawables_drawn = 0;

/**
 * Get a new StyleableTextDrawable instance.
 *
 * @param {array<struct.StyleableTextCharacter>} char_array reference to a StyleableTextCharacter array
 * @param {real} i_start index of first character this drawable references, inclusive
 * @param {real} i_end index of last character this drawable references, inclusive
 * @ignore
 */
function StyleableTextDrawable(char_array, i_start, i_end) constructor {
	if (i_start < 0) {
		show_error("cannot create drawable with start index less than 0", true);
	}
	if (i_end >= array_length(char_array)) {
		show_error("cannot create drawable with end index greater than or equal to length of character array", true);
	}
	
	/// @ignore
	character_array = char_array;
	/// @ignore
	index_start = i_start;
	/// @ignore
	index_end = i_end;
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
	 * @param {real} new_index_end the new ending index in the character array of this drawable
	 *
	 * @ignore
	 */
	set_index_end = function(new_index_end) {
		index_end = new_index_end;
		calculate_content();
	};
	
	/// @ignore
	is_hidden = function() {
		return character_array[get_index_start()].hidden;
	}
	
	/**
	 * Split drawable at index on the left. [abc] split at index 1 becomes [a]-[bc]
	 *
	 * @param {real} index index to split at
	 * @ignore
	 */
	split_left_at_index = function(index) {
		if (index < get_index_start() || index > get_index_end()) show_error("cannot split index outside of drawable range", true);
		
		if (get_index_start() == index) return;
		 // think of this drawable as now ending at index - 1, create new link to right
		var new_right = new StyleableTextDrawable(character_array, index, get_index_end());
		set_index_end(index - 1);
		
		new_right.previous = self;
		new_right.next = next;
		if (new_right.next != undefined) new_right.next.previous = new_right;
		
		next = new_right;
	};
	
	/**
	 * Split drawable at index on the right. [abc] split at index 1 becomes [ab]-[c]
	 *
	 * @param {real} index index to split at
	 * @ignore
	 */
	split_right_at_index = function(index) {
		if (index < get_index_start() || index > get_index_end()) show_error("cannot split index outside of drawable range", true);
		
		if (get_index_end() == index) return;
		// think of this drawable as now ending at index, create new link to right
		var new_right = new StyleableTextDrawable(character_array, index + 1, get_index_end());
		set_index_end(index);
		
		new_right.previous = self;
		new_right.next = next;
		if (new_right.next != undefined) new_right.next.previous = new_right;
		
		next = new_right;
	};
	
	/**
	 * Returns true if this drawable can merge with the next drawable in the linked list.
	 *
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
		var temp_next = next;
		next = temp_next.next;
		if (temp_next.next != undefined) temp_next.next.previous = self;
		set_index_end(temp_next.get_index_end());
	};
	
	/**
	 * Draw this drawables contents and the given position.
	 *
	 * @param {real} pos_x x position
	 * @param {real} pos_y y position
	 * @ignore
	 */
	draw = function(pos_x, pos_y) {
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
		var char = character_array[index_start];
		var draw_x = pos_x + char.position_x + style.mod_x;
		var draw_y = pos_y + char.position_y + style.mod_y;
		if (sprite == spr_styleable_text_sprite_default) {
			var _originals = {
				font: draw_get_font(),
				alpha: draw_get_alpha(),
				color: draw_get_color()
			};
			draw_set_font(style.font);
			draw_set_alpha(style.alpha);
			draw_set_color(style.style_color);
			draw_text_transformed(draw_x, draw_y, content, style.scale_x, style.scale_y, style.mod_angle);
			draw_set_font(_originals.font);
			draw_set_alpha(_originals.alpha);
			draw_set_color(_originals.color);
		} else {
			draw_sprite_ext(sprite, 0, draw_x, draw_y, style.scale_x, style.scale_y, style.mod_angle, style.style_color, style.alpha);
		}
	};
}
