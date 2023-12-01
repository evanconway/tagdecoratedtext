moby_dick = "Call me Ishmael. Some years ago-never mind how long precisely-having little or no money in my purse, and nothing particular to interest me on shore, I thought I would sail about a little and see the watery part of the world. It is a way I have of driving off the spleen and regulating the circulation. Whenever I find myself growing grim about the mouth; whenever it is a damp, drizzly November in my soul; whenever I find myself involuntarily pausing before coffin warehouses, and bringing up the rear of every funeral I meet; and especially whenever my hypos get such an upper hand of me, that it requires a strong moral principle to prevent me from deliberately stepping into the street, and methodically knocking people's hats off-then, I account it high time to get to sea as soon as I can. This is my substitute for pistol and ball. With a philosophical flourish Cato throws himself upon his sword; I quietly take to the ship. There is nothing surprising in this. If they but knew it, almost all men in their degree, some time or other, cherish very nearly the same feelings towards the ocean with me.";

setup_test_text = function() {
	var result = new New_StyleableText(moby_dick, 200, 200);
	
	result.set_character_font(20, 60, fnt_handwriting);
	result.set_character_color(30, 40, c_red);
	result.set_character_alpha(75, 105, 0.3);
	result.set_character_offset_x(115, 125, 7);
	result.set_character_offset_y(130, 145, -7);
	result.set_character_scale_x(165, 175, 4);
	result.set_character_scale_y(185, 195, 4);
	result.set_character_new_line(153, true);
	result.set_character_sprite(211, spr_button);
	
	result.set_character_color(500, 500, c_yellow);
	
	result.build();
	return result;
};

test = setup_test_text();

other_test = new New_StyleableText("The quick brown fox jumps over the lazy dog.");
other_test.build();

animation_test = new StyleableTextAnimator(test);

animation_test.add_animation(ANIMATED_TEXT_ANIMATIONS.FADE, 34, 60, []);
animation_test.add_animation(ANIMATED_TEXT_ANIMATIONS.SHAKE, 70, 80, []);
animation_test.add_animation(ANIMATED_TEXT_ANIMATIONS.TREMBLE, 90, 100, []);
animation_test.add_animation(ANIMATED_TEXT_ANIMATIONS.CHROMATIC, 110, 120, []);
animation_test.add_animation(ANIMATED_TEXT_ANIMATIONS.WCHROMATIC, 130, 140, []);
animation_test.add_animation(ANIMATED_TEXT_ANIMATIONS.WAVE, 150, 160, []);
animation_test.add_animation(ANIMATED_TEXT_ANIMATIONS.FLOAT, 170, 180, []);
animation_test.add_animation(ANIMATED_TEXT_ANIMATIONS.BLINK, 190, 200, []);
animation_test.add_animation(ANIMATED_TEXT_ANIMATIONS.TWITCH, 210, 300, []);


typer = new StyleableTextTyper(test, animation_test);

for (var i = 0; i < 1000; i++) {
	typer.add_type_animation_at(i, ANIMATED_TEXT_ANIMATIONS.FADEIN, []);
	typer.add_type_animation_at(i, ANIMATED_TEXT_ANIMATIONS.RISEIN, []);
}

typer.on_type = function() {
	audio_stop_sound(snd_chirp);
	audio_play_sound(snd_chirp, 0, false);
};

typer.set_character_index_pause(500, 2000);

typer.set_character_index_on_type(200, function() {
	show_debug_message("Character 200 just got typed!");
});

tag = new NewTagDecoratedText("The <tremble>quick<> <pink>brown<> <orange>fox<> <wave>jumps<> over the <fade>lazy<> <red>dog<>.", "twitch");
