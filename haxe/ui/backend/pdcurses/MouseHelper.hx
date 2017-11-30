package haxe.ui.backend.pdcurses;

import cpp.Pointer;
import haxe.ui.backend.pdcurses.lib.MEVENT;
import haxe.ui.backend.pdcurses.lib.MouseEvent;
import haxe.ui.backend.pdcurses.lib.PDCurses;

class MouseHelper {
    public var displayMousePos:Bool = false;
    
    private var _mouseEvent:Pointer<MEVENT>;
    
    private var _isPressed:Bool = false;
    
    public var onPressed:Int->Int->Void;
    public var onReleased:Int->Int->Void;
    
    public function new() {
    }
    
    public function init() {
        _mouseEvent = Pointer.fromRaw(MEVENT.create());
        PDCurses.mouseinterval(1);
        PDCurses.mouse_set(MouseEvent.ALL);
    }
    
    public var x(get, null):Int;
    private function get_x():Int {
        if (_mouseEvent == null) {
            return 0;
        }
        return _mouseEvent.ptr.x;
    }
    
    public var y(get, null):Int;
    private function get_y():Int {
        if (_mouseEvent == null) {
            return 0;
        }
        return _mouseEvent.ptr.y;
    }
    
    public var button1Pressed(get, null):Bool;
    private function get_button1Pressed():Bool {
        if (_mouseEvent == null) {
            return false;
        }
        var bstate = _mouseEvent.ptr.bstate;
        return (bstate & MouseEvent.BUTTON1_PRESSED == MouseEvent.BUTTON1_PRESSED);
    }
    
    public function update() {
        PDCurses.nc_getmouse(_mouseEvent.rawCast());
        var bstate = _mouseEvent.ptr.bstate;
        
        if (bstate & MouseEvent.BUTTON1_PRESSED == MouseEvent.BUTTON1_PRESSED && _isPressed == false) {
            _isPressed = true;
            if (onPressed != null) {
                onPressed(x, y);
            }
        }

        if (bstate & MouseEvent.BUTTON1_RELEASED == MouseEvent.BUTTON1_RELEASED && _isPressed == true) {
            _isPressed = false;
            if (onReleased != null) {
                onReleased(x, y);
            }
        }
        
        if (displayMousePos == true) {
            PDCurses.mvprintw(0, 0, 'x: ${x}, y: ${y}    ');
        }
    }
    
    public function destroy() {
        if (_mouseEvent != null) {
            _mouseEvent.destroy();
        }
    }
}