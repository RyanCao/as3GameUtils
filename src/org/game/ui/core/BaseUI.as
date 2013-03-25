package org.game.ui.core {
	import flash.display.Sprite;

	/**
	 * @author ryan
	 */
	public class BaseUI extends Sprite implements IUIInterfaces {
		protected var _h : int;
		protected var _w : int;
		
		public function BaseUI() {
		}
		
		public function setSize(w:Number,h:Number):void{
			if(_w==w && _h==h)
				return ;
			_w = w ;
			_h = h ;
			commitProperties();
		}

		override public function set width(value:Number):void{
			if(_w==value)
				return ;
			_w = value ;
			commitProperties();
		}

		override public function set height(value:Number):void{
			if(_h==value)
				return ;
			_h = value ;
			commitProperties();
		}
		
		override public function get width():Number{
			return _w ;
		}

		override public function get height():Number{
			return _h ;
		}
		
		protected function commitProperties():void{
			
		}
	}
}
