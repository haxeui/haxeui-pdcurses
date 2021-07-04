package haxe.ui.backend;

import haxe.ui.backend.pdcurses.CursesApp;
import haxe.ui.backend.pdcurses.lib.Curses;

@:buildXml('<include name=\"${haxelib:haxeui-pdcurses}/Build.xml\" />')
class AppImpl extends AppBase {
    
    private var _cursesApp:CursesApp;
    
    public function new() {
        _cursesApp = new CursesApp();
    }
    
    private override function init(onReady:Void->Void, onEnd:Void->Void = null) {
        var title:String = Toolkit.backendProperties.getProp("haxe.ui.pdcurses.title", null);
        if (title != null) {
            Curses.PDC_set_title(title);
        }
        _cursesApp.init();
        onReady();
    }

    private override function getToolkitInit():ToolkitOptions {
        return {
            app: _cursesApp
        };
    }

    public override function start() {
        _cursesApp.start();
    }
    
    public function trace(s:String) {
        _cursesApp.addLog(s);
    }
}
