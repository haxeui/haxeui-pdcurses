package haxe.ui.backend.pdcurses;
import haxe.ui.backend.pdcurses.Chars;
import haxe.ui.backend.pdcurses.Window;
import haxe.ui.core.Component;
import haxe.ui.filters.DropShadow;
import haxe.ui.filters.Filter;
import haxe.ui.geom.Rectangle;
import haxe.ui.styles.Style;

class StyleHelper {
    public static function drawStyle(window:Window, bounds:Rectangle, style:Style, component:Component) {
        var backgroundForeColor:Int = -1;
        var backgroundChar:Int = Chars.BLOCK;
        if (style.backgroundColor != null) {
            backgroundForeColor = style.backgroundColor;
        }
        var backgroundBackColor = backgroundForeColor;
        if (style.backgroundImage != null) {
            backgroundChar = Image.charFromString(style.backgroundImage);
            backgroundBackColor = -1;
            if (style.color != null) {
                backgroundForeColor = style.color;
                if (style.backgroundColor != null) {
                    backgroundBackColor = style.backgroundColor;
                }
            }
        }

        var borderStyle = style.borderStyle;
        var borderLeftColor = -1;
        var borderTopColor = -1;
        var borderRightColor = -1;
        var borderBottomColor = -1;
        if (style.borderLeftSize > 0) {
            borderLeftColor = style.borderLeftColor;
        }
        if (style.borderTopSize > 0) {
            borderTopColor = style.borderTopColor;
        }
        if (style.borderRightSize > 0) {
            borderRightColor = style.borderRightColor;
        }
        if (style.borderBottomSize > 0) {
            borderBottomColor = style.borderBottomColor;
        }
        
        var x:Int = Std.int(bounds.left);
        var y:Int = Std.int(bounds.top);
        var w:Int = Std.int(bounds.width);
        var h:Int = Std.int(bounds.height);
        
        var xm = 0;
        var ym = 0;
        var wm = 0;
        var hm = 0;
        if (borderStyle != "square-brackets" && borderStyle != "round-brackets") {
            if (borderLeftColor != -1) {
                xm += 1;
                wm += 1;
            }
            if (borderRightColor != -1) {
                wm += 1;
            }
            if (borderTopColor != -1) {
                ym += 1;
                hm += 1;
            }
            if (borderBottomColor != -1) {
                hm += 1;
            }
        }
        
        // background-color
        if (backgroundForeColor != -1) {
            window.drawRectangle(x + xm, y + ym, w - wm, h - hm, backgroundForeColor, backgroundBackColor, backgroundChar);
        }
        
        // border
        if (borderTopColor != -1 || borderLeftColor != -1 || borderBottomColor != -1 || borderRightColor != -1) {
            drawBorder(window, borderStyle, x, y, w, h, backgroundForeColor, borderTopColor, borderLeftColor, borderBottomColor, borderRightColor, style);
        }
        
        // shadow
        if (style.filter != null && style.filter.length > 0) {
            for (f in style.filter) {
                drawFilter(window, f, borderBottomColor, x, y, w, h);
            }
        }
    }
    
    private static function drawFilter(window:Window, filter:Filter, borderCol:Int, x:Int, y:Int, w:Int, h:Int) {
        if ((filter is DropShadow)) {
            drawDropShadow(window, cast filter, borderCol, x, y, w, h);
        }
    }
    
    private static function drawDropShadow(window:Window, dropShadow:DropShadow, borderCol:Int, x:Int, y:Int, w:Int, h:Int) {
        if (dropShadow.distance <= 0) {
            return;
        }
        
        var xoffset = 1;
        if (dropShadow.angle == 90) {
            xoffset = 0;
        }
        
        if (dropShadow.distance == .5) {
            var shadowCol = dropShadow.color;
            window.drawHLine(x + xoffset, y + h - 1, w - xoffset, shadowCol, borderCol, Chars.HALF_BLOCK_BOTTOM);
            window.drawVLine(x + w, y + 1, h - 1, shadowCol, shadowCol, Chars.BLOCK);
        } else {
            var shadowCol = dropShadow.color;
            window.drawHLine(x + xoffset, y + h, w - xoffset, shadowCol, borderCol, Chars.BLOCK);
            window.drawVLine(x + w, y + 1, h - 0, shadowCol, shadowCol, Chars.BLOCK);
        }
    }
    
