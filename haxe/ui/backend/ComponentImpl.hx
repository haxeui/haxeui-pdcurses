package haxe.ui.backend;

import cpp.RawPointer;
import haxe.ui.backend.pdcurses.Color;
import haxe.ui.backend.pdcurses.Mouse;
import haxe.ui.backend.pdcurses.StyleHelper;
import haxe.ui.backend.pdcurses.Window;
import haxe.ui.backend.pdcurses.lib.Curses.*;
import haxe.ui.backend.pdcurses.lib.WINDOW;
import haxe.ui.core.Component;
import haxe.ui.events.MouseEvent;
import haxe.ui.events.UIEvent;
import haxe.ui.geom.Rectangle;

@:headerCode('
#include "curses.h"
#define CURSES_KEY_DOWN 0x102
#define CURSES_KEY_UP 0x103
#undef KEY_DOWN
#undef KEY_UP

#define CURSES_OK 0
#undef OK
')

class ComponentImpl extends ComponentBase {
    private var _eventMap:Map<String, UIEvent->Void>;
    
    public function new() {
        super();
        _eventMap = new Map<String, UIEvent->Void>();
        recursiveReady();
    }
    
    private function recursiveReady() {
        var component:Component = cast(this, Component);
        component.ready();
        for (child in component.childComponents) {
            child.recursiveReady();
        }
    }
    
    public function printTo(nativeWindow:RawPointer<WINDOW>) {
        if (width <= 0 || height <= 0 || cast(this, Component).hidden == true) {
            return;
        }
        
        var sx = Math.round(screenLeft);
        var sy = Math.round(screenTop);
        var w = Math.round(width);
        var h = Math.round(height);
        
        var bounds = new Rectangle(sx, sy, w, h);
        var style = this.style;
        var clipComponent = findClipComponent();
        var clipRect:Rectangle = null;
        if (clipComponent != null) {
            clipRect = clipComponent.componentClipRect.copy();
            clipRect.left += clipComponent.screenLeft;
            clipRect.top += clipComponent.screenTop;
            clipRect.width -= 1;
            if (clipRect.intersects(bounds) == false) {
                return;
            }
        }
        
        var window = new Window();
        window.nativeWindow = nativeWindow;
        window.clipRect = clipRect;
        
        if (style.backdropFilter != null) {
            for (y in sy...h) {
                for (x in sx...w) {
                    var info = window.info(x, y);
                    window.drawChar(x, y, Color.darken(info.fg), Color.darken(info.bg), info.char, false);
                    window.drawChar(x, y, Color.greyscale(info.fg), Color.greyscale(info.bg), info.char, false);
                }
            }
        }
        
        StyleHelper.drawStyle(window, bounds, style, cast this);
        
        if (_textDisplay != null) {
            _textDisplay.print(window, sx, sy);
        }
        
        if (_textInput != null) {
            _textInput.print(window, sx, sy);
        }
        
        if (_imageDisplay != null) {
            var fg = Color.approximateColor(style.color);
            var bg = Color.approximateColor(style.backgroundColor);
            if (style.backgroundColor == null) {
                bg = Color.getBackground(nativeWindow, Std.int(_imageDisplay.top + sx), Std.int(_imageDisplay.top + sy));
            }
            _imageDisplay.print(window, sx, sy, fg, bg);
        }
        
        for (child in childComponents) {
            child.printTo(nativeWindow);
        }
    }
    
    private function findClipComponent():Component {
        var r = null;
        var c = this;
        while (c != null) {
            if (c.componentClipRect != null) {
                r = c;
                break;
            }
            c = c.parentComponent;
        }
        
        return cast(r, Component);
    }
    
    //***********************************************************************************************************
    // Events
    //***********************************************************************************************************
    private var _hasMouseMoveListener:Bool = false;
    private function addMouseMoveListener() {
        if (_hasMouseMoveListener == false) {
            Mouse.listen(Mouse.MOVE, _onMouseMove);
            _hasMouseMoveListener = true;
        }
    }
    
    private var _hasMousePressedListener:Bool = false;
    private function addMousePressedListener() {
        if (_hasMousePressedListener == false) {
            Mouse.listen(Mouse.PRESSED, _onMousePressed);
            _hasMousePressedListener = true;
        }
    }
    
    private var _hasMouseReleasedListener:Bool = false;
    private function addMouseReleasedListener() {
        if (_hasMouseReleasedListener == false) {
            Mouse.listen(Mouse.RELEASED, _onMouseReleased);
            _hasMouseReleasedListener = true;
        }
    }
    
    private var _hasMouseWheelDownListener:Bool = false;
    private function addMouseWheelDownListener() {
        if (_hasMouseWheelDownListener == false) {
            Mouse.listen(Mouse.WHEEL_DOWN, _onMouseWheelDown);
            _hasMouseWheelDownListener = true;
        }
    }
    
    private var _hasMouseWheelUpListener:Bool = false;
    private function addMouseWheelUpListener() {
        if (_hasMouseWheelUpListener == false) {
            Mouse.listen(Mouse.WHEEL_UP, _onMouseWheelUp);
            _hasMouseWheelUpListener = true;
        }
    }
    
    private override function mapEvent(type:String, listener:UIEvent->Void) {
        switch (type) {
            case MouseEvent.MOUSE_OVER:
                if (_eventMap.exists(type) == false) {
                    _eventMap.set(type, listener);
                    addMouseMoveListener();
                }
            case MouseEvent.MOUSE_OUT:
                if (_eventMap.exists(type) == false) {
                    _eventMap.set(type, listener);
                    addMouseMoveListener();
                }
            case MouseEvent.MOUSE_DOWN:
                if (_eventMap.exists(type) == false) {
                    _eventMap.set(type, listener);
                    addMousePressedListener();
                }
            case MouseEvent.CLICK:    
                if (_eventMap.exists(type) == false) {
                    _eventMap.set(type, listener);
                    addMouseMoveListener();
                    addMousePressedListener();
                    addMouseReleasedListener();
                }
            case MouseEvent.MOUSE_WHEEL:
                if (_eventMap.exists(type) == false) {
                    _eventMap.set(type, listener);
                    addMouseWheelDownListener();
                    addMouseWheelUpListener();
                }
        }
    }
    
    private override function unmapEvent(type:String, listener:UIEvent->Void) {
    }
    
    private function boundsCheck(x:Int, y:Int) {
        if (hitTest(x, y) == false) {
            return false;
        }
        
        var clipComponent = findClipComponent();
        var clipRect:Rectangle = null;
        if (clipComponent != null) {
            clipRect = clipComponent.componentClipRect.copy();
            clipRect.left += clipComponent.screenLeft;
            clipRect.top += clipComponent.screenTop;
            if (clipRect.containsPoint(x, y) == false) {
                return false;
            }
        }
        
        return true;
    }
    
    private var _mouseIn:Bool = false;
    private function _onMouseMove(x:Int, y:Int) {
        var inBounds = boundsCheck(x, y);
        if (inBounds == true && _mouseIn == false) {
            _mouseIn = true;
            if (_eventMap.exists(MouseEvent.MOUSE_OVER)) {
                var event = new MouseEvent(MouseEvent.MOUSE_OVER);
                event.screenX = x;
                event.screenY = y;
                _eventMap.get(MouseEvent.MOUSE_OVER)(event);
            }
        } else if (inBounds == false && _mouseIn == true) {
            _mouseIn = false;
            if (_eventMap.exists(MouseEvent.MOUSE_OUT)) {
                var event = new MouseEvent(MouseEvent.MOUSE_OUT);
                event.screenX = x;
                event.screenY = y;
                _eventMap.get(MouseEvent.MOUSE_OUT)(event);
            }
        }
    }
    
    private var _mouseDown:Bool = false;
    private function _onMousePressed(x:Int, y:Int) {
        var inBounds = boundsCheck(x, y);
        if (inBounds == true) {
            _mouseDown = true;
            if (_eventMap.exists(MouseEvent.MOUSE_DOWN)) {
                var event = new MouseEvent(MouseEvent.MOUSE_DOWN);
                event.screenX = x;
                event.screenY = y;
                _eventMap.get(MouseEvent.MOUSE_DOWN)(event);
            }
        }
    }
    
    private function _onMouseReleased(x:Int, y:Int) {
        var inBounds = boundsCheck(x, y);
        if (inBounds == true && _mouseDown == true) {
            if (_eventMap.exists(MouseEvent.CLICK)) {
                var event = new MouseEvent(MouseEvent.CLICK);
                event.screenX = x;
                event.screenY = y;
                _eventMap.get(MouseEvent.CLICK)(event);
            }
        }
        _mouseDown = false;
    }
    
    private function _onMouseWheelDown(x:Int, y:Int) {
        var inBounds = boundsCheck(x, y);
        if (inBounds == true) {
            var event = new MouseEvent(MouseEvent.MOUSE_WHEEL);
            event.delta = -1;
            _eventMap.get(MouseEvent.MOUSE_WHEEL)(event);
        }
    }

    private function _onMouseWheelUp(x:Int, y:Int) {
        var inBounds = boundsCheck(x, y);
        if (inBounds == true) {
            var event = new MouseEvent(MouseEvent.MOUSE_WHEEL);
            event.delta = 1;
            _eventMap.get(MouseEvent.MOUSE_WHEEL)(event);
        }
    }
    
    //***********************************************************************************************************
    // Util
    //***********************************************************************************************************
}