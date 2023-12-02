//test = setup_test_text();

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
draw_set_color(c_white);
draw_text(0, 0, fps_real);

if (keyboard_check_pressed(vk_right)) test.styleable_text.page_next();
if (keyboard_check_pressed(vk_left)) test.styleable_text.page_previous();

if (keyboard_check_pressed(ord("A"))) {
	tag_reset_animations(test);
}

if (keyboard_check_pressed(ord("R"))) {
	tag_reset_typing(test);
}

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

tag_draw(test, 200, 200);
