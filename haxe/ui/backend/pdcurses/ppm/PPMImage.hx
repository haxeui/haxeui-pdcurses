package haxe.ui.backend.pdcurses.ppm;
import haxe.ui.backend.pdcurses.Chars;

class PPMImage {
    public var width:Int;
    public var height:Int;
    public var data:Array<Int>;
    
    public var char:Int = Chars.BLOCK;
    
    public function new() {
    }
    
    public function loadFromString(s:String) {
        
        var temp = s.split("\n");
        var lines = [];
        for (line in temp) {
            line = StringTools.trim(line);
            if (line.length == 0) {
                continue;
            }
            if (StringTools.startsWith(line, "#")) {
                continue;
            }
            
            lines.push(line);
        }
        
        var magic = lines.shift();
        if (magic != "P3") {
            return;
        }
        
        var dimensions = lines.shift().split(" ");
        width = Std.parseInt(dimensions[0]);
        height = Std.parseInt(dimensions[1]);
        
        lines.shift();
        
        data = [];
        var parts = [];
        
        for (line in lines) {
            var items = line.split(" ");
            for (item in items) {
                item = StringTools.trim(item);
                if (item.length == 0) {
                    continue;
                }
                parts.push(item);
            }
        }
        
        var n = 0;
        var r = 0, g = 0, b = 0;
        for (part in parts) {
            if (n == 0) {
                r = Std.parseInt(part);
            } else if (n == 1) {
                g = Std.parseInt(part);
            } else if (n == 2) {
                b = Std.parseInt(part);
            }
            n++;
            if (n == 3) {
                data.push(Color.toANSI(r, g, b));
                n = 0;
            }
        }
    }
    
    public static function fromString(s:String):PPMImage {
        var i = new PPMImage();
        i.loadFromString(s);
        return i;
    }
    
    public static function fromChar(s:String):PPMImage {
        if (Image.charFromString(s) == -1) {
            return null;
        }
        var i = new PPMImage();
        i.width = 1;
        i.height = 1;
        i.char = Image.charFromString(s);
        i.data = [-1];
        return i;
    }
}