package haxe.ui.backend;

import haxe.ui.Preloader.PreloadItem;
import haxe.ui.backend.pdcurses.AppHelper;

@:buildXml('<include name=\"${haxelib:haxeui-pdcurses}/Build.xml\" />')
class AppImpl extends AppBase {
    private var _app:AppHelper;
    
    public function new() {
        _app = new AppHelper();
    }

    private override function init(onReady:Void->Void, onEnd:Void->Void = null) {
        _app.init();
        onReady();
    }

    private override function getToolkitInit():ToolkitOptions {
        return {
            app: _app
        };
    }

    public override function start() {
        _app.start();
    }
}
