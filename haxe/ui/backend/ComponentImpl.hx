package haxe.ui.backend;

import haxe.ui.backend.pdcurses.ColorHelper;
import haxe.ui.backend.pdcurses.Window;
import haxe.ui.core.Component;
import haxe.ui.events.MouseEvent;
import haxe.ui.events.UIEvent;
import haxe.ui.geom.Rectangle;
import haxe.ui.styles.Style;

class ComponentImpl extends ComponentBase {
    private var _eventMap:Map<String, UIEvent->Void>;
    
    public var window:Window;
    
    public function new() {
        super();
        _eventMap = new Map<String, UIEvent->Void>();
    }

    public override function handleCreate(native:Bool) {
        window = new Window(cast this);
    }

    private override function handlePosition(left:Null<Float>, top:Null<Float>, style:Style) {
        trace(top);
        window.move(Math.ceil(left), Math.ceil(top));
    }

    private override function handleSize(width:Null<Float>, height:Null<Float>, style:Style) {
        window.resize(Std.int(width), Std.int(height));
    }

    private override function handleReady() {
    }

    private var _clipRect:Rectangle = null;
    private override function handleClipRect(value:Rectangle) {
        _clipRect = value;
        if (window != null) {
            var c:Component = cast(this, Component);
            window.x = Std.int(c.left - Math.ceil(value.left));
            window.y = Std.int(c.top - Math.ceil(value.top));
        }
    }

    private override function handleVisibility(show:Bool) {
        window.hidden = !show;
    }

    //***********************************************************************************************************
    // Display tree
    //***********************************************************************************************************
    private override function handleAddComponent(child:Component):Component {
        window.addChild(child.window);
        return child;
    }

    private override function handleRemoveComponent(child:Component, dispose:Bool = true):Component {
        return child;
    }

    private override function applyStyle(style:Style) {
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
    private override function mapEvent(type:String, listener:UIEvent->Void) {
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

    private override function unmapEvent(type:String, listener:UIEvent->Void) {
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