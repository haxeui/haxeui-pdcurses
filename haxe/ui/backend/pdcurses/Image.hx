package haxe.ui.backend.pdcurses;

class Image {
    public static function charFromString(s:String):Int {
        switch (s) {
            case "VLINE":               return Chars.VLINE;
            case "HLINE":               return Chars.HLINE;
            case "ULCORNER":            return Chars.ULCORNER;
            case "LLCORNER":            return Chars.LLCORNER;
            case "URCORNER":            return Chars.URCORNER;
            case "LRCORNER":            return Chars.LRCORNER;
            
            case "RTEE":                return Chars.RTEE;
            case "LTEE":                return Chars.LTEE;
            case "BTEE":                return Chars.BTEE;
            case "TTEE":                return Chars.TTEE;
            case "PLUS":                return Chars.PLUS;
            
            case "LARROW":              return Chars.LARROW;
            case "RARROW":              return Chars.RARROW;
            case "DARROW":              return Chars.DARROW;
            case "UARROW":              return Chars.UARROW;
            
            case "LTRIANGLE":           return 17;
            case "RTRIANGLE":           return 16;
            case "DTRIANGLE":           return 31;
            case "UTRIANGLE":           return 30;
            
            case "BLOCK":               return Chars.BLOCK;
            case "BOARD":               return Chars.BOARD;
            case "CKBOARD":             return Chars.CKBOARD;
            case "DIAMOND":             return Chars.DIAMOND;
            case "LANTERN":             return Chars.LANTERN;
             
            case "BULLET":              return Chars.BULLET;
            case "TEST":                return Chars.TEST;
            
            case "HALF_BLOCK_BOTTOM":   return Chars.HALF_BLOCK_BOTTOM;
            case "HALF_BLOCK_TOP":      return Chars.HALF_BLOCK_TOP;
            case "SQUARE":              return Chars.SQUARE;
            case "TEXTURE_LIGHT":       return Chars.TEXTURE_LIGHT;
            case "TEXTURE_MEDIUM":      return Chars.TEXTURE_MEDIUM;
            case "TEXTURE_DARK":        return Chars.TEXTURE_DARK;
            case "SECTION_SIGN":        return Chars.SECTION_SIGN;
            case "X":                   return Chars.X;
            case "X_SMALL":             return Chars.X_SMALL;
            case "X_LARGE":             return Chars.X_LARGE;
            case "O":                   return Chars.O;
            case "O_SMALL":             return Chars.O_SMALL;
            case "O_LARGE":             return Chars.O_LARGE;
        }
        return -1;
        
    }
}