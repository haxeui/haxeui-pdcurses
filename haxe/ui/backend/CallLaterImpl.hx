package haxe.ui.backend;

class CallLaterImpl {
    private var _fn:Void->Void;
    
    public function new(fn:Void->Void) {
        fn();
    }
}