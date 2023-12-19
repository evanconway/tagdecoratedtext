# TagDecoratedText
A GameMaker package to easily create stylized, animated text.

```
// create event
test = new TagDecoratedText("The <shake>quick<> brown <orange>fox<> <y:-6>jumps<> over the <red wave>lazy<> dog.");

// draw gui event
tag_decorated_text_draw(test, 0, 0);
```


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

Tag Decorated Text 
