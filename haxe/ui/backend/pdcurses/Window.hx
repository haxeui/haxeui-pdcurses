package haxe.ui.backend.pdcurses;
import haxe.ui.backend.pdcurses.DrawParams.BorderType;
import haxe.ui.backend.pdcurses.lib.PDCurses;
import haxe.ui.components.Label;
import haxe.ui.containers.ListView;
import haxe.ui.containers.ScrollView;
import haxe.ui.core.Component;
import haxe.ui.core.MouseEvent;
import haxe.ui.util.Rectangle;

@:access(haxe.ui.backend.ComponentBase)
class Window {
    public var children:Array<Window> = [];
    public var parent:Window = null;
    
    public var backgroundColor:Int = -1;
    public var color:Int = 0;
    public var shadow:Bool = false;
    
    private var _c:Component;
    
    public var hidden:Bool = false;
    
    public function new(c:Component) {
        _c = c;
    }
 
    public function addChild(win:Window) {
        win.parent = this;
        children.push(win);
    }

    private var _x:Int = 0;
    public var x(get, set):Int;
    private function get_x():Int {
        return _x;
    }
    private function set_x(value:Int):Int {
        return _x = value;
    }
    
    private var _y:Int = 0;
    public var y(get, set):Int;
    private function get_y():Int {
        return _y;
    }
    private function set_y(value:Int):Int {
        return _y = value;
    }
    
    public function move(x:Int, y:Int) {
        _x = x;
        _y = y;
    }
    
    private var _w:Int = 0;
    private var _h:Int = 0;
    public function resize(w:Int, h:Int) {
        _w = w;
        _h = h;
    }
    
    public var screenX(get, null):Int;
    private function get_screenX():Int {
        var sx = _x;
        var p = parent;
        while (p != null) {
            sx += p._x;
            p = p.parent;
        }
        return sx;
    }
    
    public var screenY(get, null):Int;
    private function get_screenY():Int {
        var sy = _y;
        var p = parent;
        while (p != null) {
            sy += p._y;
            p = p.parent;
        }
        return sy;
    }
    
    public function findWindowsUnderPoint(x:Int, y:Int):Array<Window> {
        var arr = [];
        
        if (x >= screenX && y >= screenY && x < screenX + _w && y < screenY + _h) {
            arr.push(this);
            for (c in children) {
                arr = arr.concat(c.findWindowsUnderPoint(x, y));
            }
        }
        
        return arr;
    }
    
    public function mouseOver(x:Int, y:Int) {
        if (_c._eventMap.exists(MouseEvent.MOUSE_OVER)) {
            var fn = _c._eventMap.get(MouseEvent.MOUSE_OVER);
            var mouseEvent:MouseEvent = new MouseEvent(MouseEvent.MOUSE_OVER);
            mouseEvent.screenX = x;
            mouseEvent.screenY = y;
            fn(mouseEvent);
        }
    }
    
    public function mouseOut(x:Int, y:Int) {
        if (_c._eventMap.exists(MouseEvent.MOUSE_OUT)) {
            var fn = _c._eventMap.get(MouseEvent.MOUSE_OUT);
            var mouseEvent:MouseEvent = new MouseEvent(MouseEvent.MOUSE_OUT);
            mouseEvent.screenX = x;
            mouseEvent.screenY = y;
            fn(mouseEvent);
        }
    }
    
    public function mouseDown(x:Int, y:Int) {
        if (_c._eventMap.exists(MouseEvent.MOUSE_DOWN)) {
            var fn = _c._eventMap.get(MouseEvent.MOUSE_DOWN);
            var mouseEvent:MouseEvent = new MouseEvent(MouseEvent.MOUSE_DOWN);
            mouseEvent.screenX = x;
            mouseEvent.screenY = y;
            fn(mouseEvent);
        }
    }
    
    public function click(x:Int, y:Int) {
        if (_c._eventMap.exists(MouseEvent.CLICK)) {
            var fn = _c._eventMap.get(MouseEvent.CLICK);
            var mouseEvent:MouseEvent = new MouseEvent(MouseEvent.CLICK);
            mouseEvent.screenX = x;
            mouseEvent.screenY = y;
            fn(mouseEvent);
        }
    }
    
