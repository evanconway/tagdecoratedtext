// feather ignore all

/**
 * @param {struct.__TagDecoratedTextStyleable} text
 * @param {real} index_start
 * @param {real} index_end
 * @param {Constant.Color} color
 * @ignore
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
 * @param {struct.__TagDecoratedTextStyleable} text
 * @param {real} index_start
 * @param {real} index_end
 * @param {real} alpha
 * @ignore
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
 * @param {struct.__TagDecoratedTextStyleable} text
 * @param {real} index_start
 * @param {real} index_end
 * @param {Asset.GMFont} font
 * @ignore
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
 * @param {struct.__TagDecoratedTextStyleable} text
 * @param {real} index_start
 * @param {real} index_end
 * @param {real} scale_x
 * @ignore
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
 * @param {struct.__TagDecoratedTextStyleable} text
 * @param {real} index_start
 * @param {real} index_end
 * @param {real} scale_y
 * @ignore
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
 * @param {struct.__TagDecoratedTextStyleable} text
 * @param {real} index_start
 * @param {real} index_end
 * @param {real} offset_x
 * @ignore
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
 * @param {struct.__TagDecoratedTextStyleable} text
 * @param {real} index_start
 * @param {real} index_end
 * @param {real} offset_y
 * @ignore
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
 * @param {struct.__TagDecoratedTextStyleable} text
 * @param {real} index
 * @param {Asset.GMSprite} sprite
 * @ignore
 */
function text_set_sprite(text, index, sprite) {
	with (text) {
		split_drawables_at_index_range(index, index);
		character_array[index].drawable.style.sprite = sprite;
	}
}
