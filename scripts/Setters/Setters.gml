/**
 * @param {struct.New_StyleableText} text
 * @param {real} index_start
 * @param {real} index_end
 * @param {Asset.GMFont} font
 */
function text_set_default_font(text, index_start, index_end, font) {
	with (text) {
		var index_stop = min(array_length(character_array) - 1, index_end);
		for (var i = index_start; i <= index_stop; i++) {
			character_array[i].style.font = font;
		}
	}
}

/**
 * @param {struct.New_StyleableText} text
 * @param {real} index_start
 * @param {real} index_end
 * @param {Constant.Color} color
 */
function text_set_default_color(text, index_start, index_end, color) {
	with (text) {
		var index_stop = min(array_length(character_array) - 1, index_end);
		for (var i = index_start; i <= index_stop; i++) {
			character_array[i].style.color = color;
		}
	}
}

/**
 * @param {struct.New_StyleableText} text
 * @param {real} index_start
 * @param {real} index_end
 * @param {real} alpha
 */
function text_set_default_alpha(text, index_start, index_end, alpha) {
	with (text) {
		var index_stop = min(array_length(character_array) - 1, index_end);
		for (var i = index_start; i <= index_stop; i++) {
			character_array[i].style.alpha = alpha;
		}
	}
}

/**
 * @param {struct.New_StyleableText} text
 * @param {real} index_start
 * @param {real} index_end
 * @param {real} scale_x
 */
function text_set_default_scale_x(text, index_start, index_end, scale_x) {
	with (text) {
		var index_stop = min(array_length(character_array) - 1, index_end);
		for (var i = index_start; i <= index_stop; i++) {
			character_array[i].style.scale_x = scale_x;
		}
	}
}

/**
 * @param {struct.New_StyleableText} text
 * @param {real} index_start
 * @param {real} index_end
 * @param {real} scale_y
 */
function text_set_default_scale_y(text, index_start, index_end, scale_y) {
	with (text) {
		var index_stop = min(array_length(character_array) - 1, index_end);
		for (var i = index_start; i <= index_stop; i++) {
			character_array[i].style.scale_y = scale_y;
		}
	}
}

/**
 * @param {struct.New_StyleableText} text
 * @param {real} index_start
 * @param {real} index_end
 * @param {real} offset_x
 */
function text_set_default_offset_x(text, index_start, index_end, offset_x) {
	with (text) {
		var index_stop = min(array_length(character_array) - 1, index_end);
		for (var i = index_start; i <= index_stop; i++) {
			character_array[i].style.offset_x = offset_x;
		}
	}
}

/**
 * @param {struct.New_StyleableText} text
 * @param {real} index_start
 * @param {real} index_end
 * @param {real} offset_y
 */
function text_set_default_offset_y(text, index_start, index_end, offset_y) {
	with (text) {
		var index_stop = min(array_length(character_array) - 1, index_end);
		for (var i = index_start; i <= index_stop; i++) {
			character_array[i].style.offset_y = offset_y;
		}
	}
}

/**
 * @param {struct.New_StyleableText} text
 * @param {real} index
 * @param {Asset.GMSprite} sprite
 */
function text_set_default_sprite(text, index, sprite) {
	with (text) {
		character_array[index].style.sprite = sprite;
	}
}

/**
 * @param {struct.New_StyleableText} text
 * @param {real} index
 * @param {bool} new_line
 */
function text_set_default_new_line(text, index, new_line) {
	with (text) {
		character_array[index].style.new_line = new_line;
	}
}

/**
 * @param {struct.New_StyleableText} text
 * @param {real} index_start
 * @param {real} index_end
 * @param {Constant.Color} color
 */
function text_set_color(text, index_start, index_end, color) {
	with (text) {
		split_drawables_at_index_range(index_start, index_end);
		var index = index_start;
		while (index <= index_end) {
			character_array[index].drawable.style.color = color;
			index = character_array[index].drawable.index_end + 1;
		}
	}
}

/**
 * @param {struct.New_StyleableText} text
 * @param {real} index_start
 * @param {real} index_end
 * @param {real} alpha
 */
function text_apply_alpha(text, index_start, index_end, alpha) {
	with (text) {
		split_drawables_at_index_range(index_start, index_end);
		var index = index_start;
		while (index <= index_end) {
			character_array[index].drawable.style.alpha *= alpha;
			index = character_array[index].drawable.index_end + 1;
		}
	}
}

/**
 * @param {struct.New_StyleableText} text
 * @param {real} index_start
 * @param {real} index_end
 * @param {Asset.GMFont} font
 */
function text_set_font(text, index_start, index_end, font) {
	with (text) {
		split_drawables_at_index_range(index_start, index_end);
		var index = index_start;
		while (index <= index_end) {
			character_array[index].drawable.style.font = font;
			index = character_array[index].drawable.index_end + 1;
		}
	}
}

/**
 * @param {struct.New_StyleableText} text
 * @param {real} index_start
 * @param {real} index_end
 * @param {real} scale_x
 */
function text_apply_scale_x(text, index_start, index_end, scale_x) {
	with (text) {
		split_drawables_at_index_range(index_start, index_end);
		var index = index_start;
		while (index <= index_end) {
			character_array[index].drawable.style.scale_x *= scale_x;
			index = character_array[index].drawable.index_end + 1;
		}
	}
}

/**
 * @param {struct.New_StyleableText} text
 * @param {real} index_start
 * @param {real} index_end
 * @param {real} scale_y
 */
function text_apply_scale_y(text, index_start, index_end, scale_y) {
	with (text) {
		split_drawables_at_index_range(index_start, index_end);
		var index = index_start;
		while (index <= index_end) {
			character_array[index].drawable.style.scale_y *= scale_y;
			index = character_array[index].drawable.index_end + 1;
		}
	}
}

/**
 * @param {struct.New_StyleableText} text
 * @param {real} index_start
 * @param {real} index_end
 * @param {real} offset_x
 */
function text_add_offset_x(text, index_start, index_end, offset_x) {
	with (text) {
		split_drawables_at_index_range(index_start, index_end);
		var index = index_start;
		while (index <= index_end) {
			character_array[index].drawable.style.offset_x += offset_x;
			index = character_array[index].drawable.index_end + 1;
		}
	}
}

/**
 * @param {struct.New_StyleableText} text
 * @param {real} index_start
 * @param {real} index_end
 * @param {real} offset_y
 */
function text_add_offset_y(text, index_start, index_end, offset_y) {
	with (text) {
		split_drawables_at_index_range(index_start, index_end);
		var index = index_start;
		while (index <= index_end) {
			character_array[index].drawable.style.offset_y += offset_y;
			index = character_array[index].drawable.index_end + 1;
		}
	}
}

/**
 * @param {struct.New_StyleableText} text
 * @param {real} index
 * @param {Asset.GMSprite} sprite
 */
function text_set_sprite(text, index, sprite) {
	with (text) {
		split_drawables_at_index_range(index, index);
		character_array[index].drawable.style.sprite = sprite;
	}
}
