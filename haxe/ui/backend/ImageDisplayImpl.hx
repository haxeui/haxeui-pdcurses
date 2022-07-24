package haxe.ui.backend;

import haxe.ui.backend.pdcurses.Window;

class ImageDisplayImpl extends ImageBase {
    public function print(window:Window, x:Int, y:Int, fg:Int, bg:Int) {
        var data = _imageInfo.data;
        
        var n = 0;
        for (yy in 0...data.height) {
            for (xx in 0...data.width) {
                var f = fg;
                var b = bg;
                
                var px:Int = Std.int(x + xx + _left);
                var py:Int = Std.int(y + yy + _top);
                var c = data.data[n];
                if (c != -1) {
                    f = c;
                    b = c;
                }
                var ch = data.char;
                window.drawChar(px, py, f, b, ch, false);
                n++;
            }
        }
    }
}
