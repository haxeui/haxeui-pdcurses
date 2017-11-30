package haxe.ui.backend;

import haxe.ui.backend.pdcurses.AppHelper;
import haxe.ui.core.Component;
import haxe.ui.core.MouseEvent;
import haxe.ui.core.UIEvent;
import haxe.ui.containers.dialogs.Dialog;
import haxe.ui.containers.dialogs.DialogButton;

class ScreenBase {
    private var _mapping:Map<String, UIEvent->Void>;
    
    public function new() {
        _mapping = new Map<String, UIEvent->Void>();
    }

    public var focus:Component;

    private var _options:Dynamic;
    public var options(get, set):Dynamic;
    private function get_options():Dynamic {
        return _options;
    }
    private function set_options(value:Dynamic):Dynamic {
        _options = value;
        return value;
    }

    public var width(get, null):Float;
    private function get_width():Float {
        return 0;
    }

    public var height(get, null):Float;
    private function get_height():Float {
        return 0;
    }

    public var dpi(get, null):Float;
    private function get_dpi():Float {
        return 72;
    }

    private var app(get, null):AppHelper;
    private function get_app():AppHelper {
        return options.app;
    }
    
    public function addComponent(component:Component) {
        app.addTopLevelWindow(component.window);
    }

    public function removeComponent(component:Component) {
    }

    private function handleSetComponentIndex(child:Component, index:Int) {
    }

    //***********************************************************************************************************
    // Dialogs
    //***********************************************************************************************************
    public function messageDialog(message:String, title:String = null, options:Dynamic = null, callback:DialogButton->Void = null):Dialog {
        return null;
    }

    public function showDialog(content:Component, options:Dynamic = null, callback:DialogButton->Void = null):Dialog {
        return null;
    }

    public function hideDialog(dialog:Dialog):Bool {
        return false;
    }

    //***********************************************************************************************************
    // Events
    //***********************************************************************************************************
    private function supportsEvent(type:String):Bool {
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

    private function mapEvent(type:String, listener:UIEvent->Void) {
        switch (type) {
            case MouseEvent.MOUSE_DOWN:
                _mapping.set(type, listener);
            case MouseEvent.MOUSE_UP:
                _mapping.set(type, listener);
            case MouseEvent.MOUSE_MOVE:
                _mapping.set(type, listener);
        }
    }

    private function unmapEvent(type:String, listener:UIEvent->Void) {
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