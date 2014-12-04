/**
 * Created with IntelliJ IDEA.
 * User: huangchunbiao
 * Date: 13-11-1
 * Time: 下午5:55
 * To change this template use File | Settings | File Templates.
 */
package org.rcSpark.tools.keyboard
{

import flash.events.KeyboardEvent;

/**
 * Represents a sequence of keys (ex: Ctrl-Alt-F1, Alt-D, etc.)
 */
public class KeySequence
{
    private var _keyStr:String = "";
    private var _keyCode:uint;
    private var _ctrlPressed:Boolean;
    private var _shiftPressed:Boolean;
    private var _altPressed:Boolean;

    /**
     * Creates a new key sequence associated with the supplied key code and key modifier (Ctrl, Alt and Shift)
     * <p>A list of available key code can be found
     * <a href="http://msdn2.microsoft.com/en-us/library/ms927178.aspx">here</a>
     * </p>
     */
    public function KeySequence(keyCode:uint, keyStr:String = "", ctrlPressed:Boolean = false, altPressed:Boolean = false, shiftPressed:Boolean = false)
    {
        _keyCode = keyCode;
        _keyStr = keyStr;
        _ctrlPressed = ctrlPressed;
        if (_ctrlPressed) _keyStr = "Ctrl+" + _keyStr;
        _altPressed = altPressed;
        if (_altPressed) _keyStr = "Alt+" + _keyStr;
        _shiftPressed = shiftPressed;
        if (_shiftPressed) _keyStr = "Shift+" + _keyStr;
    }

    /**
     * Gets a value indicating whether this key sequence has been pressed in the supplied
     * keyboard event
     */
    public function isPressed(event:KeyboardEvent):Boolean
    {
        return event && event.keyCode == _keyCode && _ctrlPressed == event.ctrlKey && _altPressed == event.altKey && _shiftPressed == event.shiftKey;
    }

    public function toString():String
    {
        return _keyStr;
    }

    public function get keyCode():uint
    {
        return _keyCode;
    }

    public function set keyCode(value:uint):void
    {
        _keyCode = value;
    }
}
}