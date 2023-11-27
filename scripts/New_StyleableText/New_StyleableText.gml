/**
 * Creates a new styleable text instance.
 *
 * @param {string} text
 */
function New_StyleableText(text, width=-1, height=-1) constructor {
	character_array = [];
	text_width = width;
	text_height = height;
	
	static get_char_width = function(char) {
		if (char.sprite != spr_styleable_text_sprite_default) return sprite_get_width(char.sprite) * char.style.scale_x;
		draw_set_font(char.style.font);
		return string_width(char.char) * char.style.scale_x;
	};
	
	static get_char_height = function(char) {
		if (char.sprite != spr_styleable_text_sprite_default) return sprite_get_height(char.sprite) * char.style.scale_y;
		draw_set_font(char.style.font);
		return string_height(char.char) * char.style.scale_y;
	};
	
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
			page_index: 0
		});
	}
	
	calculate_char_positions = function() {
		var char_arr_length = array_length(character_array);
		var word_i_start = 0;
		var word_i_end = 0;	// inclusive
		var word_width = 0;	// width of letter chars, excludes trailing spaces
		var line_height = 0;
		var char_x = 0;
		var char_y = 0;
		var word_complete = false; // space encountered
		
		// mapping of line y positions to height
		var line_heights = ds_map_create();
		
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

			if (add_word_to_line && text_width > 0 && char_x + word_width >= text_width) {
				char_x = 0;
				char_y += line_height;
				line_height = 0;
			}
		
			if (add_word_to_line) {
				for (var w = word_i_start; w <= word_i_end; w++) {
					character_array[w].x = char_x;
					character_array[w].y = char_y;
					char_x += get_char_width(character_array[w]);
					var char_height = get_char_height(character_array[w]);
					if (char_height > line_height) line_height = char_height;
					ds_map_set(line_heights, char_y, line_height);
				}
				word_i_start = i;
				word_i_end = i;
				word_width = i < char_arr_length ? get_char_width(character_array[i]) : 0;
				word_complete = false;
			}
		}
		
		// skip page index calculation if no height set
		if (text_height < 0) return;
		
		// determine page index
		var line_keys = ds_map_keys_to_array(line_heights);
		var page_height = ds_map_find_value(line_heights, line_keys[0]);
		var page_index = 0;
		var page_index_line_mapping = ds_map_create();
		ds_map_set(page_index_line_mapping, line_keys[0], page_index);
		for (var k = 1; k < array_length(line_keys); k++) {
			var line_height = ds_map_find_value(line_heights, line_keys[k]);
			if (line_height + page_height > text_height) {
				page_index++;
				page_height = line_height;
			}
		}
	};
	
	calculate_char_positions();
}

function new_text_draw_char_array(x, y, text) {
	with (text) {
		var char_arr_length = array_length(character_array);
		for (var i = 0; i < char_arr_length; i++) {
			var c = character_array[i];
			draw_set_font(c.style.font);
			draw_set_color(c.style.color);
			draw_set_alpha(c.style.alpha);
			draw_text(x + c.x, y + c.y, c.char);
		}
	}
}
