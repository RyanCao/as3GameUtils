/**
 * Class name: CookieTest.as
 * Description:
 * Author: caoqingshan
 * Create: 14-12-4 下午10:02
 */
package {

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import org.rcSpark.tools.cookie.CookieManager;
import org.rcSpark.tools.cookie.CookieVO;

import org.rcSpark.tools.cookie.ICookieLocator;

public class CookieTest extends Sprite {
    //-----------------------------------------------------------------------------
    // Var
    //-----------------------------------------------------------------------------

    private var cookiePath:String = "cookieTest";
    private var icookie:ICookieLocator;

    public function CookieTest() {
        super();
        if (stage) {
            onAddToStageHandler(null);
        } else {
            addEventListener(Event.ADDED_TO_STAGE, onAddToStageHandler);
        }
    }

    private function onAddToStageHandler(param:Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, onAddToStageHandler);

        icookie = CookieManager.getCookie(cookiePath);

        var cookieVo:CookieVO = icookie.read("seed");
        if (cookieVo && cookieVo.vo) {
            trace("read seed：", cookieVo.vo);
        } else {
            trace("read seed：", "none");
        }

        stage.addEventListener(MouseEvent.CLICK, onMouseClickHandler);
    }

    private var count:uint = 0;

    private function onMouseClickHandler(event:MouseEvent):void {
        count++;
        trace("Click count:", count);
        var cookieVo:CookieVO = icookie.read("seed");
        if (cookieVo && cookieVo.vo) {
            clearSeed();
        } else {
            randomSaveSeed();
        }
    }

    private function randomSaveSeed():void {
        var num:Number = Math.random();
        icookie.save("seed", num);
        trace("save seed:", num);
    }

    private function clearSeed():void {
        icookie.clear("seed");
        trace("clear seed");
    }

    //-----------------------------------------------------------------------------
    // Methods
    //-----------------------------------------------------------------------------

}
}
