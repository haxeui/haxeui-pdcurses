package haxe.ui.backend.pdcurses.lib;

@:include("curses.h")
extern class MouseEvent {
    @:native("BUTTON1_PRESSED") public static var BUTTON1_PRESSED:Int;
    @:native("BUTTON1_RELEASED") public static var BUTTON1_RELEASED:Int;
    @:native("BUTTON1_CLICKED") public static var BUTTON1_CLICKED:Int;
    @:native("ALL_MOUSE_EVENTS") public static var ALL:Int;
}