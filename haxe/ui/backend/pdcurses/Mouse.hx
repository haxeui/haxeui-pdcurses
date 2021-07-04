package haxe.ui.backend.pdcurses;

class Mouse {
    public static inline var MOVE:String = "onmove";
    public static inline var PRESSED:String = "onpressed";
    public static inline var RELEASED:String = "onreleased";
    public static inline var WHEEL_UP:String = "onwheelup";
    public static inline var WHEEL_DOWN:String = "onwheeldown";
    
    private static var _listeners:Map<String, Array<Int->Int->Void>> = new Map<String, Array<Int->Int->Void>>();
    
    public static function listen(on:String, callback:Int->Int->Void) {
        var list = _listeners.get(on);
        if (list == null) {
            list = [];
            _listeners.set(on, list);
        }
        list.push(callback);
    }
    
    public static function unlisten(on:String, callback:Int->Int->Void) {
        var list = _listeners.get(on);
        if (list != null) {
            list.remove(callback);
            if (list.length == 0) {
                _listeners.remove(on);
            }
        }
    }
    
    public static function update(on:String, x:Int, y:Int) {
        var list = _listeners.get(on);
        if (list != null) {
            for (l in list) {
                l(x, y);
            }
        }
    }
}