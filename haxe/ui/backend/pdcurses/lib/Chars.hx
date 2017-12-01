package haxe.ui.backend.pdcurses.lib;

@:include("curses.h")
extern class Chars {
    @:native("ACS_VLINE") public static var VLINE:Int;
    @:native("ACS_HLINE") public static var HLINE:Int;
    @:native("ACS_ULCORNER") public static var ULCORNER:Int;
    @:native("ACS_LLCORNER") public static var LLCORNER:Int;
    @:native("ACS_URCORNER") public static var URCORNER:Int;
    @:native("ACS_LRCORNER") public static var LRCORNER:Int;
    
    @:native("ACS_RTEE") public static var RTEE:Int;
    @:native("ACS_LTEE") public static var LTEE:Int;
    @:native("ACS_BTEE") public static var BTEE:Int;
    @:native("ACS_TTEE") public static var TTEE:Int;
    @:native("ACS_PLUS") public static var PLUS:Int;
    
    @:native("ACS_LARROW") public static var LARROW:Int;
    @:native("ACS_RARROW") public static var RARROW:Int;
    @:native("ACS_DARROW") public static var DARROW:Int;
    @:native("ACS_UARROW") public static var UARROW:Int;
    
    @:native("ACS_BLOCK") public static var BLOCK:Int;
    @:native("ACS_BOARD") public static var BOARD:Int;
    @:native("ACS_CKBOARD") public static var CKBOARD:Int;
    @:native("ACS_DIAMOND") public static var DIAMOND:Int;
    @:native("ACS_LANTERN") public static var LANTERN:Int;
}