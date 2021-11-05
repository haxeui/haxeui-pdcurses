package haxe.ui.backend.pdcurses;

import cpp.Int16;
import cpp.RawPointer;
import haxe.ui.backend.pdcurses.lib.WINDOW;
import haxe.ui.geom.Rectangle;
import haxe.ui.backend.pdcurses.lib.Curses.*;

typedef CharInfo = {
    @:optional public var char:Null<Int>;
    @:optional public var fg:Null<Int>;
    @:optional public var bg:Null<Int>;
}

@:headerInclude("curses.h")
class Window {
    public var nativeWindow:RawPointer<WINDOW>;
    public var clipRect:Rectangle = null;
    
    public function new() {
    }
    
    public function drawString(s:String, x:Int, y:Int, w:Int = -1, h:Int = -1, fg:Int = -1, bg:Int = -1, align:String = "left") {
        fg = Color.approximateColor(fg, fg);
        bg = Color.approximateColor(bg, bg);
        
        if (w == -1) {
            w = s.length;
        }
        if (h == -1) {
            h = 1;
        }
        
        var textOffset:Int = 0;
        switch (align) {
            case "center":
                textOffset = Std.int((w / 2) - (s.length / 2));
            case "right":
                textOffset = w - s.length;
        }
        
        for (tx in 0...s.length) {
            if (clipRect != null && clipRect.containsPoint(textOffset + x + tx, y) == false) {
                continue;
            }
            
            var i = info(textOffset + x + tx, y);
            if (bg == -1) {
                bg = i.bg;
            }
            
            Color.set(nativeWindow, fg, bg);
            mvwaddstr(nativeWindow, y, textOffset + x + tx, s.charAt(tx));
        }
    }
    
    public function drawRectangle(x:Int, y:Int, w:Int, h:Int, fg:Int = -1, bg:Int = -1, char:Int = -1) {
        fg = Color.approximateColor(fg, fg);
        bg = Color.approximateColor(bg, bg);
        
        for (yy in 0...h) {
            for (xx in 0...w) {
                if (clipRect != null && clipRect.containsPoint(x + xx, y + yy) == false) {
                    continue;
                }
                
                var i = info(x + xx, y + yy);
                var f = fg;
                var b = bg;
                var c = char;
                
                if (f == -1) {
                    f = i.fg;
                }
                if (b == -1) {
                    b = i.bg;
                }
                
                Color.set(nativeWindow, f, b);
                mvwaddch(nativeWindow, y + yy, x + xx, c);
            }
        }
    }
    
    public function drawVLine(x:Int, y:Int, h:Int, fg:Int = -1, bg:Int = -1, char:Int = -1) {
        fg = Color.approximateColor(fg, fg);
        bg = Color.approximateColor(bg, bg);
        
        for (yy in 0...h) {
            if (clipRect != null && clipRect.containsPoint(x, y + yy) == false) {
                continue;
            }
            
            var i = info(x, y + yy);
            var f = fg;
            var b = bg;
            var c = char;
            
            if (f == -1) {
                f = i.fg;
            }
            if (b == -1) {
                b = i.bg;
            }
            
            Color.set(nativeWindow, f, b);
            mvwaddch(nativeWindow, y + yy, x, c);
        }
    }
    
    public function drawHLine(x:Int, y:Int, w:Int, fg:Int = -1, bg:Int = -1, char:Int = -1) {
        fg = Color.approximateColor(fg, fg);
        bg = Color.approximateColor(bg, bg);
        
        for (xx in 0...w) {
            if (clipRect != null && clipRect.containsPoint(x + xx, y) == false) {
                continue;
            }
            
            var i = info(x + xx, y);
            var f = fg;
            var b = bg;
            var c = char;
            var fgOnlyLookup = (i.char == Chars.HALF_BLOCK_BOTTOM || i.char == Chars.HALF_BLOCK_TOP || i.char == Chars.BLOCK);
            
            if (f == -1) {
                f = i.fg;
            }
            if (b == -1 && fgOnlyLookup == false) {
                b = i.bg;
            } else if (b == -1 && fgOnlyLookup == true) {
                b = i.fg;
            }
            
            Color.set(nativeWindow, f, b);
            mvwaddch(nativeWindow, y, x + xx, c);
        }
    }
    
    public function drawChar(x:Int, y:Int, fg:Int = -1, bg:Int = -1, char:Int = -1, approximate:Bool = true) {
        if (clipRect != null && clipRect.containsPoint(x, y) == false) {
            return;
        }
        
        var i = info(x, y);
        if (approximate == true) {
            fg = Color.approximateColor(fg, fg);
            bg = Color.approximateColor(bg, bg);
        }
        var fgOnlyLookup = (i.char == Chars.HALF_BLOCK_BOTTOM || i.char == Chars.HALF_BLOCK_TOP || i.char == Chars.BLOCK);
        
        if (fg == -1) {
            fg = i.fg;
        }
        if (bg == -1 && fgOnlyLookup == false) {
            bg = i.bg;
        } else if (bg == -1 && fgOnlyLookup == true) {
            bg = i.fg;
        }
        Color.set(nativeWindow, fg, bg);
        mvwaddch(nativeWindow, y, x, char);
    }
    
    public function foregroundColor(x:Int, y:Int):Int {
        var cc = mvwinch(nativeWindow, y, x);
        var n = PAIR_NUMBER(cc);
        var fg:Int16 = 0, bg:Int16 = 0;
        pair_content(n, RawPointer.addressOf(fg), RawPointer.addressOf(bg));
        
        return fg;
    }
    
    public function backgroundColor(x:Int, y:Int):Int {
        var cc = mvwinch(nativeWindow, y, x);
        var n = PAIR_NUMBER(cc);
        var fg:Int16 = 0, bg:Int16 = 0;
        pair_content(n, RawPointer.addressOf(fg), RawPointer.addressOf(bg));
        
        return bg;
    }
    
    public function charAt(x:Int, y:Int):Int {
        var cc = mvwinch(nativeWindow, y, x);
        var char = cc & A_CHARTEXT;
        var attr = cc & A_ATTRIBUTES;
        
        if (attr & A_ALTCHARSET == A_ALTCHARSET) {
            char |= A_ALTCHARSET;
        }
        return char;
    }
    
    public function info(x:Int, y:Int):CharInfo {
        var cc = mvwinch(nativeWindow, y, x);
        var char = cc & A_CHARTEXT;
        var attr = cc & A_ATTRIBUTES;
        
        if (attr & A_ALTCHARSET == A_ALTCHARSET) {
            char |= A_ALTCHARSET;
        }
        
        var n = PAIR_NUMBER(cc);
        var fg:Int16 = 0, bg:Int16 = 0;
        pair_content(n, RawPointer.addressOf(fg), RawPointer.addressOf(bg));
        
        return { char: char, fg: fg, bg: bg };
    }
}