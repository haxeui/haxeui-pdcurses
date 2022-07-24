package haxe.ui.backend;

import haxe.ui.backend.pdcurses.lib.Keys.*;

class PlatformImpl extends PlatformBase {
    public override function getKeyCode(keyId:String):Int {
        return switch (keyId) {
            case "tab":    KEY_TAB;
            case "up":     KEY_UP;
            case "down":   KEY_DOWN;
            case "left":   KEY_LEFT;
            case "right":  KEY_RIGHT;
            case "space":  KEY_SPACE;
            case "enter":  KEY_ENTER;
            case "escape": KEY_ESCAPE;
            case _: keyId.charCodeAt(0);
        }
    }
}