var _temp_get_random = function() {
	return random(1);
};

/// @ignore
global.animated_text_animation_random_array = array_map(array_create(1000000, 0), _temp_get_random);

/**
 * Get a random number from 0 to 1 (inclusive 0, exclusive 1) given an index. Returns the same number for the same index.
 * @param {real} _index
 * @ignore
 */
function animated_text_get_random(_index) {
	_index %= array_length(global.animated_text_animation_random_array);
	return global.animated_text_animation_random_array[floor(_index)];
}

/**
 * @param {real} _index
 * @ignore
 */
function animated_text_chromatic_red_at(_index) {
	_index = abs(_index);
	_index %= 1536;
	if (_index >= 0 && _index < 256) {
		return 255;
	}
	if (_index >= 256 && _index < 512) {
		return 511 - _index;
	}
	if (_index >= 512 && _index < 768) {
		return 0;
	}
	if (_index >= 768 && _index < 1024) {
		return 0;
	}
	if (_index >= 1024 && _index < 1280) {
		return _index - 1024;
	}
	if (_index >= 1280 && _index < 1536) {
		return 255;
	}
	return 0;
}

/**
 * @param {real} _index
 * @ignore
 */
function animated_text_chromatic_green_at(_index) {
	_index = abs(_index);
	_index %= 1536;
	if (_index >= 0 && _index < 256) {
		return _index;
	}
	if (_index >= 256 && _index < 512) {
		return 255;
	}
	if (_index >= 512 && _index < 768) {
		return 255;
	}
	if (_index >= 768 && _index < 1024) {
		return 1023 - _index;
	}
	if (_index >= 1024 && _index < 1280) {
		return 0;
	}
	if (_index >= 1280 && _index < 1536) {
		return 0;
	}
	return 0;
}

/**
 * @param {real} _index
 * @ignore
 */
function animated_text_chromatic_blue_at(_index) {
	_index = abs(_index);
	_index %= 1536;
	if (_index >= 0 && _index < 256) {
		return 0;
	}
	if (_index >= 256 && _index < 512) {
		return 0;
	}
	if (_index >= 512 && _index < 768) {
		return _index - 512;
	}
	if (_index >= 768 && _index < 1024) {
		return 255;
	}
	if (_index >= 1024 && _index < 1280) {
		return 255;
	}
	if (_index >= 1280 && _index < 1536) {
		return 1535 - _index;
	}
	return 0;
}

/**
 * Get an rgb color based on an index. The color will progress through the spectrum as the index increases. The same index returns the same color.
 * @param {real} _index
 * @ignore
 */
function animated_text_get_chromatic_color_at(_index) {
	var _red = animated_text_chromatic_red_at(_index);
	var _green = animated_text_chromatic_green_at(_index);
	var _blue = animated_text_chromatic_blue_at(_index);
	return make_color_rgb(_red, _green, _blue);
}
