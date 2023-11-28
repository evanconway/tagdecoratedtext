//test = setup_test_text();

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text(0, 0, fps_real);

if (keyboard_check_pressed(vk_right)) new_text_page_next(test);
if (keyboard_check_pressed(vk_left)) new_text_page_previous(test);

new_text_draw(600, 400, other_test);

draw_set_halign(fa_right);
//draw_set_valign(fa_middle);
new_text_draw(200, 250, test);
