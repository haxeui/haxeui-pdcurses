package haxe.ui.backend;

class CallLaterBase {
    private var _fn:Void->Void;
    
    public function new(fn:Void->Void) {
        fn();
    }
}