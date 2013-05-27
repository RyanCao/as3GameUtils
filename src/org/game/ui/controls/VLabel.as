package org.game.ui.controls
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import org.game.ui.core.BaseUI;
	
	public class VLabel extends BaseUI
	{
		public var txt:TextField;
		private var defaultFormat:TextFormat;
		private var drawSp:Shape;
		
		private var _text:String = "";
		private var dis:uint = 4 ;
		private var _textFormat:TextFormat;
		private var _textFilter:Array;
		
		public function VLabel()
		{
			super();
			initUI();
		}
		
		override protected function updateDisplayList(unscaleWidth:Number, unscaleHeight:Number):void
		{
			super.updateDisplayList(unscaleWidth,unscaleHeight);
			drawUI();
		}
		
		protected function drawUI():void
		{
			txt.text = _text;
			txt.width = txt.textWidth + dis;
			txt.height = txt.textHeight + dis;
			var bitmap:BitmapData=new BitmapData(txt.width,txt.height,true,0x00000000);
			bitmap.draw(txt);
			drawSp.graphics.clear();
			drawSp.graphics.beginBitmapFill(bitmap);
			drawSp.graphics.drawRect(0,0, bitmap.width, bitmap.height);
			drawSp.graphics.endFill();
			var pos:Number = bitmap.height;
			drawSp.rotation = 90 ;
			drawSp.x = pos ;
		}
		
		public function set textFormat(value:TextFormat):void
		{
			_textFormat = value ;
			txt.defaultTextFormat = _textFormat;
			drawUI();
		}

		public function set textFilters(value:Array):void
		{
			_textFilter = value ;
			if(!_textFilter)
				_textFilter = [];
			txt.filters = _textFilter;
			drawUI();
		}

		public function set text(value:String):void
		{
			_text = value ;
			txt.text = _text;
			drawUI();
		}
		
		private function initUI():void
		{
			// TODO Auto Generated method stub
			txt = new TextField();
			drawSp=new Shape();
			addChild(drawSp);
		}
		
	}
}