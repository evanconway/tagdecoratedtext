function TextStyle() constructor {
	font = fnt_styleable_text_font_default;
	color = c_white;
	alpha = 1;
	scale_x = 1;
	scale_y = 1;
	offset_x = 0;
	offset_y = 0;
	sprite = spr_styleable_text_sprite_default;
	new_line = false; // forces new line start
	
	/**
	 * Get boolean indicating if the given style is equal to this one.
	 *
	 * @param {struct.TextStyle} style style
	 * @ignore
	 */
	is_equal = function(style) {
		if (style.sprite != spr_styleable_text_sprite_default) return false;
		if (style.new_line) return false;
		if (sprite != spr_styleable_text_sprite_default) return false;
		if (new_line) return false;
		if (style.font != font) return false;
		if (style.color != color) return false;
		if (style.alpha != alpha) return false;
		if (style.scale_x != scale_x) return false;
		if (style.scale_y != scale_y) return false;
		if (style.offset_x != offset_x) return false;
		if (style.offset_y != offset_y) return false;
		return true;
	};
	
	/**
	 * Sets this styles parameters to the same as the given style.
	 *
	 * @param {struct.TextStyle} style the style to copy
	 * @ignore
	 */
	set_to = function(style) {
		font = style.font;
		style_color = style.style_color;
		alpha = style.alpha;
		scale_x = style.scale_x;
		scale_y = style.scale_y;
		mod_x = style.mod_x;
		mod_y = style.mod_y;
		mod_angle = style.mod_angle;
	};
};

/**
 * Creates a new styleable text instance.
 *
 * @param {string} text
 */
