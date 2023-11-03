/**
 * Get a new StyleableCharacter instance.
 *
 * @param {string} char Single character string.
 * @ignore
 */
function StyleableTextCharacter(char) constructor {
	if (string_length(char) != 1) {
		show_error("string _character must be length 1", true);
	}
	/// @ignore
	character = char;
	/// @ignore
	sprite = spr_styleable_text_sprite_default; // treated as undefined
	/// @ignore
	line_index = 0;
	/// @ignore
	new_line = false; // forces new line start on this character
	/// @ignore
	position_x = 0;
	/// @ignore
	position_y = 0;
	/// @ignore
	style = new StyleableTextStyle();
	/// @ignore
	drawable = undefined; // the drawable that draws this character
	/// @ignore
	get_width = function() {
		if (sprite != spr_styleable_text_sprite_default) {
			return sprite_get_width(sprite) * style.scale_x;
		}
		var _original = draw_get_font();
		draw_set_font(style.font);
		var _result = string_width(character) * style.scale_x;
		draw_set_font(_original);
		return _result;
	}
	/// @ignore
	get_height = function() {
		if (sprite != spr_styleable_text_sprite_default) {
			return sprite_get_height(sprite) * style.scale_y;
		}
		var _original = draw_get_font();
		draw_set_font(style.font);
		var _result = string_height(character) * style.scale_y;
		draw_set_font(_original);
		return _result;
	};
	/// @ignore
	hidden = false;
}
