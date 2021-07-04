package haxe.ui.backend.pdcurses;

typedef BorderCharSet = {
    var t:Int;
    var l:Int;
    var b:Int;
    var r:Int;
    var tl:Int;
    var tr:Int;
    var bl:Int;
    var br:Int;
    @:optional var useBackgroundColor:Bool;
}

class BorderTypes {
    public static var borderTypes:Map<String, BorderCharSet> = new Map<String, BorderCharSet>();
    
    private static var _populated:Bool = false;
    public static function populate() {
        _populated = true;
        borderTypes.set("single", {
            t: Std.int(Chars.HLINE),
            l: Std.int(Chars.VLINE),
            b: Std.int(Chars.HLINE),
            r: Std.int(Chars.VLINE),
            tl: Std.int(Chars.ULCORNER),
            tr: Std.int(Chars.URCORNER),
            bl: Std.int(Chars.LLCORNER),
            br: Std.int(Chars.LRCORNER),
            useBackgroundColor: true
        });
        
        borderTypes.set("solid", {
            t: Std.int(Chars.BLOCK),
            l: Std.int(Chars.BLOCK),
            b: Std.int(Chars.BLOCK),
            r: Std.int(Chars.BLOCK),
            tl: Std.int(Chars.BLOCK),
            tr: Std.int(Chars.BLOCK),
            bl: Std.int(Chars.BLOCK),
            br: Std.int(Chars.BLOCK)
        });
        
        borderTypes.set("thin", {
            t: 220,
            l: Std.int(Chars.BLOCK),
            b: 223,
            r: Std.int(Chars.BLOCK),
            tl: 220,
            tr: 220,
            bl: 223,
            br: 223
        });
        
        borderTypes.set("thin-inverse", {
            t: 223,
            l: Std.int(Chars.BLOCK),
            b: 220,
            r: Std.int(Chars.BLOCK),
            tl: 223,
            tr: 223,
            bl: 220,
            br: 220,
            useBackgroundColor: true
        });
    }
    
    public static function get(type:String):BorderCharSet {
        if (_populated == false) {
            populate();
        }
        return borderTypes.get(type);
    }
}