    public function mouseUp(x:Int, y:Int) {
        if (_c._eventMap.exists(MouseEvent.MOUSE_UP)) {
            var fn = _c._eventMap.get(MouseEvent.MOUSE_UP);
            var mouseEvent:MouseEvent = new MouseEvent(MouseEvent.MOUSE_UP);
            mouseEvent.screenX = x;
            mouseEvent.screenY = y;
            fn(mouseEvent);
        }
    }
    
    private function findParentBackgroundColor() {
        var c = backgroundColor;
        var p = parent;
        while (p != null) {
            if (p.backgroundColor != -1) {
                c = p.backgroundColor;
                break;
            }
            p = p.parent;
        }
        return c;
    }
    
    @:access(haxe.ui.backend.TextDisplayBase)
    public function redraw(clipRect:Rectangle = null) {
        if (_w <= 0 || _h <= 0 || hidden == true) {
            return;
        }
        
        var clipRect:Rectangle = clipRect;
        if (_c != null && _c._clipRect != null) {
            clipRect = new Rectangle(screenX + _c._clipRect.left, screenY + _c._clipRect.top, _c._clipRect.width, _c._clipRect.height);
        }
        
        var xpos = screenX;
        var ypos = screenY;
        
        if (backgroundColor != -1) {
            var drawParams = new DrawParams();
            drawParams.shadow = false;
            drawParams.color = ColorHelper.getColor(backgroundColor, backgroundColor);
            
            if (_c.style.backgroundImage != null) {
                drawParams.backgroundChar = getAscii(_c.style.backgroundImage);
            }
            
            
            if (_c.style.borderLeftSize != null) {
                drawParams.color = ColorHelper.getColor(ColorHelper.approximateColor(_c.style.borderLeftColor), backgroundColor);
                drawParams.borderType = BorderType.THIN;
            } else if (_c.style.color != null) {
                drawParams.color = ColorHelper.getColor(ColorHelper.approximateColor(_c.style.color), backgroundColor);
            }
            
            DrawHelper.box(xpos, ypos, _w, _h, drawParams, clipRect);
        }
        

        if (_c != null && _c.hasTextDisplay()) {
            var text = _c.getTextDisplay()._text;
            
            var textBackgroundColor = backgroundColor;
            if (Std.is(_c, Label) && _c.parentComponent != null && backgroundColor == -1) {
                textBackgroundColor = findParentBackgroundColor();
            }
            
            var cx:Int = xpos + Std.int(_c.getTextDisplay()._left);
            var cy:Int = ypos + Std.int(_c.getTextDisplay()._top);
            var textColor:Int = ColorHelper.approximateColor(_c.getTextDisplay().textStyle.color);
            
            PDCurses.attrset(PDCurses.COLOR_PAIR(ColorHelper.getColor(textColor, textBackgroundColor)));
            
            text = text.toUpperCase();
            for (xx in 0...text.length) {
                var s = text.charAt(xx);
                
                var draw = true;
                if (clipRect != null && !clipRect.containsPoint(cx + xx, cy)) {
                    draw = false;
                }
                
                if (draw == true) {
                    PDCurses.mvaddstr(cy, cx + xx, s); 
                }
            }
            
            
        }
        
        if (_c != null && _c.style != null) {
            if (_c.style.icon != null) {
                
                var textBackgroundColor = ColorHelper.approximateColor(_c.style.backgroundColor);
                var textColor:Int = ColorHelper.approximateColor(_c.style.color);
                var cx:Int = xpos;
                var cy:Int = ypos;
                if (_c.style.borderLeftSize != null) {
                    cx++;
                    cy++;
                }
                var icon = getAscii(_c.style.icon);
                //var textColor:Int = ColorHelper.approximateColor(_c.getTextDisplay().textStyle.color);
                PDCurses.attrset(PDCurses.COLOR_PAIR(ColorHelper.getColor(textColor, textBackgroundColor)));
                PDCurses.mvaddch(cy, cx, icon); 
            }
        }
        
        for (c in children) {
            c.redraw(clipRect);
        }
    }
    
    private function getAscii(s:String):Int {
        var n = 0;
        if (StringTools.startsWith(s, "ascii:")) {
            s = StringTools.replace(s, "ascii:", "");
            n = DrawHelper.getAscii(s);
        }
        return n;
    }
}