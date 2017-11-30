package haxe.ui.backend.pdcurses;

class Color {
    public static inline var BLACK:Int = 0;
    public static inline var BLUE:Int = 1;
    public static inline var GREEN:Int = 2;
    public static inline var RED:Int = 4;

    public static inline var CYAN:Int = BLUE | GREEN;
    public static inline var MAGENTA:Int = RED | BLUE;
    public static inline var YELLOW:Int = RED | GREEN;
    public static inline var WHITE:Int = RED | GREEN | BLUE;
    
    public static inline var GREY:Int = 8;
    public static inline var BRIGHT_BLUE:Int = 9;
    public static inline var BRIGHT_GREEN:Int = 10;
    public static inline var BRIGHT_RED:Int = 12;
    
    public static inline var BRIGHT_CYAN:Int = BRIGHT_BLUE | BRIGHT_GREEN;
    public static inline var BRIGHT_MAGENTA:Int = BRIGHT_RED | BRIGHT_BLUE;
    public static inline var BRIGHT_YELLOW:Int = BRIGHT_RED | BRIGHT_GREEN;
    public static inline var BRIGHT_WHITE:Int = BRIGHT_RED | BRIGHT_GREEN | BRIGHT_BLUE;
}
