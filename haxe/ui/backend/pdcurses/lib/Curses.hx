package haxe.ui.backend.pdcurses.lib;

import cpp.ConstCharStar;
import cpp.Int16;
import cpp.RawPointer;

@:include("curses.h")
extern class Curses {
    @:native("stdscr")                      public static var stdscr:RawPointer<WINDOW>;
    
    @:native("initscr")                     public static function initscr():Void;
    @:native("start_color")                 public static function start_color():Void;
    @:native("raw")                         public static function raw():Void;
    @:native("nodelay")                     public static function nodelay(w:RawPointer<WINDOW>, b:Bool):Void;
    @:native("noecho")                      public static function noecho():Void;
    @:native("cbreak")                      public static function cbreak():Void;
    @:native("curs_set")                    public static function curs_set(i:Int):Void;
    @:native("nonl")                        public static function nonl():Void;
    @:native("keypad")                      public static function keypad(w:RawPointer<WINDOW>, b:Bool):Void;
    @:native("refresh")                     public static function refresh():Void;
    @:native("endwin")                      public static function endwin():Void;
    @:native("getch")                       public static function getch():Int;
    @:native("flushinp")                    public static function flushinp():Int;

    @:native("newwin")                      public static function newwin(nlines:Int, ncols:Int, begy:Int, begx:Int):RawPointer<WINDOW>;
    @:native("wmove")                       public static function wmove(w:RawPointer<WINDOW>, y:Int, x:Int):Void;
    @:native("mvwin")                       public static function mvwin(w:RawPointer<WINDOW>, y:Int, x:Int):Void;
    @:native("wrefresh")                    public static function wrefresh(w:RawPointer<WINDOW>):Void;
    @:native("box")                         public static function box(w:RawPointer<WINDOW>, verch:Int, horch:Int):Void;
    @:native("mvwaddch")                    public static function mvwaddch(w:RawPointer<WINDOW>, y:Int, x:Int, c:Int):Int;
    @:native("wattrset")                    public static function wattrset(w:RawPointer<WINDOW>, a:Int):Int;
    @:native("mvwaddstr")                   public static function mvwaddstr(w:RawPointer<WINDOW>, y:Int, x:Int, s:String):Int;
    @:native("mvwgetch")                    public static function mvwgetch(w:RawPointer<WINDOW>, y:Int, x:Int):Int;
    @:native("mvwinch")                     public static function mvwinch(w:RawPointer<WINDOW>, y:Int, x:Int):Int;
    
    @:native("getmaxx")                     public static function getmaxx(w:RawPointer<WINDOW>):Int;
    @:native("getmaxy")                     public static function getmaxy(w:RawPointer<WINDOW>):Int;
    @:native("resize_term")                 public static function resize_term(line:Int, columns:Int):Int;
    
    @:native("wgetch")                      public static function wgetch(w:RawPointer<WINDOW>):Int;
    @:native("mouse_set")                   public static function mouse_set(i:Int):Int;
    @:native("mouse_mask")                  public static function mouse_mask(i:Int, w:RawPointer<Int>):Int;
    @:native("request_mouse_pos")           public static function request_mouse_pos():Int;
    @:native("getmouse")                    public static function getmouse():Int;
    @:native("mouseinterval")               public static function mouseinterval(i:Int):Int;
    @:native("nc_getmouse")                 public static function nc_getmouse(p:RawPointer<MEVENT>):Int;
    @:native("wmouse_position")             public static function wmouse_position(w:RawPointer<WINDOW>, w:RawPointer<Int>, w:RawPointer<Int>):Int;
    @:native("ungetmouse")                  public static function ungetmouse(p:RawPointer<MEVENT>):Int;
    
    @:native("werase")                      public static function werase(w:RawPointer<WINDOW>):Int;
    @:native("wclear")                      public static function wclear(w:RawPointer<WINDOW>):Int;
    @:native("wbkgd")                       public static function wbkgd(w:RawPointer<WINDOW>, c:Int):Int;
    @:native("delwin")                      public static function delwin(w:RawPointer<WINDOW>):Int;
    
    @:native("attrset")                     public static function attrset(a:Int):Int;
    @:native("mvaddch")                     public static function mvaddch(y:Int, x:Int, c:Int):Int;
    @:native("mvaddstr")                    public static function mvaddstr(y:Int, x:Int, s:String):Int;
    @:native("mvprintw")                    public static function mvprintw(y:Int, x:Int, s:String):Int;
    @:native("printw")                      public static function printw(s:String):Int;
    
    @:native("init_pair")                   public static function init_pair(i:Int, fg:Int, bg:Int):Void;
    @:native("COLOR_PAIR")                  public static function COLOR_PAIR(i:Int):Int;
    @:native("PAIR_NUMBER")                 public static function PAIR_NUMBER(i:Int):Int;
    @:native("pair_content")                public static function pair_content(i:Int, fg:RawPointer<Int16>, bg:RawPointer<Int16>):Void;
    
    
    @:native("PDC_set_title")               public static function PDC_set_title(title:ConstCharStar):Void;
    
    @:native("BUTTON1_PRESSED")             public static var BUTTON1_PRESSED:Int;
    @:native("BUTTON1_RELEASED")            public static var BUTTON1_RELEASED:Int;
    @:native("BUTTON1_CLICKED")             public static var BUTTON1_CLICKED:Int;
    
    @:native("BUTTON2_PRESSED")             public static var BUTTON2_PRESSED:Int;
    @:native("BUTTON2_RELEASED")            public static var BUTTON2_RELEASED:Int;
    @:native("BUTTON2_CLICKED")             public static var BUTTON2_CLICKED:Int;
    
    @:native("BUTTON3_PRESSED")             public static var BUTTON3_PRESSED:Int;
    @:native("BUTTON3_RELEASED")            public static var BUTTON3_RELEASED:Int;
    @:native("BUTTON3_CLICKED")             public static var BUTTON3_CLICKED:Int;
    
    @:native("BUTTON4_PRESSED")             public static var BUTTON4_PRESSED:Int;
    @:native("BUTTON4_RELEASED")            public static var BUTTON4_RELEASED:Int;
    @:native("BUTTON4_CLICKED")             public static var BUTTON4_CLICKED:Int;
    
    @:native("BUTTON5_PRESSED")             public static var BUTTON5_PRESSED:Int;
    @:native("BUTTON5_RELEASED")            public static var BUTTON5_RELEASED:Int;
    @:native("BUTTON5_CLICKED")             public static var BUTTON5_CLICKED:Int;

    @:native("MOUSE_WHEEL_SCROLL")          public static var MOUSE_WHEEL_SCROLL:Int;
    
    @:native("ALL_MOUSE_EVENTS")            public static var ALL_MOUSE_EVENTS:Int;
    @:native("REPORT_MOUSE_POSITION")       public static var REPORT_MOUSE_POSITION:Int;
    @:native("KEY_MOUSE")                   public static var KEY_MOUSE:Int;
    @:native("CURSES_OK")                   public static var OK:Int;
    
    @:native("MOUSE_X_POS")                 public static var MOUSE_X_POS:Int;
    @:native("MOUSE_Y_POS")                 public static var MOUSE_Y_POS:Int;
    @:native("A_ATTRIBUTES")                public static var A_ATTRIBUTES:Int;
    @:native("A_CHARTEXT")                  public static var A_CHARTEXT:Int;
    @:native("A_COLOR")                     public static var A_COLOR:Int;
    @:native("A_ALTCHARSET")                public static var A_ALTCHARSET:Int;
}