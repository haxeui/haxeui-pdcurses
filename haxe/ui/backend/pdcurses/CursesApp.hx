package haxe.ui.backend.pdcurses;

import cpp.Pointer;
import cpp.RawPointer;
import haxe.ValueException;
import haxe.ui.backend.TimerImpl;
import haxe.ui.backend.pdcurses.lib.Curses.*;
import haxe.ui.backend.pdcurses.lib.MEVENT;
import haxe.ui.backend.pdcurses.lib.WINDOW;
import haxe.ui.core.Screen;
import haxe.ui.util.Timer;

@:headerInclude("curses.h")
class CursesApp {
    public static var delay:Float = 0.0001;
    
    public function new() {
        haxe.Log.trace = function(v:Dynamic, ?infos:haxe.PosInfos) { 
          addLog(haxe.Log.formatOutput(v, infos));
        }
    }
    
    public function init() {
        initscr();
        start_color();
        nodelay(stdscr, true);
        curs_set(0);
        keypad(stdscr, true);
        noecho();
        
        terminalWidth = getmaxx(stdscr);
        terminalHeight = getmaxy(stdscr);
        
        mouseinterval(0);
        mouse_set(ALL_MOUSE_EVENTS | REPORT_MOUSE_POSITION);
    }
    
    public var terminalWidth:Int = 0;
    public var terminalHeight:Int = 0;
    
    private var _threaded:Bool = false;
    private var _loopCount:Int = 0;
    public function start() {
        startUnthreaded();
    }
    
    public var mouseX:Int = -1;
    public var mouseY:Int = -1;
    
    @:access(haxe.ui.backend.CallLaterImpl)
    private function startUnthreaded() {
        var ch = 0;
        
        var mouseEvent:Pointer<MEVENT> = Pointer.fromRaw(MEVENT.create());
        
        var backbuffer = newwin(0, 0, 0, 0);
        wbkgd(backbuffer, COLOR_PAIR(Color.find(Color.MID_COL, Color.MID_COL)));
        
        var button1Pressed = false;
        while (ch != 27) {
            ch = wgetch(stdscr);
            
            resize_term(0, 0);
            var tx = getmaxx(stdscr);
            var ty = getmaxy(stdscr);
            if (tx != terminalWidth || ty != terminalHeight) {
                terminalWidth = tx;
                terminalHeight = ty;
                delwin(backbuffer);
                backbuffer = newwin(0, 0, 0, 0);
                wbkgd(backbuffer, COLOR_PAIR(Color.find(Color.MID_COL, Color.MID_COL)));
            }
            
            TimerImpl.update();
            
            wclear(backbuffer);
            
            if (nc_getmouse(mouseEvent.rawCast()) == OK) {
                var bstate = mouseEvent.ptr.bstate;
                var wheel = false;
                if (bstate & BUTTON4_PRESSED == BUTTON4_PRESSED) {
                    flushinp();
                    mouseEvent.ptr.bstate = BUTTON4_RELEASED;
                    ungetmouse(mouseEvent.rawCast());
                    wheel = true;
                    Mouse.update(Mouse.WHEEL_UP, mouseX, mouseY);
                } else if (bstate & BUTTON5_PRESSED == BUTTON5_PRESSED) {
                    flushinp();
                    mouseEvent.ptr.bstate = BUTTON5_RELEASED;
                    ungetmouse(mouseEvent.rawCast());
                    
                    wheel = true;
                    Mouse.update(Mouse.WHEEL_DOWN, mouseX, mouseY);
                } else if (bstate & BUTTON4_RELEASED == BUTTON4_RELEASED) {
                    wheel = true;
                } else if (bstate & BUTTON5_RELEASED == BUTTON5_RELEASED) {
                    wheel = true;
                }
                
                if (wheel == false) {
                    var newX = mouseEvent.ptr.x;
                    var newY = mouseEvent.ptr.y;
                    if (mouseX != newX || mouseY != newY) {
                        if (newX > -1) {
                            mouseX = newX;
                        }
                        if (newY > -1) {
                            mouseY = newY;
                        }
                        Mouse.update(Mouse.MOVE, mouseX, mouseY);
                    }
                }
                if (bstate & BUTTON1_PRESSED == BUTTON1_PRESSED && button1Pressed == false) {
                    button1Pressed = true;
                    Mouse.update(Mouse.PRESSED, mouseX, mouseY);
                }
                if (bstate & BUTTON1_RELEASED == BUTTON1_RELEASED && button1Pressed == true) {
                    button1Pressed = false;
                    Mouse.update(Mouse.RELEASED, mouseX, mouseY);
                }
            }
            
            while (CallLaterImpl._fns.length > 0) {
                var fn = CallLaterImpl._fns.shift();
                fn();
            }
            
            for (c in Screen.instance.rootComponents) {
                c.printTo(backbuffer);
            }
            
            displayDebugInfo(backbuffer);
            displayMouseCursor(backbuffer);
            
            wrefresh(backbuffer);
            Sys.sleep(delay);
            _loopCount++;
        }
    }
    
    private function displayMouseCursor(window:RawPointer<WINDOW>) {
        var cc = mvwinch(window, mouseY, mouseX);
        var char = cc & A_CHARTEXT;
        var attr = cc & A_ATTRIBUTES;
        
        if (attr & A_ALTCHARSET == A_ALTCHARSET) {
            char |= A_ALTCHARSET;
        }
        
        if (char == Chars.BLOCK) {
            Color.set(window, Color.BLACK, Color.BRIGHT_WHITE);
        } else {
            Color.set(window, Color.BRIGHT_WHITE, Color.BLACK);
        }
        
        mvwaddch(window, mouseY, mouseX, char);
    }
    
    private function displayDebugInfo(window:RawPointer<WINDOW>) {
        Color.set(window, Color.BRIGHT_WHITE, Color.BLACK);
        var maxLogLines = terminalHeight - 1;
        var maxLogLineLength = 0;
        for (a in 0...maxLogLines) {
            if (_logLines[a].length > maxLogLineLength) {
                maxLogLineLength = _logLines[a].length;
            }
        }
        var n = 0;
        if (_logLines.length > maxLogLines) {
            n = _logLines.length - maxLogLines;
        }
        var logY = 1;
        for (a in n...n + maxLogLines) {
            var logX = terminalWidth - _logLines[a].length;
            mvwaddstr(window, logY, logX, _logLines[a]);
            logY++;
        }
        
        var s = mouseX + "x" + mouseY;
        //mvwaddstr(window, 0, terminalWidth - s.length, s);
    }
    
    private var _logLines:Array<String> = [];
    public function addLog(s:String) {
        _logLines.push(s);
    }
}