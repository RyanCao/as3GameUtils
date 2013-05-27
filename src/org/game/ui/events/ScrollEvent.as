package org.game.ui.events
{

import flash.events.Event;
/**
 * 
 * @author zhangyu
 * 
 */
public class ScrollEvent extends Event
{
	public static const SCROLL:String = "scroll";
	
	public function ScrollEvent(type:String, bubbles:Boolean = false,
								cancelable:Boolean = false,
								detail:String = null, position:Number = NaN,
                                direction:String = null, delta:Number = NaN)
	{
		super(type, bubbles, cancelable);

		this.detail = detail;
        this.position = position;
        this.direction = direction;
        this.delta = delta;
	}
	
	public var delta:Number;

	public var detail:String;

	public var direction:String;

    public var position:Number;

	override public function clone():Event
	{
		return new ScrollEvent(type, bubbles, cancelable, 
                               detail, position, direction, delta);
	}
}

}
