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
	
	// create char array
	var text_length = string_length(text);
	for (var i = 1; i <= text_length; i++) {
		array_push(character_array, {
			char: string_char_at(text, i),
			style: {
				font: fnt_styleable_text_font_default,
				color: c_white,
				alpha: 1,
				scale_x: 1,
				scale_y: 1,
				offset_x: 0,
				offset_y: 0
			},
			sprite: spr_styleable_text_sprite_default,
			new_line: false, // forces new line start
			x: 0,
			y: 0,
			line_index: 0,
			page_index: 0
		});
	}
	
	/**
	 * @return {real}
	 */
	static get_char_width = function(char) {
		if (char.sprite != spr_styleable_text_sprite_default) return sprite_get_width(char.sprite) * char.style.scale_x;
		draw_set_font(char.style.font);
		return string_width(char.char) * char.style.scale_x;
	};
	
	/**
	 * @return {real}
	 */
	static get_char_height = function(char) {
		if (char.sprite != spr_styleable_text_sprite_default) return sprite_get_height(char.sprite) * char.style.scale_y;
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
}

function new_text_page_previous(text) {
	text.text_page_index = max(text.text_page_index - 1, 0);
}

function new_text_page_next(text) {
	text.text_page_index = min(text.text_page_index + 1, text.text_page_index_max);
}

function new_text_draw_char_array(x, y, text) {
	with (text) {
		var char_arr_length = array_length(character_array);
		for (var i = 0; i < char_arr_length; i++) {
			var c = character_array[i];
			if (c.page_index == text_page_index) {
				draw_set_font(c.style.font);
				draw_set_color(c.style.color);
				draw_set_alpha(c.style.alpha);
				draw_text(x + c.x, y + c.y, c.char);
			}
		}
	}
}