function New_StyleableText(text, width=-1, height=-1) constructor {
	character_array = [];
	text_width = width;
	text_height = height;
	text_line_widths = ds_map_create(); // mapping of line indexes to line widths excluding trailing spaces
	text_page_index = 0;
	text_page_index_max = 0;
	
	// remove later, just for debugging
	drawables_debug = [];
	
	static get_new_style = function() {
		return {
			
		};
	};
	
	// create char array
	var text_length = string_length(text);
	for (var i = 1; i <= text_length; i++) {
		array_push(character_array, {
			char: string_char_at(text, i),
			style: new TextStyle(),
			x: 0,
			y: 0,
			line_index: 0,
			page_index: 0,
			drawable: {
				index_start: i - 1,
				index_end: i - 1,
				text: string_char_at(text, i),
				style: new TextStyle(),
			}
		});
	}
	
	/**
	 * @return {real}
	 */
	static get_char_width = function(char) {
		if (char.style.sprite != spr_styleable_text_sprite_default) return sprite_get_width(char.style.sprite) * char.style.scale_x;
		draw_set_font(char.style.font);
		return string_width(char.char) * char.style.scale_x;
	};
	
	/**
	 * @return {real}
	 */
	static get_char_height = function(char) {
		if (char.style.sprite != spr_styleable_text_sprite_default) return sprite_get_height(char.style.sprite) * char.style.scale_y;
		draw_set_font(char.style.font);
		return string_height(char.char) * char.style.scale_y;
	};
	
	calculate_char_positions = function() {
		var char_arr_length = array_length(character_array);
		var word_i_start = 0;
		var word_i_end = 0;	// inclusive
		var word_width = 0;	// width of letter chars, excludes trailing spaces
		var char_max_height = 0;
		var char_x = 0;
		var line_index = 0;
		var word_complete = false; // space encountered
		
		// mapping of line y positions to height
		var line_heights = ds_map_create();
		
		// determine line breaks and x position
		for (var i = 0; i <= char_arr_length; i++) {
			var add_word_to_line = false;
		
			if (i >= char_arr_length) {
				add_word_to_line = true; // always add when done with array
			} else if (character_array[i].char == " ") {
				word_complete = true;
				word_i_end = i;
			} else if (!word_complete) {
				word_width += get_char_width(character_array[i]);
				word_i_end = i;
			} else {
				add_word_to_line = true;
			}

			if (add_word_to_line && text_width >= 0 && char_x + word_width >= text_width) {
				char_x = 0;
				char_max_height = 0;
				line_index++;
			}
		
			if (add_word_to_line) {
				for (var w = word_i_start; w <= word_i_end; w++) {
					character_array[w].x = char_x;
					character_array[w].line_index = line_index;
					char_x += get_char_width(character_array[w]);
					var char_height = get_char_height(character_array[w]);
					if (char_height > char_max_height) char_max_height = char_height;
					ds_map_set(line_heights, line_index, char_max_height);
				}
				word_i_start = i;
				word_i_end = i;
				word_width = i < char_arr_length ? get_char_width(character_array[i]) : 0;
				word_complete = false;
			}
		}
		
		// determine y position and page index of line indexes
		var page_height = ds_map_find_value(line_heights, 0);
		text_page_index_max = 0;
		var line_index_y_pos_map = ds_map_create();
		var line_index_page_index_map = ds_map_create();
		ds_map_set(line_index_y_pos_map, 0, 0);
		ds_map_set(line_index_page_index_map, 0, text_page_index_max);
		
		for (var i = 1; i < ds_map_size(line_heights); i++) {
			var line_height = ds_map_find_value(line_heights, i);
			if (text_height >= 0 && line_height + page_height > text_height) {
				text_page_index_max++;
				page_height = 0;
			}
			ds_map_set(line_index_y_pos_map, i, page_height);
			ds_map_set(line_index_page_index_map, i, text_page_index_max);
			page_height += line_height;
		}
		
		// ensure line widths has default value for each index
		for (var i = 0; i < ds_map_size(line_heights); i++) {
			ds_map_set(text_line_widths, i, 0);
		}
		
		// assign page indexes, y positions and determine line widths
		var space_width = 0;
		var li_prev = 0;
		for (var i = 0; i < char_arr_length; i++) {
			var char = character_array[i];
			if (char.line_index != li_prev) {
				li_prev = char.line_index;
				space_width = 0;
			}
			if (char.char == " ") space_width += get_char_width(char);
			else {
				var line_width = ds_map_find_value(text_line_widths, char.line_index);
				ds_map_set(text_line_widths, char.line_index, line_width + get_char_width(char) + space_width);
				space_width = 0;
			}
			char.y = ds_map_find_value(line_index_y_pos_map, char.line_index);
			char.page_index = ds_map_find_value(line_index_page_index_map, char.line_index);
		}
	};
	
	calculate_char_positions();
	
	/**
	 * This function is used to determine if drawables can be merged. returns false if there are any
	 * qualities about the 2 chars at the indexes given that would prevent their drawables from
	 * being merged.
	 */
	char_drawables_mergeable = function(index_a, index_b) {
		var char_a = character_array[index_a];
		var char_b = character_array[index_b];
		if (char_a.drawable.index_end + 1 != char_b.drawable.index_start) return false;
		if (!char_a.style.is_equal(char_b.style)) return false;
		if (char_a.y != char_b.y) return false;
		return true;
	};
	
	merge_drawables = function() {
		var index = 0;
		var char_arr_length = array_length(character_array);
		while (character_array[index].drawable.index_end + 1 < char_arr_length) {
			// while possible, merge drawable with drawable at next index
			var can_merge = char_drawables_mergeable(index, character_array[index].drawable.index_end + 1);
			var drawable = character_array[index].drawable;
			var next_drawable = character_array[drawable.index_end + 1].drawable;
			if (can_merge) {
				drawable.text += next_drawable.text;
				drawable.index_end = next_drawable.index_end;
				for (var i = drawable.index_start; i <= drawable.index_end; i++) {
					character_array[i].drawable = drawable;
				}
			} else {
				index = next_drawable.index_start;
			}
		}
		
		// remove later, just for debugging
		drawables_debug = [];
		index = 0;
		while (index < char_arr_length) {
			array_push(drawables_debug, character_array[index].drawable);
			index = character_array[index].drawable.index_end + 1;
		}
	};
	merge_drawables();
}

function new_text_page_previous(text) {
	text.text_page_index = max(text.text_page_index - 1, 0);
}

function new_text_page_next(text) {
	text.text_page_index = min(text.text_page_index + 1, text.text_page_index_max);
}

function new_text_draw(x, y, text) {
	with (text) {
		var original_halign = draw_get_halign();
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		
		var char_arr_length = array_length(character_array);
		var index = 0;
		
		// debug, remove later
		draw_set_alpha(1);
		draw_set_font(fnt_styleable_text_font_default);
		draw_set_color(c_lime);
		draw_text(x, y - 30, $"drawables: {array_length(drawables_debug)}");
		
		while (index < char_arr_length) {
			var c = character_array[index];
			var drawable = c.drawable;
			if (c.page_index == text_page_index) {
				draw_set_font(drawable.style.font);
				draw_set_color(drawable.style.color);
				draw_set_alpha(drawable.style.alpha);
				var width_diff = text_width - ds_map_find_value(text_line_widths, c.line_index);
				var x_offset = 0;
				if (original_halign == fa_right) x_offset = width_diff;
				if (original_halign == fa_center) x_offset = floor(width_diff / 2);
				var draw_x = x + c.x + x_offset + drawable.style.offset_x;
				var draw_y = y + c.y + drawable.style.offset_x;
				draw_set_alpha(drawable.style.alpha);
				draw_text_transformed(draw_x, draw_y, drawable.text, drawable.style.scale_x, drawable.style.scale_y, 0);
			}
			index = drawable.index_end + 1;
		}
		draw_set_halign(original_halign);
	}
}
