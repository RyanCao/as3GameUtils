package org.game.ui.styles
{

	public interface IStyleManager
	{
		function getStyleDeclaration(styleName:String):StyleDeclaration;
		function registerStyleDeclaration(styleName:String, style:Object):void;
		function createAnonymousStyle(styleName:String = ""):StyleDeclaration;
	}
}