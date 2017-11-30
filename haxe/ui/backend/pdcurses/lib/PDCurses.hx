package haxe.ui.backend.pdcurses.lib;

import cpp.RawPointer;

@:include("curses.h")
extern class PDCurses {
    @:native("stdscr") public static var stdscr:RawPointer<WINDOW>;
    
    @:native("initscr") public static function initscr():Void;
    @:native("start_color") public static function start_color():Void;
    @:native("raw") public static function raw():Void;
    @:native("nodelay") public static function nodelay(w:RawPointer<WINDOW>, b:Bool):Void;
    @:native("noecho") public static function noecho():Void;
    @:native("curs_set") public static function curs_set(i:Int):Void;
    @:native("nonl") public static function nonl():Void;
    @:native("keypad") public static function keypad(w:RawPointer<WINDOW>, b:Bool):Void;
    @:native("refresh") public static function refresh():Void;
    @:native("endwin") public static function endwin():Void;
    
    @:native("wgetch") public static function wgetch(w:RawPointer<WINDOW>):Int;
    @:native("mouse_set") public static function mouse_set(i:Int):Int;
    @:native("request_mouse_pos") public static function request_mouse_pos():Int;
    @:native("getmouse") public static function getmouse():Int;
    @:native("mouseinterval") public static function mouseinterval(i:Int):Int;
    @:native("nc_getmouse") public static function nc_getmouse(p:RawPointer<MEVENT>):Int;
    
    @:native("werase") public static function werase(w:RawPointer<WINDOW>):Int;
    @:native("wclear") public static function wclear(w:RawPointer<WINDOW>):Int;
    @:native("wbkgd") public static function wbkgd(w:RawPointer<WINDOW>, c:Int):Int;
    @:native("delwin") public static function delwin(w:RawPointer<WINDOW>):Int;
    
    @:native("attrset") public static function attrset(a:Int):Int;
    @:native("mvaddch") public static function mvaddch(y:Int, x:Int, c:Int):Int;
    @:native("mvaddstr") public static function mvaddstr(y:Int, x:Int, s:String):Int;
    @:native("mvprintw") public static function mvprintw(y:Int, x:Int, s:String):Int;
    
    @:native("init_pair") public static function init_pair(i:Int, fg:Int, bg:Int):Void;
    @:native("COLOR_PAIR") public static function COLOR_PAIR(i:Int):Int;
    
}