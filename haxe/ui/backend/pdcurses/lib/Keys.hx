package haxe.ui.backend.pdcurses.lib;

@:include("curses.h")
extern class Keys {
                                public static inline var KEY_TAB:Int = 9;
                                public static inline var KEY_ESCAPE:Int = 27;
                                public static inline var KEY_SPACE:Int = 32;
                                public static inline var KEY_ENTER:Int = 10;
    
    @:native("KEY_BTAB")        public static var KEY_BTAB:Int;
    @:native("KEY_MOUSE")       public static var KEY_MOUSE:Int;
    @:native("KEY_DOWN")        public static var KEY_DOWN:Int;
    @:native("KEY_UP")          public static var KEY_UP:Int;
    @:native("KEY_LEFT")        public static var KEY_LEFT:Int;
    @:native("KEY_RIGHT")       public static var KEY_RIGHT:Int;
}