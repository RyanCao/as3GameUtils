package org.rcSpark.tools.keyboard
{
import flash.display.Stage;
import flash.events.EventPhase;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;

public class KeyboardManager
{
    private static var instance_:KeyboardManager;

    public static function getInstance():KeyboardManager
    {
        if (null == instance_)
            instance_ = new KeyboardManager();
        return instance_;
    }

    private var comp:Stage;

    public function init(obj:Stage = null):void
    {

        comp = obj;
        comp.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, true);
        comp.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler, true);
        comp.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
        comp.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
    }

    private var enabled_:Boolean = true;

    public function set enabled(v:Boolean):void
    {
        enabled_ = v;
    }

    public function get enabled():Boolean
    {
        return enabled_;
    }

    private function keyDownHandler(env:KeyboardEvent):void
    {
       	if (!enabled_) return;
        if (env.eventPhase == EventPhase.CAPTURING_PHASE)
        {
            if(env.keyCode == Keyboard.SPACE)
            {
                env.stopPropagation();
            }
            return;
        }
        for each(var handler:IKeyboardHandler in handlerCache_)
        {
            if (handler && handler.acceptKey(env))
            {
                handler.handleKey(env);
            }
			
        }
    }

    private function keyUpHandler(env:KeyboardEvent):void
    {
        if (!enabled_) return;
        if (env.eventPhase == EventPhase.CAPTURING_PHASE)
        {
            return;
        }

    }

    private var handlerCache_:Array = new Array();

    public function addHandler(handler:IKeyboardHandler):void
    {
        if (handler && handlerCache_.indexOf(handler)==-1)
        {
            handlerCache_.push(handler);
        }
    }

    public function removeHandler(handler:IKeyboardHandler):void
    {
        var i:int = -1;
        if (handler && (i = handlerCache_.indexOf(handler)) != -1)
        {
            handlerCache_.splice(i,1);
        }
    }


}
}
