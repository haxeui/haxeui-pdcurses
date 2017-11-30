package haxe.ui.backend;

import haxe.ui.Preloader.PreloadItem;
import haxe.ui.backend.pdcurses.AppHelper;

@:buildXml('<include name=\"${haxelib:haxeui-pdcurses}/Build.xml\" />')
class AppBase {
    private var _app:AppHelper;
    
    public function new() {
        _app = new AppHelper();
    }

    private function build() {

    }

    private function init(onReady:Void->Void, onEnd:Void->Void = null) {
        _app.init();
        onReady();
    }

    private function getToolkitInit():Dynamic {
        return {
            app: _app
        };
    }

    public function start() {
        _app.start();
    }
    
    private function buildPreloadList():Array<PreloadItem> {
        return [];
    }
}
