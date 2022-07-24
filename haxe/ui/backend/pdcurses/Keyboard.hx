package haxe.ui.backend.pdcurses;

import haxe.ui.backend.pdcurses.lib.Curses.*;
import haxe.ui.backend.pdcurses.lib.Keys.*;

class Keyboard {
    public static inline var PRESSED:String = "onpressed";
    
    private static var _listeners:Map<String, Array<Int->Bool->Void>> = new Map<String, Array<Int->Bool->Void>>();
    
    public static function listen(on:String, callback:Int->Bool->Void) {
        var list = _listeners.get(on);
        if (list == null) {
            list = [];
            _listeners.set(on, list);
        }
        list.push(callback);
    }
    
    public static function unlisten(on:String, callback:Int->Bool->Void) {
        var list = _listeners.get(on);
        if (list != null) {
            list.remove(callback);
            if (list.length == 0) {
                _listeners.remove(on);
            }
        }
    }
    
    public static function update(key:Int) {
        if (key != -1 && key != KEY_MOUSE) {
            var m = PDC_get_key_modifiers();
            var shift = false;
            if (m != PDC_BUTTON_SHIFT) {
                shift = true;
            }
            if (shift == true) {
                if (key == KEY_BTAB) {
                    key = KEY_TAB;
                }
            }
            var list = _listeners.get(PRESSED);
            if (list != null) {
                for (l in list) {
                    l(key, shift);
                }
            }
        }
    }
}