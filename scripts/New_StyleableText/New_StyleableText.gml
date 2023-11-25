/**
 * Creates a new styleable text instance.
 *
 * @param {string} text
 */
function New_StyleableText(text, width=-1, height=-1) constructor {
	character_array = [];
	
	static get_style = function() {
		return {
			font: fnt_styleable_text_font_default,
			color: c_white,
			alpha: 1,
			scale_x: 1,
			scale_y: 1,
			offset_x: 0,
			offset_y: 0
		};
	};
	
	static get_char_width = function(char) {
		if (char.sprite == spr_styleable_text_sprite_default) return sprite_get_width(char.sprite) * char.style.scale_x;
		draw_set_font(char.style.font);
		return string_width(char.char) * char.style.scale_x;
	};
	
	static get_char_height = function(char) {
		if (char.sprite == spr_styleable_text_sprite_default) return sprite_get_height(char.sprite) * char.style.scale_y;
		draw_set_font(char.style.font);
		return string_height(char.char) * char.style.scale_y;
	};
	
	// create char array
	var text_length = string_length(text);
	for (var i = 1; i <= text_length; i++) {
		array_push(character_array, {
			char: string_char_at(text, i),
			style: get_style(),
			sprite: spr_styleable_text_sprite_default,
			new_line: false, // forces new line start
			x: 0,
			y: 0,
			line_index: 0,
			page_index: 0
		});
	}
	
	// determine position, line, and page of each character
	var char_arr_length = array_length(character_array);
	var line_index = 0;
	var page_index = 0;
	
	var word_width = 0;
	var line_width = 0;
	var line_height = 0;
	var char_x = 0;
	var char_y = 0;
	var word_complete = false;
	for (var i = 0; i < char_arr_length; i++) {
		var char = character_array[i];
		var char_width = get_char_width(char);
		var char_height = get_char_height(char);
		
		var char_is_space = char.char == " ";
		
		if (char_is_space) {
			word_complete = true;
		} else if (!word_complete) {
			// do nothing?
		} else if (word_) {
			
		}
		
		char.x = char_x;
		char.y = char_y;
		char.line_index = line_index;
		char.page_index = page_index;
		
		word_width +=  char_is_space ? 0 : char_width;
		char_x += char_width;
		if (char_height > line_height) line_height = char_height;
	}
}

function new_text_draw_char_array(text) {
	with (text) {
		var char_arr_length = array_length(character_array);
		for (var i = 0; i < char_arr_length; i++) {
			var c = character_array[i];
			draw_set_font(c.style.font);
			draw_set_color(c.style.color);
			draw_set_alpha(c.style.alpha);
			draw_text(c.x, c.y, c.char);
		}
	}
}

var test_text = new New_StyleableText("The quick brown fox jumps over the lazy dog.");

new_text_draw_char_array(test_text);
