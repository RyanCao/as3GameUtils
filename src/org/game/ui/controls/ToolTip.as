/*******************************************************************************
 * Class name:	ToolTip.as
 * Description:	
 * Author:		ryancao
 * Create:		Apr 9, 2013 4:33:38 PM
 * Update:		Apr 9, 2013 4:33:38 PM
 ******************************************************************************/
package org.game.ui.controls
{
	//-----------------------------------------------------------------------------
	// import_declaration
	//-----------------------------------------------------------------------------
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import org.game.ui.core.BaseUI;
	import org.game.ui.core.IToolTip;
	import org.game.ui.managers.IToolTipData;
	import org.game.ui.styles.StyleConst;
	
	
	public class ToolTip extends BaseUI implements IToolTip
	{
		//-----------------------------------------------------------------------------
		// Var
		//-----------------------------------------------------------------------------
		protected var textFiled:TextField;
		
		protected var border:DisplayObject;
		
		private var _data:IToolTipData ;
		//-----------------------------------------------------------------------------
		// Constructor
		//-----------------------------------------------------------------------------
		public function ToolTip()
		{
			super();
			_defaultStyleName =  StyleConst.TOOLTIP;
		}
		
		public function get data():IToolTipData
		{
			return _data;
		}
		
		public function set data(value:IToolTipData):void
		{
			if(_data == value)
				return ;
			_data = value ;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		//-----------------------------------------------------------------------------
		// Methods
		//-----------------------------------------------------------------------------
		override protected function createChildren():void
		{
			var borderClass:Class;
			borderClass = getStyle("border") as Class;
			if(borderClass)
			{
				border = new borderClass();
				addChild(border);
			}
			if(!textFiled)
			{
				textFiled  = new TextField();
				textFiled.x = 6;
				textFiled.y = 6;
				textFiled.mouseEnabled = false;
				textFiled.mouseEnabled = false;
				textFiled.selectable = false;
				//textFiled.wordWrap = true;
				textFiled.multiline = true;
				addChild(textFiled);
			}
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if(data)
			{
				var tf:TextFormat = new TextFormat();
				tf.size = getStyle("fontSize");
				tf.color = getStyle("fontColor");
				tf.align = TextFormatAlign.LEFT;
				textFiled.defaultTextFormat = tf;
				textFiled.htmlText = String(this.data.data);
				textFiled.width =  textFiled.textWidth + 6;
				textFiled.height = textFiled.textHeight + 6;
			}
		}
		
		override protected function measure():void
		{
			super.measure();
			
			this.measuredWidth = textFiled.textWidth + 16;
			this.measuredHeight = textFiled.textHeight + 16;
		}
		
		override protected function updateDisplayList(unscaleWidth:Number, unscaleHeight:Number):void
		{
			super.updateDisplayList(unscaleWidth, unscaleHeight);
			
			border.width = unscaleWidth;
			border.height = unscaleHeight;
		}
	}
}