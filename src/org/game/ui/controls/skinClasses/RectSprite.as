/*******************************************************************************
 * Class name:	RectSprite.as
 * Description:	
 * Author:		ryancao
 * Create:		Apr 8, 2013 5:26:20 PM
 * Update:		Apr 8, 2013 5:26:20 PM
 ******************************************************************************/
package org.game.ui.controls.skinClasses
{
	//-----------------------------------------------------------------------------
	// import_declaration
	//-----------------------------------------------------------------------------
	import flash.display.Sprite;
	
	
	public class RectSprite extends Sprite
	{
		//-----------------------------------------------------------------------------
		// Var
		//-----------------------------------------------------------------------------
		private var _w:int = 80;
		private var _h : int = 20 ;
		private var _color : uint;
		
		//-----------------------------------------------------------------------------
		// Constructor
		//-----------------------------------------------------------------------------
		public function RectSprite(c : uint=0xfe00fe)
		{
			_color = c ;
			commitProperties();
		}
		
		//-----------------------------------------------------------------------------
		// Methods
		//-----------------------------------------------------------------------------
		public function setSize(w:int,h:int):void{
			_w = w ;
			_h = h ;
			commitProperties();
		}
		
		protected function commitProperties() : void {
			graphics.clear();
			graphics.beginFill(_color);
			graphics.drawRect(0, 0, _w, _h);
			graphics.endFill();
		}
		
		public function set color(c : uint) : void {
			this._color = c;
			commitProperties();
		}
		
		override public function get width():Number
		{
			return isNaN(_w) ? 0 : _w;
		}
		
		override public function set width(value:Number):void
		{
			if(_w != value)
			{
				_w = value ;
				commitProperties();
			}
		}
		
		override public function get height():Number
		{
			return isNaN(_h) ? 0 : _h;
		}
		
		override public function set height(value:Number):void
		{
			if(_h != value)
			{
				_h = value ;
				commitProperties();
			}
		}
	}
}