package haxe.ui.backend;

import haxe.ui.backend.pdcurses.AppHelper;
import haxe.ui.core.Component;
import haxe.ui.events.MouseEvent;
import haxe.ui.events.UIEvent;

class ScreenImpl extends ScreenBase2 {
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

    private var app(get, null):AppHelper;
    private function get_app():AppHelper {
        return options.app;
    }
    
    public override function addComponent(component:Component) {
        if (component.percentWidth != null) {
            component.width = (component.percentWidth * width) / 100;
        }
        if (component.percentHeight != null) {
            component.height = (component.percentHeight * height) / 100;
        }
        app.addTopLevelWindow(component.window);
    }

    public override function removeComponent(component:Component) {
    }

    private override function handleSetComponentIndex(child:Component, index:Int) {
    }

    //***********************************************************************************************************
    // Events
    //***********************************************************************************************************
    private override function supportsEvent(type:String):Bool {
        switch (type) {
            case MouseEvent.MOUSE_DOWN:
                return true;
            case MouseEvent.MOUSE_UP:
                return true;
            case MouseEvent.MOUSE_MOVE:
                return true;
        }
        return false;
    }

    private override function mapEvent(type:String, listener:UIEvent->Void) {
        switch (type) {
            case MouseEvent.MOUSE_DOWN:
                _mapping.set(type, listener);
            case MouseEvent.MOUSE_UP:
                _mapping.set(type, listener);
            case MouseEvent.MOUSE_MOVE:
                _mapping.set(type, listener);
        }
    }

    private override function unmapEvent(type:String, listener:UIEvent->Void) {
        switch (type) {
            case MouseEvent.MOUSE_DOWN:
                _mapping.remove(type);
            case MouseEvent.MOUSE_UP:
                _mapping.remove(type);
            case MouseEvent.MOUSE_MOVE:
                _mapping.remove(type);
        }
    }
}