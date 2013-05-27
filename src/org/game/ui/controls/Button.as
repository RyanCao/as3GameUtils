/*******************************************************************************
 * Class name:	Button.as
 * Description:	
 * Author:		ryancao
 * Create:		Apr 7, 2013 4:51:35 PM
 * Update:		Apr 7, 2013 4:51:35 PM
 ******************************************************************************/
package org.game.ui.controls
{
	//-----------------------------------------------------------------------------
	// import_declaration
	//-----------------------------------------------------------------------------
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import org.game.gameant;
	import org.game.ui.controls.buttonClasses.ButtonBase;
	import org.game.ui.controls.buttonClasses.ButtonSkinState;
	import org.game.ui.controls.buttonClasses.LabelPlacement;
	import org.game.ui.controls.skinClasses.ButtonSkin;
	import org.game.ui.controls.skinClasses.RectSprite;
	import org.game.ui.styles.StyleConst;
	import org.game.ui.styles.StyleDeclaration;
	
	use namespace gameant ;
	
	//--------------------------------------
	//  Skins
	//--------------------------------------
	[Style(name="upSkin", type="Class", inherit="no")]
	[Style(name="overSkin", type="Class", inherit="no")]
	[Style(name="downSkin", type="Class", inherit="no")]
	[Style(name="disabledSkin", type="Class", inherit="no")]
	
	[Style(name="selectedUpSkin", type="Class", inherit="no")]
	[Style(name="selectedOverSkin", type="Class", inherit="no")]
	[Style(name="selectedDownSkin", type="Class", inherit="no")]
	[Style(name="selectedDisabledSkin", type="Class", inherit="no")]
	
	public class Button extends ButtonBase
	{
		//-----------------------------------------------------------------------------
		// Var
		//-----------------------------------------------------------------------------
		gameant var labelTextField:TextField;
		
		gameant var skin:ButtonSkin;
		
		private var labelChanged:Boolean = false;
		//-----------------------------------------------------------------------------
		// Constructor
		//-----------------------------------------------------------------------------
		public function Button()
		{
			super();
			_defaultStyleName = StyleConst.BUTTON ;
			buttonMode = true ;
		}
		
		//-----------------------------------------------------------------------------
		// Methods
		//-----------------------------------------------------------------------------
		
		//------------------------------
		//		labelpaddings
		//------------------------------
		private var _labelPaddings:Array = [3,3,3,2]
		
		/**
		 * 上下左右的间隔; 
		 * @return 
		 * 
		 */		
		public function get labelPaddings():Array
		{
			return _labelPaddings;
		}
		
		public function set labelPaddings(value:Array):void
		{
			_labelPaddings = value;
			
			invalidateSize();
			invalidateDisplayList();
		}
		
		//------------------------------
		//		labelPlacement
		//------------------------------
		private var _labelPlacement:String = LabelPlacement.MIDDLE;
		
		/**
		 * 按钮名称位置 
		 * @return 
		 * 
		 */	
		public function get labelPlacement():String
		{
			return _labelPlacement;
		}
		
		public function set labelPlacement(value:String):void
		{
			if(_labelPlacement != value)
			{
				_labelPlacement = value;
				
				invalidateSize();
				invalidateDisplayList();
			}
		}
		
		//------------------------------
		//		label
		//------------------------------
		private var _label:String = "";
		
		/**
		 * 最好在skin里面就搞定，不推荐使用这个属性 
		 * @return 
		 * 
		 */	
		public function get label():String
		{
			return _label;
		}
		
		public function set label(value:String):void
		{
			_label = value;
			
			if(labelTextField)
			{
				labelTextField.text = value;
				
				invalidateSize();
				invalidateDisplayList();
			}
		}
		//--------------------------------------------------------------------------
		//		Override
		//--------------------------------------------------------------------------
		override protected function createChildren():void
		{
			super.createChildren();
			skin = new ButtonSkin(parseStyleToSkin(deferredSetStyles));
			skin.currentState = this.skinState;
			addChild(skin);
			
			if(!labelTextField)
			{
				labelTextField = new TextField();
				//labelTextField.background = true;
				//labelTextField.backgroundColor = 0xff0000;
				labelTextField.mouseEnabled = false;
				labelTextField.selectable = false;
				//labelTextField.autoSize = TextFieldAutoSize.CENTER;
				//labelTextField.x = 100;
				/*labelTextField.background = true;
				labelTextField.backgroundColor = 0x00ff00;*/
				addChild(labelTextField);
			}
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			var tf:TextFormat = new TextFormat();
			tf.color = getStyle("fontColor");
			tf.align = getStyle("textAlign");//TextFormatAlign.CENTER;
			tf.size =  getStyle("fontSize");
			labelTextField.defaultTextFormat = tf;
			labelTextField.text = label;
			if(getStyle("useTextGlow"))
			{
				labelTextField.filters = [new GlowFilter(getStyle("textGlowColor"), 1, 2, 2)]
			}
			else
			{
				labelTextField.filters = null;
			}
		}
		
		override protected function measure():void
		{
			this.measuredWidth = Math.max(this.skin.width, this.labelTextField.textWidth + 4 + labelPaddings[2] + labelPaddings[3]);
			this.measuredHeight = Math.max(this.skin.height, this.labelTextField.textHeight + 4 + labelPaddings[0] + labelPaddings[1]);
		}
		
		override protected function updateDisplayList(unscaleWidth:Number, unscaleHeight:Number):void
		{
			super.updateDisplayList(unscaleWidth, unscaleHeight);
			
			skin.width = unscaleWidth;
			skin.height = unscaleHeight;
			labelTextField.width = unscaleWidth;
			labelTextField.height = this.labelTextField.textHeight + 4;
			
			labelTextField.y = (skin.height - labelTextField.height) / 2;
			switch(labelPlacement)
			{
				case LabelPlacement.LEFT : 
					labelTextField.x = labelPaddings[2];
					break;
				case LabelPlacement.RIGHT : 
					labelTextField.x = unscaleWidth - labelTextField.width - labelPaddings[2];
					break;
				case LabelPlacement.MIDDLE : 
					labelTextField.x = (unscaleWidth - labelTextField.width) / 2;
					break;
				default : break;
			}
			
			labelTextField.y = (unscaleHeight - labelTextField.height) / 2;
		}
		
		override protected function childrenCreated():void
		{
			skinStateChanged(this.skinState);
		}
		
		override protected function skinStateChanged(skinState:String):void
		{
			super.skinStateChanged(skinState);
			
			if(!skin)
			{
				return;
			}
			this.skin.currentState = skinState;
			switch(skinState)
			{
				case ButtonSkinState.SELECTED_UP:
				case ButtonSkinState.SELECTED_DOWN:
					labelTextField.textColor = getStyle("textSelectedColor");
					break;
				case ButtonSkinState.SELECTED_OVER:
				case ButtonSkinState.OVER:
					labelTextField.textColor = getStyle("textRollOverColor");
					break;
				case ButtonSkinState.DISABLED:
					labelTextField.textColor = getStyle("textDisabledColor");
					break;
				default:
					labelTextField.textColor = getStyle("fontColor");
					break;
			}
		}
		//--------------------------------------------------------------------------
		//		Methods
		//--------------------------------------------------------------------------
		//--------------------------------------------------------------------------
		//		Event Handler
		//--------------------------------------------------------------------------
		//--------------------------------------------------------------------------
		//		Privates
		//--------------------------------------------------------------------------
		
		private function parseStyleToSkin(style:StyleDeclaration):Object
		{
			var obj:Object = {};
			obj[ButtonSkinState.UP] = style.getSkinInstance("upSkin");
			if(!obj[ButtonSkinState.UP])
				obj[ButtonSkinState.UP] = new RectSprite(0x888888);
			
			obj[ButtonSkinState.DOWN] = style.getSkinInstance("downSkin");
			if(!obj[ButtonSkinState.DOWN])
				obj[ButtonSkinState.DOWN] = new RectSprite(0xdddddd);
			
			obj[ButtonSkinState.OVER] = style.getSkinInstance("overSkin");
			if(!obj[ButtonSkinState.OVER])
				obj[ButtonSkinState.OVER] = new RectSprite(0xaaaaaa);
			
			obj[ButtonSkinState.DISABLED] = style.getSkinInstance("disabledSkin");
			obj[ButtonSkinState.SELECTED_UP] = style.getSkinInstance("selectedUpSkin");
			obj[ButtonSkinState.SELECTED_DOWN] = style.getSkinInstance("selectedDownSkin");
			obj[ButtonSkinState.SELECTED_OVER] = style.getSkinInstance("selectedOverSkin");
			obj[ButtonSkinState.SELECTED_DISABLED] = style.getSkinInstance("selectedDisabledSkin");
			return obj;
		}
		//--------------------------------------------------------------------------
		//		Other
		//--------------------------------------------------------------------------
	}
}