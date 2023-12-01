//test = setup_test_text();

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
draw_set_color(c_white);
draw_text(0, 0, fps_real);

if (keyboard_check_pressed(vk_right)) test.page_next();
if (keyboard_check_pressed(vk_left)) test.page_previous();

if (keyboard_check_pressed(vk_space)) typer.reset_typing();

//if (keyboard_check_pressed(vk_space)) {
//	animation_test.add_animation(ANIMATED_TEXT_ANIMATIONS.FADEIN, 0, 0, []);
//	animation_test.add_animation(ANIMATED_TEXT_ANIMATIONS.RISEIN, 0, 0, []);
//}

//if (keyboard_check_pressed(ord("R"))) {
//	animation_test.add_animation(ANIMATED_TEXT_ANIMATIONS.RISEIN, 5, 7, []);
//}
/*
text_set_color(test, 250, 400, c_aqua);
text_apply_alpha(test, 300, 330, 0.1);
text_set_font(test, 340, 368, fnt_handwriting);
text_apply_scale_x(test, 410, 420, 2);
text_apply_scale_y(test, 425, 435, 2);
text_add_offset_x(test, 440, 450, 7);
text_add_offset_y(test, 455, 465, 7);
text_set_sprite(test, 470, spr_button);
*/
animation_test.update();
typer.update();

new_text_draw(600, 400, other_test);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
new_text_draw(200, 250, test);
