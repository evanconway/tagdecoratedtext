/**
 * @param {string} command
 * @param {real} index_start
 */
function NewCommand(command, index_start) constructor {
	var command_aarg_split = string_split(command, ":");
	
	name = command_aarg_split[0];
	
	var aarg_string = array_length(command_aarg_split) > 1 ? command_aarg_split[1] : "";
	
	var f_map = function(str) {
		try {
			var r = real(str);
			return r
		} catch(_error) {
			_error = undefined;
		}

		// Feather disable once GM1035
		return str;
	};
	
	aargs = aarg_string == "" ? [] : array_map(string_split(aarg_string, ","), f_map);
	command_index_start = index_start;
	command_index_end = -1;
}

/**
 * Creates a new TagDecoratedText instance from the given source string.
 *
 * @param {string} source_string the string with decorative tags
 * @param {string} default_effects (make version without this later)
 */
function NewTagDecoratedText(source_string, default_effects = "", width = -1, height = -1) constructor {
	/*
	The source string contains both the tags and the text to actually display. From
	this we need to build an array of commands and their index ranges as well as 
	the text to display with command tags removed.
	*/
	var commands = [];
	
	// set the end indexes of commands which haven't had their ends set yet.
	var set_command_unset_ends = method({ commands }, function(end_index) {
		// move through array backwards because commands missing index_end will always be at the end of array
		for (var _k = array_length(commands) - 1; _k >= 0; _k--) {
			if (commands[_k].command_index_end < 0) {
				commands[_k].command_index_end = end_index;
			} else {
				_k = -1; // end loop if index_end defined
			}
		}
	});
	
	var displayed_text = "";
	var index = 1; // index of character to add to string
	
	// parse out commands and displayed text
	for (var i = 1; i <= string_length(source_string); i++) {
		var c = string_char_at(source_string, i);
		var c_next = string_char_at(source_string, i + 1);
		
		// handle command
		if (c == "<" && c_next != ">" && c_next != "") {
			var end_index = string_pos_ext(">", source_string, i + 1);
			var command_text = string_copy(source_string, i + 1, end_index - i - 1);
			var command_arr = string_split(command_text, " ", true);
			for (var _k = 0; _k < array_length(command_arr); _k++) {
				array_push(commands, new NewCommand(command_arr[_k], index));
			}
			i = end_index;
		}
		
		// handle clear tag
		if (c == "<" && c_next == ">") {
			set_command_unset_ends(index - 1);
			i++;
		}
		
		// handle error
		if (c == "<" && c_next == "") {
			show_error("Improper tags used in tag decorated text!", true);
		}
		
		// handle regular text
		if (c != "<") {
			displayed_text += c;
			index++;
		}
	}
	
	// set ends for commands with unset ends
	set_command_unset_ends(string_length(displayed_text));
	
	// before parsing commands, extract default commands and insert into regular command array
	var default_commands = [];
	var default_command_arr = string_split(default_effects, " ", true);
	for (var d = 0; d < array_length(default_command_arr); d++) {
		var new_command = new NewCommand(default_command_arr[d], 1);
		new_command.command_index_end = string_length(displayed_text);
		array_push(default_commands, new_command);
	}
	while (array_length(default_commands) > 0) {
		array_insert(commands, 0, array_pop(default_commands));
	}
	
	styleable_text = new New_StyleableText(displayed_text, width, height);
	animator = new StyleableTextAnimator(styleable_text);
	
	/*
	Since applying default styles also requires rebuilding the styleable
	text, we apply default character styles first, build the text, then
	apply animations.
	*/
	
	// apply base character styles first
	for (var i = 0; i < array_length(commands); i++) {
		var cmd = string_lower(commands[i].name);
		var aargs = commands[i].aargs;
		
		// convert string index to array index for applying effects
		var s = commands[i].command_index_start - 1;
		var e = commands[i].command_index_end - 1;
		
		// colors
		if (cmd == "aqua") styleable_text.set_character_color(s, e, c_aqua);
		if (cmd == "black") styleable_text.set_character_color(s, e, c_black);
		if (cmd == "blue") styleable_text.set_character_color(s, e, c_blue);
		if (cmd == "dkgray" || cmd == "dkgrey") styleable_text.set_character_color(s, e, c_dkgray);
		if (cmd == "pink" || cmd == "fuchsia") styleable_text.set_character_color(s, e, c_fuchsia);
		if (cmd == "gray" || cmd == "grey") styleable_text.set_character_color(s, e, c_gray);
		if (cmd == "green") styleable_text.set_character_color(s, e, c_green);
		if (cmd == "lime") styleable_text.set_character_color(s, e, c_lime);
		if (cmd == "ltgray" || cmd == "ltgrey") styleable_text.set_character_color(s, e, c_ltgray);
		if (cmd == "maroon") styleable_text.set_character_color(s, e, c_maroon);
		if (cmd == "navy") styleable_text.set_character_color(s, e, c_navy);
		if (cmd == "olive") styleable_text.set_character_color(s, e, c_olive);
		if (cmd == "orange") styleable_text.set_character_color(s, e, c_orange);
		if (cmd == "purple") styleable_text.set_character_color(s, e, c_purple);
		if (cmd == "red") styleable_text.set_character_color(s, e, c_red);
		if (cmd == "silver") styleable_text.set_character_color(s, e, c_silver);
		if (cmd == "teal") styleable_text.set_character_color(s, e, c_teal);
		if (cmd == "white") styleable_text.set_character_color(s, e, c_white);
		if (cmd == "yellow") styleable_text.set_character_color(s, e, c_yellow);
		if (cmd == "rgb") styleable_text.set_character_color(s, e, make_color_rgb(aargs[0], aargs[1], aargs[2]));
		
		// page break changing styles
		if (cmd == "n" || cmd == "br") styleable_text.set_character_new_line(s, true);
		if (cmd == "f" || cmd == "font") styleable_text.set_character_font(s, e, aargs[0]);
		if (cmd == "a" || cmd == "alpha") styleable_text.set_character_alpha(s, e, aargs[0]);
		if (cmd == "x") styleable_text.set_character_offset_x(s, e, aargs[0]);
		if (cmd == "y") styleable_text.set_character_offset_y(s, e, aargs[0]);
		if (cmd == "xy") {
			if (array_length(aargs) != 2) show_error("incorrect number of arguments given for offset xy command", true);
			styleable_text.set_character_offset_x(s, e, aargs[0]);
			styleable_text.set_character_offset_y(s, e, aargs[1]);
		}
		if (cmd == "scalex") styleable_text.set_character_scale_x(s, e, aargs[0]);
		if (cmd == "scaley") styleable_text.set_character_scale_y(s, e, aargs[0]);
		if (cmd == "scalexy") {
			if (array_length(aargs) != 2) show_error("incorrect number of arguments given for scalexy command", true);
			styleable_text.set_character_scale_x(s, e, aargs[0]);
			styleable_text.set_character_scale_y(s, e, aargs[1]);
		}
		if (cmd == "scale") {
			if (array_length(aargs) != 1) show_error("incorrect number of arguments given for scale command", true);
			styleable_text.set_character_scale_x(s, e, aargs[0]);
			styleable_text.set_character_scale_y(s, e, aargs[0]);
		}
		if (cmd == "s" || cmd == "sprite") styleable_text.set_character_sprite(s, aargs[0]);
	}
	
	styleable_text.build();
	
	// typer must be defined after text has been built because it required page data
	typer = new StyleableTextTyper(styleable_text, animator);
	
	// add animations
	for (var i = 0; i < array_length(commands); i++) {
		var cmd = string_lower(commands[i].name);
		var aargs = commands[i].aargs;
		
		// convert string index to array index for applying effects
		var s = commands[i].command_index_start - 1;
		var e = commands[i].command_index_end - 1;
		
		// animations
		if (cmd == "fade") animator.add_animation(ANIMATED_TEXT_ANIMATIONS.FADE, s, e, aargs);
		if (cmd == "shake") animator.add_animation(ANIMATED_TEXT_ANIMATIONS.SHAKE, s, e, aargs);
		if (cmd == "tremble") animator.add_animation(ANIMATED_TEXT_ANIMATIONS.TREMBLE, s, e, aargs);
		if (cmd == "chromatic") animator.add_animation(ANIMATED_TEXT_ANIMATIONS.CHROMATIC, s, e, aargs);
		if (cmd == "wchromatic") animator.add_animation(ANIMATED_TEXT_ANIMATIONS.WCHROMATIC, s, e, aargs);
		if (cmd == "wave") animator.add_animation(ANIMATED_TEXT_ANIMATIONS.WAVE, s, e, aargs);
		if (cmd == "float") animator.add_animation(ANIMATED_TEXT_ANIMATIONS.FLOAT, s, e, aargs);
		if (cmd == "blink") animator.add_animation(ANIMATED_TEXT_ANIMATIONS.BLINK, s, e, aargs);
		if (cmd == "twitch") animator.add_animation(ANIMATED_TEXT_ANIMATIONS.TWITCH, s, e, aargs);
		
		// entry animations
		if (cmd == "fadein") {
			for (var k = s; k <= e; k++) {
				typer.add_type_animation_at(k, ANIMATED_TEXT_ANIMATIONS.FADEIN, aargs);
			}
		}
		if (cmd == "risein") {
			for (var k = s; k <= e; k++) {
				typer.add_type_animation_at(k, ANIMATED_TEXT_ANIMATIONS.RISEIN, aargs);
			}
		}
	}
	
	/*
	The effects of animations are not visible until they've been updated. The update function is when they
	make cuts and edits to the drawables. But there are cases where we want to draw text with its current
	animation state, but without progressing the animations. We use this flag to track whether animations
	have been updated. And in situations where we want to draw without progressing animations, we'll
	update animations by 0ms.
	*/
	animations_updated = false;
}

