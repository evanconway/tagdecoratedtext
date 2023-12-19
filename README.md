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