    private static function drawBorder(window:Window, borderStyle:String, x:Int, y:Int, w:Int, h:Int, backgroundColor:Int, borderTopColor:Int, borderLeftColor:Int, borderBottomColor:Int, borderRightColor:Int, style:Style) {
        var hasFilter = (style.filter != null && style.filter.length > 0);
        
        if (borderStyle == "square-brackets") {
            window.drawChar(x, y, borderLeftColor, -1, 91);
            window.drawChar(x + w - 1, y, borderLeftColor, -1, 93);
            return;
        }
        if (borderStyle == "round-brackets") {
            window.drawChar(x, y, borderLeftColor, -1, 40);
            window.drawChar(x + w - 1, y, borderLeftColor, -1, 41);
            return;
        }
        if (borderStyle == "tableview") {
            var borderChars = BorderTypes.get("thin");
            // t
            window.drawHLine(x + 1, y, w - 2, borderTopColor, (borderChars.useBackgroundColor ? backgroundColor : -1), borderChars.t);
            
            var borderChars = BorderTypes.get("single");
            // l
            window.drawVLine(x, y + 1, h - 2, borderLeftColor, (borderChars.useBackgroundColor ? backgroundColor : -1), borderChars.l);
            // r
            window.drawVLine(x + w - 1, y + 1, h - 2, borderRightColor, (borderChars.useBackgroundColor ? backgroundColor : -1), borderChars.r);
            // b
            window.drawHLine(x + 1, y + h - 1, w - 2, borderBottomColor, (borderChars.useBackgroundColor ? backgroundColor : -1), borderChars.b);
            
            // tl
            window.drawChar(x, y, oneOf(borderLeftColor, borderTopColor), (borderChars.useBackgroundColor ? backgroundColor : -1), borderChars.tl);
            // tr
            window.drawChar(x + w - 1, y, oneOf(borderTopColor, borderRightColor), (borderChars.useBackgroundColor ? backgroundColor : -1), borderChars.tr);
            // bl
            window.drawChar(x, y + h - 1, oneOf(borderBottomColor, borderLeftColor), (borderChars.useBackgroundColor ? backgroundColor : -1), borderChars.bl);
            // br
            window.drawChar(x + w - 1, y + h - 1, oneOf(borderBottomColor, borderRightColor), (borderChars.useBackgroundColor ? backgroundColor : -1), borderChars.br);
            return;
        }
        
        var borderChars = BorderTypes.get(borderStyle);
        if (borderChars != null) {
            // top border
            if (borderTopColor != -1) {
                window.drawHLine(x + 1, y, w - 2, borderTopColor, (borderChars.useBackgroundColor ? backgroundColor : -1), borderChars.t);
            }
            // left border
            if (borderLeftColor != -1) {
                window.drawVLine(x, y + 1, h - 2, borderLeftColor, (borderChars.useBackgroundColor ? backgroundColor : -1), borderChars.l);
            }
            // bottom border
            if (borderBottomColor != -1) {
                window.drawHLine(x + 1, y + h - 1, w - 2, borderBottomColor, (borderChars.useBackgroundColor ? backgroundColor : -1), borderChars.b);
            }
            // right border
            if (borderRightColor != -1) {
                window.drawVLine(x + w - 1, y + 1, h - 2, borderRightColor, (borderChars.useBackgroundColor ? backgroundColor : -1), borderChars.r);
            }
            
            // top left corner
            var topLeftChar = -1;
            if (borderLeftColor != -1 && borderTopColor != -1) {
                topLeftChar = borderChars.tl;
            } else if (borderLeftColor != -1) {
                topLeftChar = borderChars.l;
            } else if (borderTopColor != -1) {
                topLeftChar = borderChars.t;
            }
            if (topLeftChar != -1) {
                window.drawChar(x, y, oneOf(borderLeftColor, borderTopColor), (borderChars.useBackgroundColor ? backgroundColor : -1), topLeftChar);
            }
            
            // top right corner
            var topRightChar = -1;
            if (borderTopColor != -1 && borderRightColor != -1) {
                topRightChar = borderChars.tr;
            } else if (borderTopColor != -1) {
                topRightChar = borderChars.t;
            } else if (borderRightColor != -1) {
                topRightChar = borderChars.r;
            }
            if (topRightChar != -1) {
                window.drawChar(x + w - 1, y, oneOf(borderTopColor, borderRightColor), (borderChars.useBackgroundColor ? backgroundColor : -1), topRightChar);
            }
            
            // bottom left corner
            var bottomLeftChar = -1;
            if (borderLeftColor != -1 && borderBottomColor != -1) {
                bottomLeftChar = borderChars.bl;
            } else if (borderLeftColor != -1) {
                bottomLeftChar = borderChars.l;
            } else if (borderBottomColor != -1) {
                bottomLeftChar = borderChars.b;
            }
            if (hasFilter == true && borderStyle == "solid") {
                bottomLeftChar = 223;
            }
            if (bottomLeftChar != -1) {
                window.drawChar(x, y + h - 1, oneOf(borderBottomColor, borderLeftColor), (borderChars.useBackgroundColor ? backgroundColor : -1), bottomLeftChar);
            }
            
            // bottom right corner
            var bottomRightChar = -1;
            if (borderBottomColor != -1 && borderRightColor != -1) {
                bottomRightChar = borderChars.br;
            } else if (borderBottomColor != -1) {
                bottomRightChar = borderChars.b;
            } else if (borderRightColor != -1) {
                bottomRightChar = borderChars.r;
            }
            if (bottomRightChar != -1) {
                window.drawChar(x + w - 1, y + h - 1, oneOf(borderBottomColor, borderRightColor), (borderChars.useBackgroundColor ? backgroundColor : -1), bottomRightChar);
            }
        }
    }
    
    private static inline function oneOf(n1:Int, n2:Int):Int {
        return n1 > -1 ? n1 : n2;
    }
}