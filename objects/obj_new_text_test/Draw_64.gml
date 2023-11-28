draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text(0, 0, fps_real);

if (keyboard_check_pressed(vk_right)) new_text_page_next(test);
if (keyboard_check_pressed(vk_left)) new_text_page_previous(test);

draw_set_halign(fa_center);
new_text_draw(100, 100, test);

draw_set_halign(fa_left);
new_text_draw(400, 100, other_test);
