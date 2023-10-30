if (keyboard_check_pressed(ord("R"))) tag_decorated_text_reset(test);
if (keyboard_check_pressed(vk_space)) tag_decorated_text_advance(test);
if (keyboard_check_pressed(ord("U"))) updating = !updating;
if (keyboard_check_pressed(vk_left)) tag_decorated_text_page_previous(test);
if (keyboard_check_pressed(vk_right)) tag_decorated_text_page_next(test);

if (updating) tag_decorated_text_update(test);
tag_decorated_text_draw_no_update(test, 40, 40);
tag_decorated_text_draw_performance(0, 0);
