draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_font(fnt_styleable_text_font_default);
var height = string_height("A");
draw_text(0, 0, fps_real);
draw_text(0, height, $"page {tag_decorated_text_get_current_page_index(test) + 1} of {tag_decorated_text_get_page_count(test)}");
draw_text(0, height * 2, $"typing finished: {tag_decorated_text_get_typing_finished(test)}");
draw_text(0, height * 3, $"dimensions: {tag_decorated_text_get_width(test)}x{tag_decorated_text_get_height(test)}");
draw_text(0, height * 4, $"page finished?: {tag_decorated_text_get_current_page_typing_finished(test)}");

if (keyboard_check_pressed(vk_right)) tag_decorated_text_page_next(test);
if (keyboard_check_pressed(vk_left)) tag_decorated_text_page_previous(test);
if (keyboard_check_pressed(vk_space)) tag_decorated_text_advance(test);
if (keyboard_check_pressed(ord("A"))) {
	tag_decorated_text_reset_typing(test);
	tag_decorated_text_reset_animations(test);
}
if (keyboard_check_pressed(ord("R"))) tag_decorated_text_reset_typing(test);
if (keyboard_check_pressed(ord("T"))) tag_decorated_text_type_current_page(test);
if (keyboard_check_pressed(vk_enter)) tag_decorated_text_type_all_pages(test);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

tag_decorated_text_draw(test, display_get_gui_width() / 2, display_get_gui_height() / 2);

draw_set_valign(fa_top);
draw_set_halign(fa_left);

//tag_decorated_text_draw(fox, 100, 100);
