package haxe.ui.backend;

class CallLaterImpl {
    private static var _fns:Array<Void->Void> = [];
    
    public function new(fn:Void->Void) {
        _fns.push(fn);
    }
}