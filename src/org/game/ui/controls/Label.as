package org.game.ui.controls {
	import flash.text.TextField;
	
	import org.game.ui.core.BaseUI;
	
	
	/**
	 * @author ryancao
	 */
	public class Label extends BaseUI {
		private var defaultW:int = 120 ;
		private var defaultH : int = 20 ;
		private var _textfield : TextField;
		private var _text : String;
		public function Label() {
			super();
			init();
		}

		private function init() : void {
			_textfield = new TextField();
			addChild(_textfield);
			_textfield.selectable = false ;
			_textfield.mouseEnabled = false ;
			measuredWidth = defaultW ;
			measuredHeight = defaultH ;
			commitProperties();
		}

		override protected function commitProperties() : void {
			super.commitProperties();
			_textfield.width = width ;
			_textfield.height = height ;
		}
		
		public function get textfield() : TextField {
			return _textfield;
		}
		
		public function set text(value:String):void{
			if(_text==value)
				return ;
			_text = value ;
			_textfield.text = _text ;
		}
		public function get text():String{
			return _textfield.text;
		}
		
	}
}
