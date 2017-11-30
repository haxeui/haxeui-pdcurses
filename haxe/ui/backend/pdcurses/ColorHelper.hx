package haxe.ui.backend.pdcurses;
import haxe.ui.backend.pdcurses.lib.PDCurses;

class ColorHelper {
    private static var _start:Int = 16;
    
    private static var _cols:Map<String, Int> = new Map<String, Int>();
    
    public static function getColor(fg:Int, bg:Int):Int {
        var i:String = fg + "|" +  bg;
        
        var c = 0;
        if (_cols.exists(i)) {
            c = _cols.get(i);
        } else {
            PDCurses.init_pair(_start, fg, bg);
            _cols.set(i, _start);
            c = _start;
            _start++;
        }
        
        return c;
    }
    
    public static function approximateColor(i:Int):Int {
        var n = Color.WHITE;
        switch (i) {
            case 0x000000:      n = Color.BLACK;
            case 0x880000:      n = Color.RED;
            case 0xFF0000:      n = Color.BRIGHT_RED;
            case 0x000088:      n = Color.BLUE;
            case 0x0000FF:      n = Color.BRIGHT_BLUE;
            case 0x008800:      n = Color.GREEN;
            case 0x00FF00:      n = Color.BRIGHT_GREEN;
            case 0x888888:      n = Color.GREY;
            case 0xC0C0C0:      n = Color.WHITE;
            case 0xFFFFFF:      n = Color.BRIGHT_WHITE;
        }
        return n;
    }
    
}
