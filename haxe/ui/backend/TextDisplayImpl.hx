package haxe.ui.backend;

import haxe.ui.assets.FontInfo;
import haxe.ui.core.Component;
import haxe.ui.styles.Style;

class TextDisplayImpl extends TextBase {
    private override function measureText() {
        if (_text != null) {
            _textWidth = _text.length;
            _textHeight = 1;
        }
    }
}
