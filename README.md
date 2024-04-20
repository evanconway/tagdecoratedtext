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

Updates and draws the given TagDecoratedText instance.

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

Resets typing state of given tag_decorated_text instance. TagDecoratedText instances are "typed" by default. This function must be called before typing update will have any effect.

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



`tag_decorated_text_update`

Updates the given TagDecoratedText instance by the given time in ms. If no time is specified the TagDecoratedText instance is updated by time in ms of 1 frame of the current game speed.

_Full function name:_  `tag_decorated_text_update(tag_decorated_text, [update_time_ms])`
 
_Returns:_  NA(`undefined`)

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| tag_decorated_text | Struct.TagDecoratedText | TagDecoratedText instance to advance typing state of. |
| update_time_ms | Real | Amount of time in milliseconds to update animations and typing state by. |
---

`tag_decorated_text_draw_no_update`

Draws the given TagDecoratedText instance without updating it.

_Full function name:_  `tag_decorated_text_draw_no_update(tag_decorated_text, x, y)`
 
_Returns:_  NA(`undefined`)

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| tag_decorated_text | Struct.TagDecoratedText | TagDecoratedText instance to draw. |
| x | Real | X position to draw text. |
| y | Real | Y position to draw text. |
---

`tag_decorated_text_reset_animations`

Resets the state of all animations of the given TagDecoratedText instance.

_Full function name:_  `tag_decorated_text_reset_animations(tag_decorated_text)`
 
_Returns:_  NA(`undefined`)

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| tag_decorated_text | Struct.TagDecoratedText | TagDecoratedText instance to reset animation state of. |
---

`tag_decorated_text_type_current_page`

Sets the typing state of the current page to finished.

_Full function name:_  `tag_decorated_text_type_current_page(tag_decorated_text)`
 
_Returns:_  NA(`undefined`)

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| tag_decorated_text | Struct.TagDecoratedText | TagDecoratedText instance to set typing state of. |
---

`tag_decorated_text_get_current_page_typing_finished`

Indicates if the current page is finished typing.

_Full function name:_  `tag_decorated_text_get_current_page_typing_finished(tag_decorated_text)`
 
_Returns:_  (`Bool`)

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| tag_decorated_text | Struct.TagDecoratedText | TagDecoratedText instance to get typing state of. |
---

`tag_decorated_text_type_all_pages`

Sets the typing state of all pages to finished.

_Full function name:_  `tag_decorated_text_type_all_pages(tag_decorated_text)`
 
_Returns:_  NA(`undefined`)

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| tag_decorated_text | Struct.TagDecoratedText | TagDecoratedText instance to set typing state of. |
---

`tag_decorated_text_get_typing_finished`

Returns true if typing is completely finished for all pages.

_Full function name:_  `tag_decorated_text_get_typing_finished(tag_decorated_text)`
 
_Returns:_  (`Bool`)

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| tag_decorated_text | Struct.TagDecoratedText | TagDecoratedText instance to get typing state of. |
---

`tag_decorated_text_page_next`

Go to the next page.

_Full function name:_  `tag_decorated_text_page_next(tag_decorated_text)`
 
_Returns:_  NA(`undefined`)

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| tag_decorated_text | Struct.TagDecoratedText | TagDecoratedText instance to go to next page of. |
---

`tag_decorated_text_page_previous`

Go to the previous page.

_Full function name:_  `tag_decorated_text_page_previous(tag_decorated_text)`
 
_Returns:_  NA(`undefined`)

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| tag_decorated_text | Struct.TagDecoratedText | TagDecoratedText instance to go to previous page of. |
---

`tag_decorated_text_get_page_count`

Get the number of pages.

_Full function name:_  `tag_decorated_text_get_page_count(tag_decorated_text)`
 
_Returns:_  (`Real`)

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| tag_decorated_text | Struct.TagDecoratedText | TagDecoratedText instance to get page count of. |
---

`tag_decorated_text_get_current_page_index`

Get the index of the current page.

_Full function name:_  `tag_decorated_text_get_current_page_index(tag_decorated_text)`
 
_Returns:_  (`Real`)

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| tag_decorated_text | Struct.TagDecoratedText | TagDecoratedText instance to get page index of. |
---

`tag_decorated_text_get_width`

Returns the width of the given TagDecoratedText instance.

_Full function name:_  `tag_decorated_text_get_width(tag_decorated_text)`
 
_Returns:_  (`Real`)

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| tag_decorated_text | Struct.TagDecoratedText | TagDecoratedText instance to get width of. |
---

`tag_decorated_text_get_height`

Returns the height of the given TagDecoratedText instance.

_Full function name:_  `tag_decorated_text_get_height(tag_decorated_text)`
 
_Returns:_  (`Real`)

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| tag_decorated_text | Struct.TagDecoratedText | TagDecoratedText instance to get height of. |
---

`tag_decorated_text_set_on_type_callback`

Set the callback function that's invoked whenever a type event occurs.

_Full function name:_  `tag_decorated_text_set_on_type_callback(tag_decorated_text, on_type_callback)`
 
_Returns:_  NA(`undefined`)

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| tag_decorated_text | Struct.TagDecoratedText | TagDecoratedText instance to set on type callback of. |
| on_type_callback | Function | Callback function invoked on character type. |
---

`tag_decorated_text_set_character_on_type_callback`

Set the callback function that's invoked whenever a type event occurs for a specific character.

_Full function name:_  `tag_decorated_text_set_character_on_type_callback(tag_decorated_text, character_index, on_type_callback)`

_Returns:_  NA(`undefined`)

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| tag_decorated_text | Struct.TagDecoratedText | TagDecoratedText instance to set character on type callback of. |
| character_index | Real | Index of character to receive on type callback. |
| on_type_callback | Function | Callback function invoked on character type. |
---

`tag_decorated_text_set_typing_params`

Set the time between types and characters per type.

_Full function name:_  `tag_decorated_text_set_typing_params(tag_decorated_text, time_between_types_ms, chars_per_type)`

_Returns:_  NA(`undefined`)

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| tag_decorated_text | Struct.TagDecoratedText | TagDecoratedText instance to set typing params of. |
| time_between_types_ms | Real | Time in milliseconds between type events. |
| chars_per_type | Real | Number of characters typed per type event. |
---
