moby_dick = "Call me Ishmael. Some years ago-never mind how long precisely-having little or no money in my purse, and nothing particular to interest me on shore, I thought I would sail about a little and see the watery part of the world. It is a way I have of driving off the spleen and regulating the circulation. Whenever I find myself growing grim about the mouth; whenever it is a damp, drizzly November in my soul; whenever I find myself involuntarily pausing before coffin warehouses, and bringing up the rear of every funeral I meet; and especially whenever my hypos get such an upper hand of me, that it requires a strong moral principle to prevent me from deliberately stepping into the street, and methodically knocking people's hats off-then, I account it high time to get to sea as soon as I can. This is my substitute for pistol and ball. With a philosophical flourish Cato throws himself upon his sword; I quietly take to the ship. There is nothing surprising in this. If they but knew it, almost all men in their degree, some time or other, cherish very nearly the same feelings towards the ocean with me.";

test = new New_StyleableText(moby_dick, 200, 200);

text_set_default_font(test, 20, 60, fnt_handwriting);
text_set_default_color(test, 30, 40, c_red);
text_set_default_alpha(test, 75, 105, 0.3);
text_set_default_offset_x(test, 115, 125, 7);
text_set_default_offset_y(test, 130, 145, -7);
text_set_default_scale_x(test, 165, 175, 4);
text_set_default_scale_y(test, 185, 195, 4);
text_set_default_new_line(test, 153, true);
text_set_default_sprite(test, 211, spr_button);

other_test = new New_StyleableText("The quick brown fox jumps over the lazy dog.");