/**
 * Updates the given tag decorated text instance by the given time in ms. If no time is specified
 * the tag decorated text instance is updated by time in ms of 1 frame of the current game speed.
 *
 * @param {Struct.New_Tag} tag_decorated_text
 * @param {real} update_time_ms
 */
function tag_update(tag_decorated_text, update_time_ms = 1000 / game_get_speed(gamespeed_fps)) {
	with (tag_decorated_text) {
		typer.update(update_time_ms);
		animator.update(update_time_ms);
		animations_updated = true;
	}
}

/**
 * Draws the given tag decorated text instance without updating it.
 *
 * @param {Struct.New_Tag} tag_decorated_text
 * @param {real} x
 * @param {real} y
 * @param {Constant.HAlign} alignment
 */
function tag_draw_no_update(tag_decorated_text, x, y) {
	with (tag_decorated_text) {
		if (!animations_updated) animator.update(0);
		styleable_text.draw(x, y);
		animations_updated = false;
	}
}

/**
 * Updates and draws the given tag decorated text instance.
 *
 * @param {Struct.New_Tag} tag_decorated_text
 * @param {real} x
 * @param {real} y
 * @param {real} update_time_ms
 */
function tag_draw(tag_decorated_text, x, y, update_time_ms = 1000 / game_get_speed(gamespeed_fps)) {
	tag_update(tag_decorated_text);
	tag_draw_no_update(tag_decorated_text, x, y);
}


