/**
 * Class name: KeyboardTest.as
 * Description:
 * Author: caoqingshan
 * Create: 14-12-4 下午9:03
 */
package {

import flash.display.Sprite;
import flash.events.Event;
import flash.ui.Keyboard;

import org.rcSpark.tools.keyboard.KeySequence;

import org.rcSpark.tools.keyboard.KeyboardManager;

public class KeyboardTest extends Sprite {
    //-----------------------------------------------------------------------------
    // Var
    //-----------------------------------------------------------------------------

    public function KeyboardTest() {
        super();
        if (stage) {
            onAddToStageHandler(null);
        } else {
            addEventListener(Event.ADDED_TO_STAGE, onAddToStageHandler);
        }
    }

    private function onAddToStageHandler(event:Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, onAddToStageHandler);

        KeyboardManager.getInstance().init(stage);

        //A
        var aKey:KeyBoardHandler = new KeyBoardHandler();
        aKey.hotKey = new KeySequence(Keyboard.A, "A");

        //CTRL+A 此监听收不到 和 系统快捷键有关
        var cAKey:KeyBoardHandler = new KeyBoardHandler();
        cAKey.hotKey = new KeySequence(Keyboard.A, "A", true, false, false);

        //CTRL+1
        var c1Key:KeyBoardHandler = new KeyBoardHandler();
        c1Key.hotKey = new KeySequence(Keyboard.NUMBER_1, "1", true, false, false);

        //SHIFT+A
        var sAKey:KeyBoardHandler = new KeyBoardHandler();
        sAKey.hotKey = new KeySequence(Keyboard.A, "A", false, false, true);

        //ALT+A 此监听收不到 和 系统快捷键有关
        var aAKey:KeyBoardHandler = new KeyBoardHandler();
        aAKey.hotKey = new KeySequence(Keyboard.A, "A", false, true, false);

        //CTRL+SHIFT+A
        var cSAKey:KeyBoardHandler = new KeyBoardHandler();
        cSAKey.hotKey = new KeySequence(Keyboard.A, "A", true, false, true);

        //CTRL+ALT+A
        var cAAKey:KeyBoardHandler = new KeyBoardHandler();
        cAAKey.hotKey = new KeySequence(Keyboard.A, "A", true, true, false);

        //SHIFT+ALT+A 此监听收不到 和 系统快捷键有关
        var sAAKey:KeyBoardHandler = new KeyBoardHandler();
        sAAKey.hotKey = new KeySequence(Keyboard.A, "A", false, true, true);

        //CTRL+ALT+SHIFT+A
        var cSAAKey:KeyBoardHandler = new KeyBoardHandler();
        cSAAKey.hotKey = new KeySequence(Keyboard.A, "A", true, true, true);

        KeyboardManager.getInstance().addHandler(aKey);
        KeyboardManager.getInstance().addHandler(cAKey);
        KeyboardManager.getInstance().addHandler(c1Key);
        KeyboardManager.getInstance().addHandler(sAKey);
        KeyboardManager.getInstance().addHandler(aAKey);
        KeyboardManager.getInstance().addHandler(cSAKey);
        KeyboardManager.getInstance().addHandler(cAAKey);
        KeyboardManager.getInstance().addHandler(sAAKey);
        KeyboardManager.getInstance().addHandler(cSAAKey);
    }

    //-----------------------------------------------------------------------------
    // Methods
    //-----------------------------------------------------------------------------

}
}

import flash.events.KeyboardEvent;

import org.rcSpark.tools.keyboard.IKeyboardHandler;
import org.rcSpark.tools.keyboard.KeySequence;

class KeyBoardHandler implements IKeyboardHandler {

    private var hotKey_:KeySequence;

    //-----------------------------------------------------------------------------
    // Var
    //-----------------------------------------------------------------------------

    public function KeyBoardHandler() {
    }

    public function get hotKey():KeySequence {
        return hotKey_;
    }

    public function set hotKey(k:KeySequence):void {
        if (hotKey_ != k) {
            hotKey_ = k;
        }
    }

    //-----------------------------------------------------------------------------
    // Methods
    //-----------------------------------------------------------------------------

    public function acceptKey(env:KeyboardEvent, data:Object = null):Boolean {
        var tmpResult:Boolean = false;
        if (hotKey_.isPressed(env)) {
            tmpResult = true;
        }
        return tmpResult;
    }

    public function handleKey(env:KeyboardEvent, data:Object = null):void {
        trace(hotKey_.toString(), env, data);
    }

}
