global.tag_decorated_text_default_font = fnt_styleable_text_font_default

/**
 * Get a new StyleableTextStyle instance.
 *
 * @ignore
 */
function StyleableTextStyle() constructor {
	/// @ignore
	font = global.tag_decorated_text_default_font;
	/// @ignore
	style_color = c_white;
	/// @ignore
	alpha = 1;
	/// @ignore
	scale_x = 1;
	/// @ignore
	scale_y = 1;
	/// @ignore
	mod_x = 0;
	/// @ignore
	mod_y = 0;
	/// @ignore
	mod_angle = 0;
	
	/**
	 * Get boolean indicating if the given style is equal to this one.
	 *
	 * @param {struct.StyleableTextStyle} style style
	 * @ignore
	 */
	is_equal = function(style) {
		if (style.font != font) return false;
		if (style.style_color != style_color) return false;
		if (style.alpha != alpha) return false;
		if (style.scale_x != scale_x) return false;
		if (style.scale_y != scale_y) return false;
		if (style.mod_x != mod_x) return false;
		if (style.mod_y != mod_y) return false;
		if (style.mod_angle != mod_angle) return false;
		return true;
	};
	
	/**
	 * Sets this styles parameters to the same as the given style.
	 *
	 * @param {struct.StyleableTextStyle} style the style to copy
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
}
