package haxe.ui.backend.pdcurses;

import cpp.Int16;
import cpp.RawPointer;
import haxe.ui.backend.pdcurses.lib.Curses.*;
import haxe.ui.backend.pdcurses.lib.WINDOW;
import haxe.ui.styles.Value;

@:headerInclude("curses.h")
class Color {
    public static inline var BLACK:Int = 0;
    public static inline var BLUE:Int = 1;
    public static inline var GREEN:Int = 2;
    public static inline var RED:Int = 4;

    public static inline var CYAN:Int = BLUE | GREEN;
    public static inline var MAGENTA:Int = RED | BLUE;
    public static inline var YELLOW:Int = RED | GREEN;
    public static inline var WHITE:Int = RED | GREEN | BLUE;
    
    public static inline var GREY:Int = 8;
    public static inline var BRIGHT_BLUE:Int = 9;
    public static inline var BRIGHT_GREEN:Int = 10;
    public static inline var BRIGHT_RED:Int = 12;
    
    public static inline var BRIGHT_CYAN:Int = BRIGHT_BLUE | BRIGHT_GREEN;
    public static inline var BRIGHT_MAGENTA:Int = BRIGHT_RED | BRIGHT_BLUE;
    public static inline var BRIGHT_YELLOW:Int = BRIGHT_RED | BRIGHT_GREEN;
    public static inline var BRIGHT_WHITE:Int = BRIGHT_RED | BRIGHT_GREEN | BRIGHT_BLUE;
    
    private static var _start:Int = 16;
    
    private static var _cols:Map<String, Int> = new Map<String, Int>();
    
    private static var DEFAULT_HI_COL:Int = BRIGHT_WHITE;
    private static var _HI_COL:Int = -1;
    public static var HI_COL(get, null):Int;
    private static function get_HI_COL():Int {
        if (_HI_COL != -1) {
            return _HI_COL;
        }
        
        var n = getStyleColor(".hi");
        if (n != -1) {
            _HI_COL = approximateColor(n);
        } else {
            return DEFAULT_HI_COL;
        }
        return _HI_COL;
    }

    private static var DEFAULT_MID_COL:Int = WHITE;
    private static var _MID_COL:Int = -1;
    public static var MID_COL(get, null):Int;
    private static function get_MID_COL():Int {
        if (_MID_COL != -1) {
            return _MID_COL;
        }
        
        var n = getStyleColor(".mid");
        if (n != -1) {
            _MID_COL = approximateColor(n);
        } else {
            return DEFAULT_MID_COL;
        }
        return _MID_COL;
    }
    
    private static var DEFAULT_LO_COL:Int = BLACK;
    private static var _LO_COL:Int = -1;
    public static var LO_COL(get, null):Int;
    private static function get_LO_COL():Int {
        if (_LO_COL != -1) {
            return _LO_COL;
        }
        
        var n = getStyleColor(".lo");
        if (n != -1) {
            _LO_COL = approximateColor(n);
        } else {
            return DEFAULT_LO_COL;
        }
        return _LO_COL;
    }
    
    private static function getStyleColor(selector:String, name:String = "color"):Int {
        var n = -1;
        var el = Toolkit.styleSheet.findRule(selector);
        if (el != null) {
            var d = el.directives.get(name);
            if (d != null) {
                switch (d.value) {
                    case Value.VColor(v):
                        n = v;
                    default:    
                }
            }
        }
        return n;
    }
    
    public static function find(fg:Int, bg:Int):Int {
        var i:String = fg + "|" +  bg;
        
        var c = 0;
        if (_cols.exists(i)) {
            c = _cols.get(i);
        } else {
            init_pair(_start, fg, bg);
            _cols.set(i, _start);
            c = _start;
            _start++;
        }
        
        return c;
    }
    
    public static function set(w:RawPointer<WINDOW>, fg:Int, bg:Int) {
        var col = find(fg, bg);
        wattrset(w, COLOR_PAIR(col));
    }
    
    public static function getForegroud(w:RawPointer<WINDOW>, x:Int, y:Int):Int {
        var cc = mvwinch(w, y, x);
        var n = PAIR_NUMBER(cc);
        var fg:Int16 = 0, bg:Int16 = 0;
        pair_content(n, RawPointer.addressOf(fg), RawPointer.addressOf(bg));
        
        return fg;
    }
    
    public static function getBackground(w:RawPointer<WINDOW>, x:Int, y:Int):Int {
        var cc = mvwinch(w, y, x);
        var n = PAIR_NUMBER(cc);
        var fg:Int16 = 0, bg:Int16 = 0;
        pair_content(n, RawPointer.addressOf(fg), RawPointer.addressOf(bg));
        
        return bg;
    }
    
