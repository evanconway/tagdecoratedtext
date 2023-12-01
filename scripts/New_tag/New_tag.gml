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
	var set_command_unset_ends = function(end_index) {
		// move through array backwards because commands missing index_end will always be at the end of array
		for (var _k = array_length(commands) - 1; _k >= 0; _k--) {
			if (commands[_k].command_index_end < 0) {
				commands[_k].command_index_end = end_index;
			} else {
				_k = -1; // end loop if index_end defined
			}
		}
	};
	
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
	
	// apply commands
	for (var i = 0; i < array_length(commands); i++) {
		var cmd = string_lower(commands[i].name);
		var aargs = commands[i].aargs;
		
		// convert string index to array index for applying effects
		var s = commands[i].command_index_start - 1;
		var e = commands[i].command_index_end - 1;
		
		// colors
		// animation and style setters must be applied here
		if (cmd == "aqua") _typed_animated_text.animated_text.text.set_default_color(s, e, c_aqua);
		if (cmd == "black") _typed_animated_text.animated_text.text.set_default_color(s, e, c_black);
		if (cmd == "blue") _typed_animated_text.animated_text.text.set_default_color(s, e, c_blue);
		if (cmd == "dkgray" || cmd == "dkgrey") _typed_animated_text.animated_text.text.set_default_color(s, e, c_dkgray);
		if (cmd == "pink" || cmd == "fuchsia") _typed_animated_text.animated_text.text.set_default_color(s, e, c_fuchsia);
		if (cmd == "gray" || cmd == "grey") _typed_animated_text.animated_text.text.set_default_color(s, e, c_gray);
		if (cmd == "green") _typed_animated_text.animated_text.text.set_default_color(s, e, c_green);
		if (cmd == "lime") _typed_animated_text.animated_text.text.set_default_color(s, e, c_lime);
		if (cmd == "ltgray" || cmd == "ltgrey") _typed_animated_text.animated_text.text.set_default_color(s, e, c_ltgray);
		if (cmd == "maroon") _typed_animated_text.animated_text.text.set_default_color(s, e, c_maroon);
		if (cmd == "navy") _typed_animated_text.animated_text.text.set_default_color(s, e, c_navy);
		if (cmd == "olive") _typed_animated_text.animated_text.text.set_default_color(s, e, c_olive);
		if (cmd == "orange") _typed_animated_text.animated_text.text.set_default_color(s, e, c_orange);
		if (cmd == "purple") _typed_animated_text.animated_text.text.set_default_color(s, e, c_purple);
		if (cmd == "red") _typed_animated_text.animated_text.text.set_default_color(s, e, c_red);
		if (cmd == "silver") _typed_animated_text.animated_text.text.set_default_color(s, e, c_silver);
		if (cmd == "teal") _typed_animated_text.animated_text.text.set_default_color(s, e, c_teal);
		if (cmd == "white") _typed_animated_text.animated_text.text.set_default_color(s, e, c_white);
		if (cmd == "yellow") _typed_animated_text.animated_text.text.set_default_color(s, e, c_yellow);
		if (cmd == "rgb") _typed_animated_text.animated_text.text.set_default_color(s, e, make_color_rgb(aargs[0], aargs[1], aargs[2]));
		
		// animations
		if (cmd == "fade") _typed_animated_text.animated_text.add_animation(ANIMATED_TEXT_ANIMATIONS.FADE, s, e, aargs);
		if (cmd == "shake") _typed_animated_text.animated_text.add_animation(ANIMATED_TEXT_ANIMATIONS.SHAKE, s, e, aargs);
		if (cmd == "tremble") _typed_animated_text.animated_text.add_animation(ANIMATED_TEXT_ANIMATIONS.TREMBLE, s, e, aargs);
		if (cmd == "chromatic") _typed_animated_text.animated_text.add_animation(ANIMATED_TEXT_ANIMATIONS.CHROMATIC, s, e, aargs);
		if (cmd == "wchromatic") _typed_animated_text.animated_text.add_animation(ANIMATED_TEXT_ANIMATIONS.WCHROMATIC, s, e, aargs);
		if (cmd == "wave") _typed_animated_text.animated_text.add_animation(ANIMATED_TEXT_ANIMATIONS.WAVE, s, e, aargs);
		if (cmd == "float") _typed_animated_text.animated_text.add_animation(ANIMATED_TEXT_ANIMATIONS.FLOAT, s, e, aargs);
		if (cmd == "blink") _typed_animated_text.animated_text.add_animation(ANIMATED_TEXT_ANIMATIONS.BLINK, s, e, aargs);
		
		// entry animations
		if (cmd == "fadein") {
			for (var k = s; k <= e; k++) {
				_typed_animated_text.add_entry_animation_at(k, ANIMATED_TEXT_ANIMATIONS.FADEIN, aargs);
			}
		}
		if (cmd == "risein") {
			for (var k = s; k <= e; k++) {
				_typed_animated_text.add_entry_animation_at(k, ANIMATED_TEXT_ANIMATIONS.RISEIN, aargs);
			}
		}
		
		// other
		if (cmd == "n" || cmd == "br") _typed_animated_text.animated_text.text.set_new_line_at(s, true);
		if (cmd == "f" || cmd == "font") _typed_animated_text.animated_text.text.set_default_font(s, e, aargs[0]);
		if (cmd == "a" || cmd == "alpha") _typed_animated_text.animated_text.text.set_default_alpha(s, e, aargs[0]);
		if (cmd == "x") _typed_animated_text.animated_text.text.set_default_mod_x(s, e, aargs[0]);
		if (cmd == "y") _typed_animated_text.animated_text.text.set_default_mod_y(s, e, aargs[0]);
		if (cmd == "xy") {
			_typed_animated_text.animated_text.text.set_default_mod_x(s, e, aargs[0]);
			_typed_animated_text.animated_text.text.set_default_mod_y(s, e, aargs[1]);
		}
		if (cmd == "scalex") _typed_animated_text.animated_text.text.set_default_scale_x(s, e, aargs[0]);
		if (cmd == "scaley") _typed_animated_text.animated_text.text.set_default_scale_y(s, e, aargs[0]);
		if (cmd == "scalexy") {
			_typed_animated_text.animated_text.text.set_default_scale_x(s, e, aargs[0]);
			_typed_animated_text.animated_text.text.set_default_scale_y(s, e, aargs[1]);
		}
		if (cmd == "s" || cmd == "sprite") _typed_animated_text.animated_text.text.set_default_sprite(s, aargs[0]);
	}
}
