package haxe.ui.backend.pdcurses;

import haxe.ui.backend.pdcurses.DrawParams.BorderEffect;
import haxe.ui.backend.pdcurses.DrawParams.BorderType;
import haxe.ui.backend.pdcurses.lib.PDCurses;
import haxe.ui.util.Rectangle;

class CornerChars {
    public var TOP_LEFT:Int = 218;
    public var TOP:Int = 196;
    public var TOP_RIGHT:Int = 191;
    
    public var LEFT:Int = 179;
//    public var MIDDLE:Int = 219;
    public var MIDDLE:Int = 32;
    public var RIGHT:Int = 179;
    
    public var BOTTOM_LEFT:Int = 192;
    public var BOTTOM:Int = 196;
    public var BOTTOM_RIGHT:Int = 217;
    
    public function new() {
    }
}

class DrawHelper {
    public static function box(x:Int, y:Int, w:Int, h:Int, drawParams:DrawParams, clip:Rectangle) {
        if (drawParams == null) {
            drawParams = new DrawParams();
        }
        
        var corners = cornerChars(drawParams.borderType);
        
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
                corners.TOP_LEFT = 219;
                corners.TOP = 219;
                corners.TOP_RIGHT = 219;
                corners.LEFT = 219;
                corners.MIDDLE = 219;
                corners.RIGHT = 219;
                corners.BOTTOM_LEFT = 219;
                corners.BOTTOM = 219;
                corners.BOTTOM_RIGHT = 219;
                
            case BorderType.THIN:
                corners.TOP_LEFT = 218;
                corners.TOP = 196;
                corners.TOP_RIGHT = 191;
                corners.LEFT = 179;
                corners.MIDDLE = 32;
                corners.RIGHT = 179;
                corners.BOTTOM_LEFT = 192;
                corners.BOTTOM = 196;
                corners.BOTTOM_RIGHT = 217;
                
            case BorderType.DOUBLE:
                corners.TOP_LEFT = 201;
                corners.TOP = 205;
                corners.TOP_RIGHT = 187;
                corners.LEFT = 186;
                corners.MIDDLE = 32;
                corners.RIGHT = 186;
                corners.BOTTOM_LEFT = 200;
                corners.BOTTOM = 205;
                corners.BOTTOM_RIGHT = 188;
                
            case BorderType.THICK:
                corners.TOP_LEFT = 219;
                corners.TOP = 219;
                corners.TOP_RIGHT = 219;
                corners.LEFT = 219;
                corners.MIDDLE = 32;
                corners.RIGHT = 219;
                corners.BOTTOM_LEFT = 219;
                corners.BOTTOM = 219;
                corners.BOTTOM_RIGHT = 219;
        }
        
        return corners;
    }
}