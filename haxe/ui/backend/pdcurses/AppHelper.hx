package haxe.ui.backend.pdcurses;

import cpp.vm.Thread;
import haxe.ui.backend.pdcurses.lib.PDCurses;
import haxe.ui.components.Label;
import haxe.ui.core.Screen;
import haxe.ui.events.MouseEvent;

@:access(haxe.ui.backend.ScreenImpl)
@:access(haxe.ui.backend.pdcurses.Window)
class AppHelper {
    private var _mouse:MouseHelper;
    
    private var _windows:Array<Window> = [];
    
    public var terminalWidth:Int = 0;
    public var terminalHeight:Int = 0;
    
    public function new() {
    }
    
    public function createTopLevelWindow():Window {
        var w = new Window(null);
        _windows.push(w);
        return w;
    }
    
    public function addTopLevelWindow(w:Window) {
        _windows.push(w);
    }
    
    public function init() {
        PDCurses.initscr();
        PDCurses.start_color();
        
        PDCurses.nodelay(PDCurses.stdscr, true);
        PDCurses.noecho();
        PDCurses.curs_set(0);
        PDCurses.keypad(PDCurses.stdscr, true);
        
        terminalWidth = PDCurses.getmaxx(PDCurses.stdscr);
        terminalHeight = PDCurses.getmaxy(PDCurses.stdscr);
        
        _mouse = new MouseHelper();
        _mouse.onPressed = onMousePressed;
        _mouse.onReleased = onMouseReleased;
        _mouse.init();
    }

    public static var debugString = "";
    
    private function findWindowsUnderPoint(x:Int, y:Int):Array<Window> {
        var windowsUnderPoint = [];
        for (w in _windows) {
            windowsUnderPoint = windowsUnderPoint.concat(w.findWindowsUnderPoint(x, y));
        }
        
        var temp = [];
        for (w in windowsUnderPoint) {
            if (!Std.is(w._c, Label)) {
                temp.push(w);
            }
        }
        
        windowsUnderPoint = temp;
        
        return windowsUnderPoint;
    }
    
    private var _currentDownWindow:Window;
    private function onMousePressed(x:Int, y:Int) {
        var windowsUnderPoint = findWindowsUnderPoint(x, y);
        
        if (windowsUnderPoint.length > 0) {
            var last = windowsUnderPoint[windowsUnderPoint.length - 1];
            last.mouseDown(x, y);
            _currentDownWindow = last;
        }
        
        if (Screen.instance._mapping.exists(MouseEvent.MOUSE_DOWN)) {
            var fn = Screen.instance._mapping.get(MouseEvent.MOUSE_DOWN);
            var mouseEvent:MouseEvent = new MouseEvent(MouseEvent.MOUSE_DOWN);
            mouseEvent.screenX = x;
            mouseEvent.screenY = y;
            fn(mouseEvent);
        }
        //debugString = "pressed! " + componentsUnderPoint.length;
    }
    
    private function onMouseReleased(x:Int, y:Int) {
        //debugString = "";
        var windowsUnderPoint = findWindowsUnderPoint(x, y);
        if (windowsUnderPoint.length > 0) {
            var last = windowsUnderPoint[windowsUnderPoint.length - 1];
            if (last == _currentDownWindow) {
                last.click(x, y);
            }
        }
        
        if (_currentDownWindow != null) {
            _currentDownWindow.mouseUp(x, y);
            _currentDownWindow = null;
        }
        
        if (Screen.instance._mapping.exists(MouseEvent.MOUSE_UP)) {
            var fn = Screen.instance._mapping.get(MouseEvent.MOUSE_UP);
            var mouseEvent:MouseEvent = new MouseEvent(MouseEvent.MOUSE_UP);
            mouseEvent.screenX = x;
            mouseEvent.screenY = y;
            fn(mouseEvent);
        }
    }
    
    public function start() {
        var threaded:Bool = false;
        
        if (threaded == true) {
            var t = Thread.create(run);
            Sys.getChar(false);
        } else {
            run();
        }
    }
    
    private function run() {
        var backgroundColor = Color.BRIGHT_WHITE;
        var backgroundColor = Color.BLACK;
        PDCurses.wbkgd(PDCurses.stdscr, PDCurses.COLOR_PAIR(ColorHelper.getColor(backgroundColor, backgroundColor)));
        var overWindows:Array<Window> = [];
        
        var _lastMouseX:Int = -1;
        var _lastMouseY:Int = -1;
        
        while (true) {
            var input = PDCurses.wgetch(PDCurses.stdscr);
            if (String.fromCharCode(input) == "q") {
                break;
            }
            
            PDCurses.wclear(PDCurses.stdscr);

            
            for (w in _windows) {
                w.redraw();
            }
            
            PDCurses.attrset(PDCurses.COLOR_PAIR(0));
            
            _mouse.update();
            
            var windowsUnderPoint = findWindowsUnderPoint(_mouse.x, _mouse.y);
            if (windowsUnderPoint.length > 0) {
                var last = windowsUnderPoint[windowsUnderPoint.length - 1];
                last.mouseOver(_mouse.x, _mouse.y);
            }
            
            for (c in overWindows) {
                if (windowsUnderPoint.indexOf(c) == -1) {
                    c.mouseOut(_mouse.x, _mouse.y);
                }
            }
            
            overWindows = windowsUnderPoint;
            
            //if (_lastMouseX != _mouse.x && _lastMouseY != _mouse.y) {
                _lastMouseX = _mouse.x;
                _lastMouseY = _mouse.y;
                
                if (Screen.instance._mapping.exists(MouseEvent.MOUSE_MOVE)) {
                    var fn = Screen.instance._mapping.get(MouseEvent.MOUSE_MOVE);
                    var mouseEvent:MouseEvent = new MouseEvent(MouseEvent.MOUSE_MOVE);
                    mouseEvent.screenX = _mouse.x;
                    mouseEvent.screenY = _mouse.y;
                    fn(mouseEvent);
                }
            //}
            
            PDCurses.attrset(PDCurses.COLOR_PAIR(ColorHelper.getColor(Color.BLACK, backgroundColor)));
            //PDCurses.mvprintw(1, 0, debugString + "                                           ");
            Sys.sleep(0.01);
        }
        
        _mouse.destroy();
        
        var backgroundColor = Color.BLACK;
        PDCurses.wbkgd(PDCurses.stdscr, PDCurses.COLOR_PAIR(ColorHelper.getColor(backgroundColor, backgroundColor)));
        PDCurses.wclear(PDCurses.stdscr);
        PDCurses.delwin(PDCurses.stdscr);
        PDCurses.endwin();
        PDCurses.refresh();
        
    }
}
