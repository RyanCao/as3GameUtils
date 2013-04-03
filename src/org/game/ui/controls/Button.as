package org.game.ui.controls {
	import flash.display.SimpleButton;
	
	import org.game.ui.core.BaseUI;

	/**
	 * @author ryancao
	 */
	public class Button extends BaseUI {
		private var _simbutton : SimpleButton;
		private var _lab : Label;
		private var _defaultW:int = 60;
		private var _defaultH : int = 20;
		private var _label : String;
		private var upstate : RectSprite;
		private var downstate : RectSprite;
		private var overstate : RectSprite;
		private var hitstate : RectSprite;
		public function Button() {
			super();
			init();
		}

		private function init() : void {
			super.measuredWidth = _defaultW;
			super.measuredHeight = _defaultH;
			upstate = new RectSprite(0x888888);
			downstate = new RectSprite(0xdddddd);
			overstate = new RectSprite(0xaaaaaa);
			hitstate = upstate;
			_simbutton = new SimpleButton(upstate,overstate,downstate,hitstate);
			_lab = new Label();
			_lab.mouseEnabled = false;
			this.mouseEnabled = false ;
			addChild(_simbutton);
			addChild(_lab);
			commitProperties();
		}
		
		public function set label(value:String):void{
			if(_label == value)
				return ;
			_label = value;
			_lab.text = _label ;
		}
		
		override protected function commitProperties() : void {
			super.commitProperties();
			upstate.setSize(width,height);
			overstate.setSize(width, height);
			downstate.setSize(width, height);
			_simbutton.width = width ;
			_simbutton.height = height ;
			_lab.setSize(width, height);
		}
		
		public function set enable(b:Boolean):void{
			_simbutton.enabled = b ;
			_simbutton.mouseEnabled = _simbutton.mouseChildren = b ;
		}
		
		public function get enable():Boolean{
			return _simbutton.enabled ;
		}
		
	}
}
 import flash.display.Sprite;
 class RectSprite extends Sprite
 {
	private var _w:int = 80;
	private var _h : int = 20 ;
	private var _color : uint;
	
	public function RectSprite(c : uint=0xfe00fe){
		_color = c ;
		commitProperties();
	}
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
 }