/**
 * Resets the state of all animations of the given tag decorated text instance.
 *
 * @param {Struct.New_Tag} tag_decorated_text
 */
function tag_reset_animations(tag_decorated_text) {
	tag_decorated_text.animator.reset();
}

/**
 * Resets typing state of given tag_decorated_text instance. Tag decorated text instances
 * are "typed" by default. This function must be called before typing update will have
 * any effect.
 *
 * @param {Struct.New_Tag} tag_decorated_text
 */
function tag_reset_typing(tag_decorated_text) {
	tag_decorated_text.animator.reset();
	tag_decorated_text.typer.reset_typing();
	tag_decorated_text.styleable_text.text_page_index = 0;
}

/**
 * Sets the typing state of the current page to finished.
 *
 * @param {Struct.New_Tag} tag_decorated_text
 */
function tag_type_current_page(tag_decorated_text) {
	tag_decorated_text.typer.finish_typing_current_page();
}

/**
 * Sets the typing state of all pages to finished.
 *
 * @param {Struct.New_Tag} tag_decorated_text
 */
function tag_type_all_pages(tag_decorated_text) {
	tag_decorated_text.typer.finish_typing_all_pages();
}

/**
 * Go to the next page.
 *
 * @param {Struct.New_Tag} tag_decorated_text
 */
function tag_page_next(tag_decorated_text) {
	tag_decorated_text.styleable_text.page_next();
}

/**
 * Go to the previous page.
 *
 * @param {Struct.New_Tag} tag_decorated_text
 */
function tag_page_previous(tag_decorated_text) {
	tag_decorated_text.styleable_text.page_previous();
}

/**
 * Advances typing state in a logical way. If the current page is not
 * typed, current page typing state is set to finished. If current page
 * is typed, text is advanced to the next page.
 *
 * @param {Struct.New_Tag} tag_decorated_text
 */
function tag_advance(tag_decorated_text) {
	if (!tag_decorated_text.typer.get_current_page_finished()) {
		tag_type_current_page(tag_decorated_text);
		return;
	}
	tag_page_next(tag_decorated_text);
}
