moby_dick = "<float>Call me Ishmael.<><n> <n>Some <scale:4>years<> ag<p:1000>o-never mind <s:spr_button fade>$<>how long precisely-<f:fnt_handwriting>having little or no money in my purse<>, and nothing particular to interest me on shore, <t:16.7,1>I thought I would sail about a little and see the watery part of the world.<> <chromatic>It is a way I have of driving off the spleen and regulating the circulation. <>Whenever I find myself growing grim about the mouth; whenever it is a damp, drizzly <blue>November<> in my soul; whenever I find myself involuntarily pausing before coffin warehouses, <risein>and bringing up the rear of every funeral I meet; and especially whenever my hypos get such an upper hand of me, that it requires a strong moral principle to prevent me from deliberately stepping into the street, and methodically knocking people's hats off-then, I account it high time to get to sea as soon as I can.<> <tremble>This is my substitute for pistol and ball.<> With a philosophical flourish Cato throws himself upon his sword; I quietly take to the ship. There is nothing surprising in this. If they but knew it, almost all men in their degree, some time or other, cherish very nearly the same feelings towards the <aqua>ocean<> with me.";
test = new TagDecoratedTextDefault(moby_dick, "scale:2 cp:.,800 cp:!,800 cp:,,500", 200, 200);
tag_decorated_text_set_typing_params(test, 100, 3);

tag_decorated_text_set_on_type_callback(test, function() {
	audio_stop_sound(snd_chirp);
	audio_play_sound(snd_chirp, 0, false);
});

tag_decorated_text_set_character_on_type_callback(test, 30, function() {
	show_debug_message("Character at index 30 typed!");
});

test.styleable_text.debug = true;
