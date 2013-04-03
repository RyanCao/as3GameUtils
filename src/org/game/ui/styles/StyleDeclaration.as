/*******************************************************************************
 * Class name:	StyleDeclaration.as
 * Description:	
 * Author:		ryancao
 * Create:		Mar 27, 2013 2:42:02 PM
 * Update:		Mar 27, 2013 2:42:02 PM
 ******************************************************************************/
package org.game.ui.styles
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	
	import org.game.gameant;
	
	use namespace gameant;
	//-----------------------------------------------------------------------------
	// import_declaration
	//-----------------------------------------------------------------------------
	
	public class StyleDeclaration
	{
		//-----------------------------------------------------------------------------
		// Var
		//-----------------------------------------------------------------------------
		gameant var globalDeclaration:StyleDeclaration;
		
		private var _styleName:String;
		private var _declaration:Object;
		
		//-----------------------------------------------------------------------------
		// Constructor
		//-----------------------------------------------------------------------------
		public function StyleDeclaration(styleName:String, declaration:Object)
		{
			_styleName = styleName;
			_declaration = declaration;
		}
		
		//-----------------------------------------------------------------------------
		// Methods
		//-----------------------------------------------------------------------------

		public function get declaration():Object
		{
			return _declaration;
		}

		public function get styleName():String
		{
			return _styleName;
		}
		
		public function setStyle(styleName:String, value:*):void
		{
			_declaration[styleName] = value;
		}
		
		public function getStyle(styleName:String):*
		{
			var style:* = _declaration[styleName];
			if((style == null || style == undefined) && globalDeclaration)
				style = globalDeclaration.getStyle(styleName);
			return style;
		}
		
		public function getSkinInstance(styleName:String):DisplayObject
		{
			var skinTargeter:Object = _declaration[styleName];
			if(skinTargeter){
				if(skinTargeter is Class){
					return new skinTargeter();
				}else if(skinTargeter is DisplayObject){
					return DisplayObject(skinTargeter);
				}else if(skinTargeter is BitmapData){
					return new Bitmap(BitmapData(skinTargeter));
				}
			}
			return null;
		}
	}
}