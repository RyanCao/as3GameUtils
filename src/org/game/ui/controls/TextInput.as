package org.game.ui.controls {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import org.game.ui.core.BaseUI;
	import org.game.ui.styles.StyleConst;

	/**
	 * @author ryan
	 */
	public class TextInput extends BaseUI {
		private var _textfield : TextField;
		
		private var _backSp : DisplayObject;
		private var _hlSp : DisplayObject;
		
		public function TextInput(backSp:Sprite=null, hlSp:Sprite = null) {
			super();
			_defaultStyleName = StyleConst.TEXTINPUT ;
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
			addChild(_textfield);
			measuredWidth = 120 ;
			measuredHeight = 20 ;
			_textfield.x = 1 ;
			_textfield.y = 1 ;
			commitProperties();
		}
		
		override protected function updateDisplayList(unscaleWidth:Number, unscaleHeight:Number):void
		{
			super.updateDisplayList(unscaleWidth,unscaleHeight);
			(_backSp as TextSpBg).setSize(unscaleWidth,unscaleHeight);
			_textfield.width = unscaleWidth-2;
			_textfield.height = unscaleHeight-2;
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
