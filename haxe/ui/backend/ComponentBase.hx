package haxe.ui.backend;

import haxe.ui.backend.pdcurses.AppHelper;
import haxe.ui.backend.pdcurses.Color;
import haxe.ui.backend.pdcurses.ColorHelper;
import haxe.ui.backend.pdcurses.Window;
import haxe.ui.core.MouseEvent;
import haxe.ui.core.UIEvent;
import haxe.ui.core.Component;
import haxe.ui.styles.Style;
import haxe.ui.util.Rectangle;
import haxe.ui.core.ImageDisplay;
import haxe.ui.core.TextDisplay;
import haxe.ui.core.TextInput;

class ComponentBase {
    private var _eventMap:Map<String, UIEvent->Void>;
    
    public var window:Window;
    
    public function new() {
        _eventMap = new Map<String, UIEvent->Void>();
    }

    public function handleCreate(native:Bool) {
        window = new Window(cast this);
    }

    private function handlePosition(left:Null<Float>, top:Null<Float>, style:Style) {
        window.move(Std.int(left), Std.int(top));
    }

    private function handleSize(width:Null<Float>, height:Null<Float>, style:Style) {
        window.resize(Std.int(width), Std.int(height));
    }

    private function handleReady() {
    }

    private var _clipRect:Rectangle = null;
    private function handleClipRect(value:Rectangle) {
        _clipRect = value;
        if (window != null) {
            var c:Component = cast(this, Component);
            window.x = Std.int(c.left - value.left);
            window.y = Std.int(c.top - value.top);
        }
    }

    public function handlePreReposition() {
    }

    public function handlePostReposition() {
    }

    private function handleVisibility(show:Bool) {
        window.hidden = !show;
    }

    //***********************************************************************************************************
    // Text related
    //***********************************************************************************************************
    private var _textDisplay:TextDisplay;
    public function createTextDisplay(text:String = null):TextDisplay {
        if (_textDisplay == null) {
            _textDisplay = new TextDisplay();
        }
        if (text != null) {
            _textDisplay.text = text;
        }
        return _textDisplay;
    }

    public function getTextDisplay():TextDisplay {
        return createTextDisplay();
    }

    public function hasTextDisplay():Bool {
        return (_textDisplay != null);
    }

    private var _textInput:TextInput;
    public function createTextInput(text:String = null):TextInput {
        if (_textInput == null) {
            _textInput = new TextInput();
        }
        if (text != null) {
            _textInput.text = text;
        }
        return _textInput;
    }

    public function getTextInput():TextInput {
        return createTextInput();
    }

    public function hasTextInput():Bool {
        return (_textInput != null);
    }

    //***********************************************************************************************************
    // Image related
    //***********************************************************************************************************
    private var _imageDisplay:ImageDisplay;
    public function createImageDisplay():ImageDisplay {
        if (_imageDisplay == null) {
            _imageDisplay = new ImageDisplay();
        }
        return _imageDisplay;
    }

    public function getImageDisplay():ImageDisplay {
        return createImageDisplay();
    }

    public function hasImageDisplay():Bool {
        return (_imageDisplay != null);
    }

    public function removeImageDisplay() {
        if (_imageDisplay != null) {
            _imageDisplay = null;
        }
    }

    //***********************************************************************************************************
    // Display tree
    //***********************************************************************************************************
    private function handleSetComponentIndex(child:Component, index:Int) {
    }

    private function handleAddComponent(child:Component):Component {
        window.addChild(child.window);
        return child;
    }

    private function handleRemoveComponent(child:Component, dispose:Bool = true):Component {
        return child;
    }

    private function applyStyle(style:Style) {
        if (style.color != null) {
            window.color = ColorHelper.approximateColor(style.color);
        }
        if (style.backgroundColor != null) {
            window.backgroundColor = ColorHelper.approximateColor(style.backgroundColor);
        }
        if (style.filter != null) {
            window.shadow = true;
        }
    }

    //***********************************************************************************************************
    // Events
    //***********************************************************************************************************
    private function mapEvent(type:String, listener:UIEvent->Void) {
        switch (type) {
            case MouseEvent.MOUSE_OVER:
                _eventMap.set(type, listener);
            case MouseEvent.MOUSE_OUT:
                _eventMap.set(type, listener);
            case MouseEvent.MOUSE_DOWN:
                _eventMap.set(type, listener);
            case MouseEvent.MOUSE_UP:
                _eventMap.set(type, listener);
            case MouseEvent.CLICK:
                _eventMap.set(type, listener);
        }
    }

    private function unmapEvent(type:String, listener:UIEvent->Void) {
        switch (type) {
            case MouseEvent.MOUSE_OVER:
                _eventMap.remove(type);
            case MouseEvent.MOUSE_OUT:
                _eventMap.remove(type);
            case MouseEvent.MOUSE_DOWN:
                _eventMap.remove(type);
            case MouseEvent.MOUSE_UP:
                _eventMap.remove(type);
            case MouseEvent.CLICK:
                _eventMap.remove(type);
        }
    }
}