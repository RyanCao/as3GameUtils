package org.game.ui.controls {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	import org.game.ui.core.BaseUI;

	/**
	 * @author ryan
	 */
	public class TextInput extends BaseUI {
		private var _textfield : TextField;
		
		private var _backSp : DisplayObject;
		private var _hlSp : DisplayObject;
		
		public function TextInput(backSp:Sprite=null, hlSp:Sprite = null) {
			_backSp = backSp;
			_hlSp = hlSp;
			initUI();
		}

		private function initUI() : void {
			_textfield =  new TextField();
			if(!_backSp){
				_backSp = new TextSpBg(); 
			}
			addChild(_backSp);
			_backSp.x = -1 ;
			_backSp.y = -1 ;
			addChild(_textfield);
			_w = 120 ;
			_h = 20 ;
			commitProperties();
		}
		
		override protected function commitProperties():void{
			(_backSp as TextSpBg).setSize(_w+2,_h+2);
			_textfield.width = _w;
			_textfield.height = _h;
		}
		
		public function get textField():TextField{
			return _textfield;
		}
		public function get text():String{
			return _textfield.text;
		}
		
		public function appendText(str:String):void{
			//_textfield.appendText(str);
			_textfield.htmlText += str ;
			_textfield.scrollV = _textfield.maxScrollV ;
			if(_textfield.maxScrollV > 1000)
				_textfield.htmlText = "";
		}
	}
}
