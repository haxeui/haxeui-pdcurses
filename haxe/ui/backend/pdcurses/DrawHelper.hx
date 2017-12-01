package haxe.ui.backend.pdcurses;

import haxe.ui.backend.pdcurses.DrawParams.BorderEffect;
import haxe.ui.backend.pdcurses.DrawParams.BorderType;
import haxe.ui.backend.pdcurses.lib.Chars;
import haxe.ui.backend.pdcurses.lib.PDCurses;
import haxe.ui.util.Rectangle;

class CornerChars {
    public var TOP_LEFT:Int = Chars.ULCORNER;
    public var TOP:Int = Chars.HLINE;
    public var TOP_RIGHT:Int = Chars.URCORNER;
    
    public var LEFT:Int = Chars.VLINE;
//    public var MIDDLE:Int = 219;
    public var MIDDLE:Int = ' '.charCodeAt(0);
    public var RIGHT:Int = Chars.VLINE;
    
    public var BOTTOM_LEFT:Int = Chars.LLCORNER;
    public var BOTTOM:Int = Chars.HLINE;
    public var BOTTOM_RIGHT:Int = Chars.LRCORNER;
    
    public function new() {
    }
}

class DrawHelper {
    public static function box(x:Int, y:Int, w:Int, h:Int, drawParams:DrawParams, clip:Rectangle) {
        if (drawParams == null) {
            drawParams = new DrawParams();
        }
        
        var corners = cornerChars(drawParams.borderType);
        
        if (drawParams.backgroundChar != null) {
            corners.MIDDLE = drawParams.backgroundChar;
            if (drawParams.borderType == BorderType.NONE) {
                corners.TOP_LEFT = corners.MIDDLE;
                corners.TOP = corners.MIDDLE;
                corners.TOP_RIGHT = corners.MIDDLE;
                corners.LEFT = corners.MIDDLE;
                corners.RIGHT = corners.MIDDLE;
                corners.BOTTOM_LEFT = corners.MIDDLE;
                corners.BOTTOM = corners.MIDDLE;
                corners.BOTTOM_RIGHT = corners.MIDDLE;
            }
        }
        
        if (drawParams.borderEffect == BorderEffect.NONE) {
            PDCurses.attrset(PDCurses.COLOR_PAIR(drawParams.color));
        }
        
        for (yy in 0...h) {
            for (xx in 0...w) {
                var ch = corners.MIDDLE;
                
                if (yy == 0 && xx == 0) {
                    ch = corners.TOP_LEFT;
                } else if (yy == 0 && xx == w - 1) {
                    ch = corners.TOP_RIGHT;
                } else if (yy == 0) {
                    ch = corners.TOP;
                } else if (xx == 0 && yy == h - 1) {
                    ch = corners.BOTTOM_LEFT;
                } else if (xx == w - 1 && yy == h - 1) {
                    ch = corners.BOTTOM_RIGHT;
                } else if (yy == h - 1) {
                    ch = corners.BOTTOM;
                } else if (xx == 0) {
                    ch = corners.LEFT;
                } else if (xx == w - 1) {
                    ch = corners.RIGHT;
                }
                
                var draw = true;
                
                if (clip != null && !clip.containsPoint(x + xx, y + yy)) {
                    draw = false;
                }
                
                if (draw == true) {
                    PDCurses.mvaddch(y + yy, x + xx, ch);
                }
            }
        }
        
        if (drawParams.shadow == true) {
            PDCurses.attrset(PDCurses.COLOR_PAIR(drawParams.shadowColor));
            for (yy in 1...h) {
                PDCurses.mvaddch(y + yy, x + w, 219);
            }
            for (xx in 1...w + 1) {
                PDCurses.mvaddch(y + h, x + xx, 219);
            }
        }
    }
    
    public static function cornerChars(borderType:BorderType):CornerChars {
        var corners = new CornerChars();
        
        switch(borderType) {
            case BorderType.NONE:
                corners.TOP_LEFT = Chars.BLOCK;
                corners.TOP = Chars.BLOCK;
                corners.TOP_RIGHT = Chars.BLOCK;
                corners.LEFT = Chars.BLOCK;
                corners.MIDDLE = Chars.BLOCK;
                corners.RIGHT = Chars.BLOCK;
                corners.BOTTOM_LEFT = Chars.BLOCK;
                corners.BOTTOM = Chars.BLOCK;
                corners.BOTTOM_RIGHT = Chars.BLOCK;
               
            case BorderType.THIN:
                corners.TOP_LEFT = Chars.ULCORNER;
                corners.TOP = Chars.HLINE;
                corners.TOP_RIGHT = Chars.URCORNER;
                corners.LEFT = Chars.VLINE;
                corners.MIDDLE = ' '.charCodeAt(0);
                corners.RIGHT = Chars.VLINE;
                corners.BOTTOM_LEFT = Chars.LLCORNER;
                corners.BOTTOM = Chars.HLINE;
                corners.BOTTOM_RIGHT = Chars.LRCORNER;
                
            case BorderType.THICK:
                corners.TOP_LEFT = Chars.BLOCK;
                corners.TOP = Chars.BLOCK;
                corners.TOP_RIGHT = Chars.BLOCK;
                corners.LEFT = Chars.BLOCK;
                corners.MIDDLE = ' '.charCodeAt(0);
                corners.RIGHT = Chars.BLOCK;
                corners.BOTTOM_LEFT = Chars.BLOCK;
                corners.BOTTOM =Chars.BLOCK;
                corners.BOTTOM_RIGHT = Chars.BLOCK;
        }
        
        return corners;
    }
    
    public static function getAscii(s:String) {
        switch (s.toUpperCase()) {
            case "VLINE":           return Chars.VLINE;
            case "HLINE":           return Chars.HLINE;
            case "ULCORNER":        return Chars.ULCORNER;
            case "LLCORNER":        return Chars.LLCORNER;
            case "URCORNER":        return Chars.URCORNER;
            case "LRCORNER":        return Chars.LRCORNER;
            case "RTEE":            return Chars.RTEE;
            case "LTEE":            return Chars.LTEE;
            case "BTEE":            return Chars.BTEE;
            case "TTEE":            return Chars.TTEE;
            case "PLUS":            return Chars.PLUS;
            case "LARROW":          return Chars.LARROW;
            case "RARROW":          return Chars.RARROW;
            case "DARROW":          return Chars.DARROW;
            case "UARROW":          return Chars.UARROW;
            case "BLOCK":           return Chars.BLOCK;
            case "BOARD":           return Chars.BOARD;
            case "CKBOARD":         return Chars.CKBOARD;
            case "DIAMOND":         return Chars.DIAMOND;
            case "LANTERN":         return Chars.LANTERN;
        }
        return s.charCodeAt(0);
    }
}