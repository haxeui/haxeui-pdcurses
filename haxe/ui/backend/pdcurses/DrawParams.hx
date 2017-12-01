package haxe.ui.backend.pdcurses;

@:enum
abstract BorderType(Int) from Int to Int {
    var NONE = 0;
    var THIN = 1;
    var THICK = 2;
}

@:enum
abstract BorderEffect(Int) from Int to Int {
    var NONE = 0;
    var BRIGHT = 1;
    var OUTSET = 2;
    var INSET = 3;
}

class DrawParams {
    public var borderType:BorderType = BorderType.NONE;
    public var borderEffect:BorderEffect = BorderEffect.NONE;
    public var color:Int = 1;
    
    public var shadow:Bool = false;
    public var shadowColor:Int = 0;
    
    public var backgroundChar:Null<Int> = null;
    
    public function new() {
        
    }
    
}