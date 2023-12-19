# TagDecoratedText
A GameMaker package to easily create stylized, animated text.

```
// create event
test = new TagDecoratedText("The <shake>quick<> brown <orange>fox<> <y:-6>jumps<> over the <red wave>lazy<> dog.");

// draw gui event
tag_decorated_text_draw(test, 0, 0);
```

![Example 1](https://github.com/evanconway/tagdecoratedtext/blob/main/example%20gifs/example1.gif)

With typing

```
// create event
test = new TagDecoratedTextDefault("The <shake>quick<> brown <orange>fox<> <y:-6>jumps<> over the <red wave>lazy<> dog.", "t:60,1");

// draw gui event
if (keyboard_check_pressed(ord("R"))) tag_decorated_text_reset_typing(test);
tag_decorated_text_draw(test, 0, 0);
```

![Example 1](https://github.com/evanconway/tagdecoratedtext/blob/main/example%20gifs/example_typing1.gif)


## Core Functions

`TagDecoratedText`
 
Create a new **TagDecoratedText** instance.

_Full function name:_  `TagDecoratedText(source_string, [width], [height])`
 
_Returns:_  `Struct.TagDecoratedText`

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| source_string | String | String with decorative tags. |
| width | Real | Maximum width of the text. |
| height | Real | Maximum height of the text. |
---

`TagDecoratedTextDefault`

Create a new **TagDecoratedText** instance with default effects applied to entire text.

_Full function name:_  `TagDecoratedTextDefault(source_string, default_effects, [width], [height])`
 
_Returns:_  `Struct.TagDecoratedText`

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| source_string | String | String with decorative tags. |
| default_effects | String | Default effects. |
| width | Real | Maximum width of the text. |
| height | Real | Maximum height of the text. |
---

`tag_decorated_text_draw`

Updates and draws the given tag decorated text instance.

_Full function name:_  `tag_decorated_text_draw(tag_decorated_text, x, y, [update_time_ms])`
 
_Returns:_  NA(`undefined`)

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| tag_decorated_text | Struct.TagDecoratedText | TagDecoratedText instance to draw. |
| x | Real | X position to draw text. |
| y | Real | Y position to draw text. |
| update_time_ms | Real | Amount of time in milliseconds to update animations and typing state. |
---

`tag_decorated_text_reset_typing`

Resets typing state of given tag_decorated_text instance. Tag decorated text instances are "typed" by default. This function must be called before typing update will have any effect.

_Full function name:_  `tag_decorated_text_reset_typing(tag_decorated_text)`
 
_Returns:_  NA(`undefined`)

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| tag_decorated_text | Struct.TagDecoratedText | TagDecoratedText instance to reset typing state of. |
---

`tag_decorated_text_advance`

Advances typing state in a logical way. If the current page is not typed, current page typing state is set to finished. If current page is typed, text is advanced to the next page.

_Full function name:_  `tag_decorated_text_advance(tag_decorated_text)`
 
_Returns:_  NA(`undefined`)

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| tag_decorated_text | Struct.TagDecoratedText | TagDecoratedText instance to advance typing state of. |
---





/**
 * Updates the given tag decorated text instance by the given time in ms. If no time is specified
 * the tag decorated text instance is updated by time in ms of 1 frame of the current game speed.
 *
 * @param {Struct.New_Tag} tag_decorated_text
 * @param {real} update_time_ms
 */
function tag_decorated_text_update(tag_decorated_text, update_time_ms = 1000 / game_get_speed(gamespeed_fps)) {
	with (tag_decorated_text) {
		typer.update(update_time_ms);
		animator.update(update_time_ms);
		animations_updated = true;
	}
}

/**
 * Draws the given tag decorated text instance without updating it.
 *
 * @param {Struct.New_Tag} tag_decorated_text
 * @param {real} x
 * @param {real} y
 * @param {Constant.HAlign} alignment
 */
function tag_decorated_text_draw_no_update(tag_decorated_text, x, y) {
	with (tag_decorated_text) {
		if (!animations_updated) animator.update(0);
		styleable_text.draw(x, y);
		animations_updated = false;
	}
}

/**
 * Resets the state of all animations of the given tag decorated text instance.
 *
 * @param {Struct.New_Tag} tag_decorated_text
 */
function tag_decorated_text_reset_animations(tag_decorated_text) {
	tag_decorated_text.animator.reset();
}

/**
 * Sets the typing state of the current page to finished.
 *
 * @param {Struct.New_Tag} tag_decorated_text
 */
function tag_decorated_text_type_current_page(tag_decorated_text) {
	tag_decorated_text.typer.finish_typing_current_page();
}

/**
 * Indicates if the current page is finished typing.
 */
function tag_decorated_text_get_current_page_typing_finished(tag_decorated_text) {
	return tag_decorated_text.typer.get_current_page_finished();
}

/**
 * Sets the typing state of all pages to finished.
 *
 * @param {Struct.New_Tag} tag_decorated_text
 */
function tag_decorated_text_type_all_pages(tag_decorated_text) {
	tag_decorated_text.typer.finish_typing_all_pages();
}

/**
 * Returns true if typing is completely finished for all pages.
 */
function tag_decorated_text_get_typing_finished(tag_decorated_text) {
	with (tag_decorated_text) {
		return typer.get_all_pages_finished() && styleable_text.text_page_index == styleable_text.text_page_index_max;
	}
}

/**
 * Go to the next page.
 *
 * @param {Struct.New_Tag} tag_decorated_text
 */
function tag_decorated_text_page_next(tag_decorated_text) {
	tag_decorated_text.styleable_text.page_next();
}

/**
 * Go to the previous page.
 *
 * @param {Struct.New_Tag} tag_decorated_text
 */
function tag_decorated_text_page_previous(tag_decorated_text) {
	tag_decorated_text.styleable_text.page_previous();
}

/**
 * Get the number of pages.
 *
 * @param {Struct.New_Tag} tag_decorated_text
 */
function tag_decorated_text_get_page_count(tag_decorated_text) {
	return tag_decorated_text.styleable_text.text_page_index_max + 1;
}

/**
 * Get the index of the current page.
 *
 * @param {Struct.New_Tag} tag_decorated_text
 */
function tag_decorated_text_get_current_page_index(tag_decorated_text) {
	return tag_decorated_text.styleable_text.text_page_index;
}

/**
 * Returns the width of the given tag decorated text instance.
 *
 * @param {Struct.TagDecoratedText} tag_decorated_text
 */
function tag_decorated_text_get_width(tag_decorated_text) {
	return tag_decorated_text.styleable_text.get_width();
}

/**
 * Returns the height of the given tag decorated text instance.
 *
 * @param {Struct.TagDecoratedText} tag_decorated_text
 */
function tag_decorated_text_get_height(tag_decorated_text) {
	return tag_decorated_text.styleable_text.get_height();
}

/**
 * Set the callback function that's invoked whenever a type event occurs.
 *
 * @param {Struct.TagDecoratedText} tag_decorated_text
 * @param {function} on_type_callback
 */
function tag_decorated_text_set_on_type_callback(tag_decorated_text, on_type_callback) {
	tag_decorated_text.typer.on_type = on_type_callback;
}

/**
 * Set the callback function that's invoked whenever a type event occurs
 * for a specific character.
 *
 * @param {Struct.TagDecoratedText} tag_decorated_text
 * @param {real} character_index
 * @param {function} on_type_callback
 */
function tag_decorated_text_set_character_on_type_callback(tag_decorated_text, character_index, on_type_callback) {
	tag_decorated_text.typer.set_character_index_on_type(character_index, on_type_callback);
}

/**
 * Set the time between types and characters per type.
 *
 * @param {Struct.New_tag} tag_decorated_text
 * @param {real} time_between_types_ms
 * @param {real} chars_per_type
 */
function tag_decorated_text_set_typing_params(tag_decorated_text, time_between_types_ms, chars_per_type) {
	with (tag_decorated_text) {
		tag_decorated_text.typer.set_character_indexes_typing_params(0, styleable_text.character_array_length - 1, time_between_types_ms, chars_per_type);
	}
}
