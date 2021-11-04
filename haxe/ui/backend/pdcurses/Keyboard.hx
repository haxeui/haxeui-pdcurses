package haxe.ui.backend.pdcurses;

class Keyboard {
    public static inline var PRESSED:String = "onpressed";
    
    private static var _listeners:Map<String, Array<Int->Void>> = new Map<String, Array<Int->Void>>();
    
    public static function listen(on:String, callback:Int->Void) {
        var list = _listeners.get(on);
        if (list == null) {
            list = [];
            _listeners.set(on, list);
        }
        list.push(callback);
    }
    
    public static function unlisten(on:String, callback:Int->Void) {
        var list = _listeners.get(on);
        if (list != null) {
            list.remove(callback);
            if (list.length == 0) {
                _listeners.remove(on);
            }
        }
    }
    
    public static function update(key:Int) {
        if (key != -1) {
            var list = _listeners.get(PRESSED);
            if (list != null) {
                for (l in list) {
                    l(key);
                }
            }
        }
    }
}