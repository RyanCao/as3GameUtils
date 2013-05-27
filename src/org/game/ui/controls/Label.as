package org.game.ui.controls {
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	
	import org.game.ui.core.BaseUI;
	import org.game.ui.styles.StyleConst;
	
	
	/**
	 * @author ryancao
	 */
	public class Label extends BaseUI {
		
		private var defaultW:int = 120 ;
		private var defaultH : int = 20 ;
		
		private var _textfield : TextField;
		
		public function Label() {
			super();
			_defaultStyleName = StyleConst.LABEL ;
		}

		//--------------------------------------------------------------------------
		//		Methods
		//--------------------------------------------------------------------------
		private var _htmlText:String;
		public function get htmlText():String
		{
			return _htmlText;
		}

		public function set htmlText(value:String):void
		{
			if(_htmlText==value)
				return ;
			_htmlText = value;
			_text = "";
			
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		private var textFormatChanged : Boolean = false;
		private var _textFormat:TextFormat;
		
		public function get textFormat():TextFormat
		{
			return _textFormat;
		}
		
		public function set textFormat(value:TextFormat):void
		{
			_textFormat = value;
			
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
			
			textFormatChanged = true;
		}
		
		override protected function createChildren():void
		{
			if(!_textfield)
			{
				_textfield = new TextField();
				_textfield.multiline = false;
				_textfield.wordWrap = false;
				addChild(_textfield);
				measuredWidth = defaultW ;
				measuredHeight = defaultH ;
			}
			
			this.cacheAsBitmap = true;
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if(getStyle("useTextGlow"))
				this._textfield.filters = [new GlowFilter(getStyle("textGlowColor"), 1, 2, 2, 3)];
			else
				this._textfield.filters = null;
			
			_textfield.selectable = selectable;
			
			if(_textFormat && textFormatChanged)
			{
				_textfield.defaultTextFormat = _textFormat;
				
				textFormatChanged = false;
			}
			else
			{
				if(styleChanged)
				{
					var defaultTextFormat:TextFormat = new TextFormat();
					defaultTextFormat.font = getStyle("fontFamily");
					defaultTextFormat.size = getStyle("fontSize");
					defaultTextFormat.color = getStyle("fontColor");
					defaultTextFormat.align = getStyle("textAlign");
					_textfield.defaultTextFormat = defaultTextFormat;
					
					styleChanged = false;
				}
			}
			
			if(_htmlText)
				_textfield.htmlText = htmlText;
			else
				_textfield.text = text;
		}
		
		override protected function measure():void
		{
			super.measure();
			
			var tlm:TextLineMetrics = _textfield.getLineMetrics(0);
			
			this.measuredWidth = Math.ceil(tlm.width) + 5;
			this.measuredHeight = Math.ceil(tlm.height) + tlm.descent;
		}
		
		override protected function updateDisplayList(unscaleWidth:Number, unscaleHeight:Number):void
		{
			super.updateDisplayList(unscaleWidth,unscaleHeight);
			_textfield.width = getExplicitOrMeasuredWidth() ;
			_textfield.height = getExplicitOrMeasuredHeight() ;
		}
		
		public function get textfield() : TextField {
			return _textfield;
		}
		
		private var _text : String;
		public function set text(value:String):void{
			if(_text==value)
				return ;
			_text = value;
			_htmlText = "";
			
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		public function get text():String{
			return _textfield.text;
		}
		
		//------------------------------
		//		selected
		//------------------------------
		private var _selectable:Boolean = false;
		
		public function get selectable():Boolean
		{
			return _selectable;
		}
		
		public function set selectable(value:Boolean):void
		{
			_selectable = value;
			
			this.mouseEnabled = value;
			this.mouseChildren = value;
			
			if(_textfield)
			{
				_textfield.mouseEnabled = value ;
				_textfield.selectable = value;
			}
		}
	}
}
