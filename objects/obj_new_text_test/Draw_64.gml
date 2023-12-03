draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
draw_set_color(c_white);
draw_text(0, 0, fps_real);
draw_text(0, 16, $"page {tag_decorated_text_get_current_page_index(test) + 1} of {tag_decorated_text_get_page_count(test)}");

if (keyboard_check_pressed(vk_right)) tag_decorated_text_page_next(test);
if (keyboard_check_pressed(vk_left)) tag_decorated_text_page_previous(test);
if (keyboard_check_pressed(vk_space)) tag_decorated_text_advance(test);
if (keyboard_check_pressed(ord("A"))) tag_decorated_text_reset_typing(test);
if (keyboard_check_pressed(ord("R"))) tag_decorated_text_reset_typing(test);
if (keyboard_check_pressed(ord("T"))) tag_decorated_text_type_current_page(test);
if (keyboard_check_pressed(vk_enter)) tag_decorated_text_type_all_pages(test);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

tag_decorated_text_draw(test, display_get_gui_width() / 2, display_get_gui_height() / 2);

draw_set_valign(fa_top);
draw_set_halign(fa_left);

tag_decorated_text_draw(fox, 100, 100);
