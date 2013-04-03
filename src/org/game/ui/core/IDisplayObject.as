package org.game.ui.core
{
import flash.display.IBitmapDrawable;
import flash.events.IEventDispatcher;

/**
 * 
 * @author zhangyu
 * 
 */
public interface IDisplayObject extends IEventDispatcher, IBitmapDrawable  ,IDisplayObjectInterface
{

	
	/**
	 * 移动至 
	 * @param x
	 * @param y
	 * 
	 */	
	//function move(x:Number, y:Number):void;
	
	/**
	 * 设置实际尺寸 
	 * @param x
	 * @param y
	 * 
	 */	
	//function setActualSize(newWidth:Number, newHeight:Number):void;
}
}