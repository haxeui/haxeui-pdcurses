package haxe.ui.backend.pdcurses;

@:include("curses.h")
extern class Chars {
    @:native("ACS_VLINE")       public static var VLINE:Int;
    @:native("ACS_HLINE")       public static var HLINE:Int;
    @:native("ACS_ULCORNER")    public static var ULCORNER:Int;
    @:native("ACS_LLCORNER")    public static var LLCORNER:Int;
    @:native("ACS_URCORNER")    public static var URCORNER:Int;
    @:native("ACS_LRCORNER")    public static var LRCORNER:Int;
    
    @:native("ACS_RTEE")        public static var RTEE:Int;
    @:native("ACS_LTEE")        public static var LTEE:Int;
    @:native("ACS_BTEE")        public static var BTEE:Int;
    @:native("ACS_TTEE")        public static var TTEE:Int;
    @:native("ACS_PLUS")        public static var PLUS:Int;
    
    @:native("ACS_LARROW")      public static var LARROW:Int;
    @:native("ACS_RARROW")      public static var RARROW:Int;
    @:native("ACS_DARROW")      public static var DARROW:Int;
    @:native("ACS_UARROW")      public static var UARROW:Int;
    
    @:native("ACS_BLOCK")       public static var BLOCK:Int;
    @:native("ACS_BOARD")       public static var BOARD:Int;
    @:native("ACS_CKBOARD")     public static var CKBOARD:Int;
    @:native("ACS_DIAMOND")     public static var DIAMOND:Int;
    @:native("ACS_LANTERN")     public static var LANTERN:Int;
    
    @:native("ACS_BULLET")      public static var BULLET:Int;
    @:native("ACS_S3")          public static var TEST:Int;
    
    // additional chars dont seem to be in the header
    public inline static var HALF_BLOCK_BOTTOM:Int      = 220;
    public inline static var HALF_BLOCK_TOP:Int         = 223;
    public inline static var SQUARE:Int                 = 254;
    public inline static var TEXTURE_LIGHT:Int          = 176;
    public inline static var TEXTURE_MEDIUM:Int         = 177;
    public inline static var TEXTURE_DARK:Int           = 178;
    public inline static var SECTION_SIGN:Int           = 245;
    
    public inline static var X_SMALL:Int                = 120;
    public inline static var X_LARGE:Int                = 88;
    public inline static var X:Int                      = 158;
    
    public inline static var O_SMALL:Int                = 111;
    public inline static var O_LARGE:Int                = 79;
    public inline static var O:Int                      = 111;
}
