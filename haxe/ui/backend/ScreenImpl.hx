package haxe.ui.backend;

import haxe.ui.backend.pdcurses.CursesApp;
import haxe.ui.backend.pdcurses.Keyboard;
import haxe.ui.backend.pdcurses.Mouse;
import haxe.ui.backend.pdcurses.lib.Curses;
import haxe.ui.core.Component;
import haxe.ui.events.KeyboardEvent;
import haxe.ui.events.MouseEvent;
import haxe.ui.events.UIEvent;

class ScreenImpl extends ScreenBase {
    private var _mapping:Map<String, UIEvent->Void>;
    
    public function new() {
        _mapping = new Map<String, UIEvent->Void>();
    }

    private override function get_width():Float {
        return app.terminalWidth;
    }

    private override function get_height():Float {
        return app.terminalHeight;
    }

    private override function set_title(s:String):String {
        Curses.PDC_set_title(s);
        return s;
    }
    
    private var app(get, null):CursesApp;
    private function get_app():CursesApp {
        return options.app;
    }

    public override function addComponent(component:Component):Component {
        if (component.percentWidth != null) {
            component.width = (component.percentWidth * width) / 100;
        }
        if (component.percentHeight != null) {
            component.height = (component.percentHeight * height) / 100;
        }
		return component;
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
    
    private var _hasKeyboardPressedListener:Bool = false;
    private function addKeyboardPressedListener() {
        if (_hasKeyboardPressedListener == false) {
            Keyboard.listen(Keyboard.PRESSED, _onKeyPressed);
            _hasKeyboardPressedListener = true;
        }
    }
    
    private override function supportsEvent(type:String):Bool {
        switch (type) {
            case MouseEvent.MOUSE_DOWN:
                return true;
            case MouseEvent.MOUSE_UP:
                return true;
            case MouseEvent.MOUSE_MOVE:
                return true;
            case KeyboardEvent.KEY_DOWN:
                return true;
            case KeyboardEvent.KEY_UP:
                return true;
        }
        return false;
    }
    
    private var _hasMouseUpListener:Bool = false;
    private override function mapEvent(type:String, listener:UIEvent->Void) {
        switch (type) {
            case MouseEvent.MOUSE_MOVE:
                if (_mapping.exists(type) == false) {
                    _mapping.set(type, listener);
                    addMouseMoveListener();
                }
            case MouseEvent.MOUSE_DOWN:
                if (_mapping.exists(type) == false) {
                    _mapping.set(type, listener);
                    addMousePressedListener();
                }
            case MouseEvent.MOUSE_UP:
                if (_mapping.exists(type) == false) {
                    _mapping.set(type, listener);
                    addMouseReleasedListener();
                }
            case KeyboardEvent.KEY_DOWN:
                if (_mapping.exists(type) == false) {
                    _mapping.set(type, listener);
                    addKeyboardPressedListener();
                }
            case KeyboardEvent.KEY_UP:
                if (_mapping.exists(type) == false) {
                    _mapping.set(type, listener);
                    addKeyboardPressedListener();
                }
        }
    }
    
    private function _onMouseMove(x:Int, y:Int) {
        var event = new MouseEvent(MouseEvent.MOUSE_MOVE);
        event.screenX = x;
        event.screenY = y;
        _mapping.get(MouseEvent.MOUSE_MOVE)(event);
    }
    
    private function _onMousePressed(x:Int, y:Int) {
        var event = new MouseEvent(MouseEvent.MOUSE_DOWN);
        event.screenX = x;
        event.screenY = y;
        _mapping.get(MouseEvent.MOUSE_DOWN)(event);
    }
    
    private function _onMouseReleased(x:Int, y:Int) {
        var event = new MouseEvent(MouseEvent.MOUSE_UP);
        event.screenX = x;
        event.screenY = y;
        _mapping.get(MouseEvent.MOUSE_UP)(event);
    }
    
    private function _onKeyPressed(ch:Int, shift:Bool) {
        var fn = _mapping.get(KeyboardEvent.KEY_DOWN);
        if (fn != null) {
            var event = new KeyboardEvent(KeyboardEvent.KEY_DOWN);
            event.keyCode = ch;
            event.shiftKey = shift;
            _mapping.get(KeyboardEvent.KEY_DOWN)(event);
        }
        
        var fn = _mapping.get(KeyboardEvent.KEY_UP);
        if (fn != null) {
            var event = new KeyboardEvent(KeyboardEvent.KEY_UP);
            event.keyCode = ch;
            event.shiftKey = shift;
            _mapping.get(KeyboardEvent.KEY_UP)(event);
        }
    }
}