    public static function approximateColor(i:Int, defaultColor:Int = Color.WHITE):Int {
        var n = defaultColor;
        switch (i) {
            case 0x000000:  n = Color.BLACK;
            case 0x880000:  n = Color.RED;
            case 0x800000:  n = Color.RED;
            case 0x008800:  n = Color.GREEN;
            case 0x008000:  n = Color.GREEN;
            case 0x888800:  n = Color.YELLOW;
            case 0x808000:  n = Color.YELLOW;
            case 0x000088:  n = Color.BLUE;
            case 0x000080:  n = Color.BLUE;
            case 0x880088:  n = Color.MAGENTA;
            case 0x800080:  n = Color.MAGENTA;
            case 0x008888:  n = Color.CYAN;
            case 0x008080:  n = Color.CYAN;
            case 0xC0C0C0:  n = Color.WHITE;
            
            case 0x888888:  n = Color.GREY;
            case 0x808080:  n = Color.GREY;
            case 0xFF0000:  n = Color.BRIGHT_RED;
            case 0x00FF00:  n = Color.BRIGHT_GREEN;
            case 0xFFFF00:  n = Color.BRIGHT_YELLOW;
            case 0x0000FF:  n = Color.BRIGHT_BLUE;
            case 0xFF00FF:  n = Color.BRIGHT_MAGENTA;
            case 0x00FFFF:  n = Color.BRIGHT_CYAN;
            case 0xFFFFFF:  n = Color.BRIGHT_WHITE;
        }
        return n;
    }
    
    public static function brighten(i:Int):Int {
        var n = i;
        switch (i) {
            case Color.BLACK:   n = Color.WHITE;
            case Color.BLUE:    n = Color.BRIGHT_BLUE;
            case Color.GREEN:   n = Color.BRIGHT_GREEN;
            case Color.RED:     n = Color.BRIGHT_RED;
            case Color.CYAN:    n = Color.BRIGHT_CYAN;
            case Color.MAGENTA: n = Color.BRIGHT_MAGENTA;
            case Color.YELLOW:  n = Color.BRIGHT_YELLOW;
            case Color.GREY:    n = Color.BRIGHT_WHITE;
        }
        return n;
    }
    
    public static function darken(i:Int):Int {
        var n = i;
        switch (i) {
            case Color.WHITE:           n = Color.GREY;
            case Color.GREY:            n = Color.BLACK;
            case Color.BRIGHT_BLUE:     n = Color.BLUE;
            case Color.BRIGHT_GREEN:    n = Color.GREEN;
            case Color.BRIGHT_RED:      n = Color.RED;
            case Color.BRIGHT_CYAN:     n = Color.CYAN;
            case Color.BRIGHT_MAGENTA:  n = Color.MAGENTA;
            case Color.BRIGHT_YELLOW:   n = Color.YELLOW;
            case Color.BRIGHT_WHITE:    n = Color.WHITE;
        }
        return n;
    }
    
    public static function greyscale(i:Int):Int {
        var n = i;
        switch (i) {
            case Color.BLUE: n = Color.WHITE;
            case Color.GREEN: n = Color.WHITE;
            case Color.RED: n = Color.WHITE;
            case Color.BLACK: n = Color.GREY;
            case Color.BRIGHT_BLUE: n = Color.WHITE;
            //case Color.BRIGHT_WHITE: n = Color.WHITE;
        }
        return n;
    }
    
    public static inline function fromRGB(r:Int, g:Int, b:Int):Int {
        return  ((r << 16) | (g << 8) | b);
    }
    
    public static inline function getR(c:Int):Int {
        return (c >> 16) & 0xFF;
    }
    
    public static inline function getG(c:Int):Int {
        return (c >> 8) & 0xFF;
    }
    
    public static inline function getB(c:Int):Int {
        return c & 0xFF;
    }
    
    private static var COLOR_LIST:Array<Int> = [
        0x000000,
        0x800000,
        0x008000,
        0x808000,
        0x000080,
        0x800080,
        0x008080,
        0xc0c0c0,
        0x808080,
        0xff0000,
        0x00ff00,
        0xffff00,
        0x0000ff,
        0xff00ff,
        0x00ffff,
        0xffffff
    ];

    private static function colorDiff(r1:Int, g1:Int, b1:Int, r2:Int, g2:Int, b2:Int) {
        var drp2 = Math.pow(r1 - r2, 2);
        var dgp2 = Math.pow(g1 - g2, 2);
        var dbp2 = Math.pow(b1 - b2, 2);
        
        var t = (r1 + r2) / 2;
        
        return Math.sqrt(2 * drp2 + 4 * dgp2 + 3 * dbp2 + t * (drp2 - dbp2) / 256);
    }

    public static function toANSI(r:Int, g:Int, b:Int):Int {
        var smallestDelta:Float = 0xffffff;
        var n = -1;
        var i = 0;
        for (c in COLOR_LIST) {
            var tb = getR(c);
            var tg = getG(c);
            var tr = getB(c);
            
            var delta = colorDiff(r, g, b, tr, tg, tb);
            //var delta = deltaE(rgb2lab(r, g, b), rgb2lab(tr, tg, tb));// colorDiff(r, g, b, tr, tg, tb);
            if (delta < smallestDelta) {
                smallestDelta = delta;
                n = i;
            }
            
            i++;
        }

        return n;
    }
}