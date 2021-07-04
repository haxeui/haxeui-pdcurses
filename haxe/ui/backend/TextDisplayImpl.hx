package haxe.ui.backend;
import haxe.ui.backend.pdcurses.Window;
import haxe.ui.components.Button;
import haxe.ui.geom.Rectangle;

class TextDisplayImpl extends TextBase {
    private var _color:Int;
    private var _textAlign:String;
    
    private override function validateData() {
        #if haxeui_pdcurses_uppercase_strings
        _text = _text.toUpperCase();
        #end
    }
    
    private override function validateStyle():Bool {
        if (_textStyle != null) {
            if (_textAlign != _textStyle.textAlign) {
                _textAlign = _textStyle.textAlign;
            }
            if (_color != _textStyle.color) {
                _color = _textStyle.color;
            }
        }
        return true;
    }
    
    public function print(window:Window, x:Int, y:Int) {
        if (_lines != null) {
            var ty:Int = Std.int(y + _top);
            for (line in _lines) {
                var tx:Int = x;
                var lx:Int = line.length;
                
                switch(_textAlign) {
                    case "center":
                        tx += Std.int((_width - lx) / 2);

                    case "right":
                        tx += Std.int(_width - lx);

                    default:
                        tx += Std.int(_left);
                }
                
                window.drawString(line, tx, ty, -1, -1, _color);
                ty += 1;
            }
        }
    }
    
    
    private var _lines:Array<String>;
    private override function measureText() {
        if (_text == null || _text.length == 0 ) {
            _textWidth = 0;
            _textHeight = 0;
            return;
        }

        if (_width <= 0) {
            _lines = new Array<String>();
            _lines.push(_text);
            _textWidth = _text.length;
            _textHeight = 1;
            return;
        }


        var maxWidth:Float = _width;
        _lines = new Array<String>();
        _text = normalizeText(_text);
        var lines = _text.split("\n");
        var biggestWidth:Float = 0;
        for (line in lines) {
            var tw = line.length;
            if (tw > maxWidth) {
                var words = Lambda.list(line.split(" "));
                while (!words.isEmpty()) {
                    line = words.pop();
                    tw = line.length;
                    biggestWidth = Math.max(biggestWidth, tw);
                    var nextWord = words.pop();
                    while (nextWord != null && (tw = (line + " " + nextWord).length) <= maxWidth) {
                        biggestWidth = Math.max(biggestWidth, tw);
                        line += " " + nextWord;
                        nextWord = words.pop();
                    }
                    _lines.push(line);
                    if (nextWord != null) {
                        words.push(nextWord);
                    }
                }
            } else {
                biggestWidth = Math.max(biggestWidth, tw);
                if (line != '') {
                    _lines.push(line);
                }
            }
        }

        _textWidth = biggestWidth;
        _textHeight = _lines.length;
    }
    
    private function normalizeText(text:String):String {
        text = StringTools.replace(text, "\\n", "\n");
        return text;
    }
}
