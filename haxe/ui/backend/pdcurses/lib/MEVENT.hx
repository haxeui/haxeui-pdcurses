package haxe.ui.backend.pdcurses.lib;

import cpp.RawPointer;

@:include("curses.h")
@:struct
@:native("MEVENT")
extern class MEVENT {
    public var id:Int;
    public var x:Int;
    public var y:Int;
    public var z:Int;
    public var bstate:Int;
    
    @:native("new MEVENT")                    public static function create():RawPointer<MEVENT>;
}
