package org.game.ui.controls.supportClasses
{
import flash.events.MouseEvent;
import flash.geom.Point;

import org.game.gameant;
import org.game.ui.controls.Button;
import org.game.ui.events.TrackEvent;

use namespace gameant
/**
 *
 * @author zhangyu 2012-10-24
 *
 **/
public class ScrollBase extends TrackBase
{
	//--------------------------------------------------------------------------
	//		Constructor
	//--------------------------------------------------------------------------
	public function ScrollBase()
	{
		super();
	}
	//--------------------------------------------------------------------------
	//		Variables
	//--------------------------------------------------------------------------
	protected var upArrowBtn:Button;
	protected var downArrowBtn:Button;
	//--------------------------------------------------------------------------
	//		Propertise
	//--------------------------------------------------------------------------
	private var _lineScrollSize:Number = 1;
	
	public function get lineScrollSize():Number
	{
		return _lineScrollSize;
	}
	
	public function set lineScrollSize(value:Number):void
	{
		_lineScrollSize = value;
	}
	
	//------------------------------
	//		pageScrollSize
	//------------------------------
	private var _pageScrollSize:Number = 0;
	
	public function get pageScrollSize():Number
	{
		return _pageScrollSize;
	}
	
	public function set pageScrollSize(value:Number):void
	{
		_pageScrollSize = value;
	}
	//--------------------------------------------------------------------------
	//		Method
	//--------------------------------------------------------------------------
	override protected function createChildren():void
	{
		super.createChildren();
		
		if(!upArrowBtn)
		{
			upArrowBtn = new Button();
			upArrowBtn.styleName = deferredSetStyles.getStyle("upArrow");
			upArrowBtn.addEventListener(MouseEvent.CLICK, upArrowClickHandler);
			addChild(upArrowBtn);
		}
		
		if(!downArrowBtn)
		{
			downArrowBtn = new Button();
			downArrowBtn.styleName = deferredSetStyles.getStyle("downArrow")
			downArrowBtn.addEventListener(MouseEvent.CLICK, downArrowClickHandler);
			addChild(downArrowBtn);
		}
	}
	
	public function setScrollProperties(pageScrollSize:Number, lineScrollSize:Number,
										minScrollPosition:Number,
										maxScrollPosition:Number):void
	{
		this.pageScrollSize = pageScrollSize;
		this.lineScrollSize = lineScrollSize;
		this.minValue = minScrollPosition;
		this.maxValue = maxScrollPosition;
		
		invalidateSize();
		invalidateDisplayList();
	}
	//--------------------------------------------------------------------------
	//		Event Handler
	//--------------------------------------------------------------------------
	
	private function upArrowClickHandler(event:MouseEvent):void
	{
		lineScroll(-1);
	}
	
	private function downArrowClickHandler(event:MouseEvent):void
	{
		lineScroll(1);
	}
	//--------------------------------------------------------------------------
	//		Private
	//--------------------------------------------------------------------------
	/**
	 *  @private
	 */
	gameant function lineScroll(direction:int):void
	{
		var delta:Number = _lineScrollSize;
		var newValue:Number = value + direction * delta;
		var oldValue:Number = this.value;
		this.value = newValue;
		
		dispatchEvent(new TrackEvent(TrackEvent.CHANGE, oldValue, this.value));
	}
	
	/**
	 *  @private
	 */
	gameant function pageScroll(direction:int):void
	{
		var delta:Number = _pageScrollSize != 0 ? _pageScrollSize : 1;
		
		var newValue:Number = value + direction * delta;
		var oldValue:Number = this.value;
		this.value = newValue;
		
		dispatchEvent(new TrackEvent(TrackEvent.CHANGE, oldValue, this.value));
	}
}
}