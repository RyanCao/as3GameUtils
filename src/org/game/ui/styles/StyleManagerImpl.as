/*******************************************************************************
 * Class name:	StyleManagerImpl.as
 * Description:	
 * Author:		ryancao
 * Create:		Mar 27, 2013 4:15:01 PM
 * Update:		Mar 27, 2013 4:15:01 PM
 ******************************************************************************/
package org.game.ui.styles
{
	//-----------------------------------------------------------------------------
	// import_declaration
	//-----------------------------------------------------------------------------
	import flash.utils.Dictionary;
	
	import org.game.gameant;
	
	use namespace gameant ;
	public class StyleManagerImpl implements IStyleManager
	{
		//-----------------------------------------------------------------------------
		// Var
		//-----------------------------------------------------------------------------
		private var styleMap:Dictionary;
		
		//-----------------------------------------------------------------------------
		// Constructor
		//-----------------------------------------------------------------------------
		public function StyleManagerImpl()
		{
			styleMap = new Dictionary();
		}
		
		
		//-----------------------------------------------------------------------------
		// Methods
		//-----------------------------------------------------------------------------
		public function getStyleDeclaration(styleName:String):StyleDeclaration
		{
			var sourceStyle:StyleDeclaration = styleMap[styleName];
			return cloneStyleDeclaration(styleName, sourceStyle);
		}
		
		public function registerStyleDeclaration(styleName:String, style:Object):void
		{
			styleMap[styleName] = new StyleDeclaration(styleName, style);
		}
		
		public function createAnonymousStyle(styleName:String=""):StyleDeclaration
		{
			var style:StyleDeclaration = new StyleDeclaration(styleName, {});
			style.globalDeclaration = styleMap[StyleConst.GLOBAL];
			return style;
		}
		
		private function cloneStyleDeclaration(styleName:String, sourceStyle:StyleDeclaration):StyleDeclaration
		{
			var obj:Object = {};
			if(sourceStyle)
			{
				for(var i:String in sourceStyle.declaration) 
				{
					obj[i] = sourceStyle.declaration[i];
				}
			}
			var colneStyle:StyleDeclaration = new StyleDeclaration(styleName, obj);
			colneStyle.globalDeclaration = styleMap[StyleConst.GLOBAL];
			return colneStyle;
		}
		
	}
}