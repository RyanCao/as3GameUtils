/**
 *  Copyright (c) 2009 - 2010 LOOKBACKON All rights reserved.
 */
package org.game.ui.controls
{
	//--------------------------------------------------------------------------
	//
	//  Imports
	//
	//--------------------------------------------------------------------------
	import flash.text.TextField;
	
	import org.game.ui.core.BaseUI;
	
	
	/****
	 * SLabel.as class. Created Sep 13, 2013 6:04:36 PM
	 * <br>
	 * Description:
	 * @author ryan
	 * @langversion 3.0
	 * @playerversion Flash 10
	 ****/   	 
	public class SLabel extends BaseUI
	{		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		private var defaultW:int = 120 ;
		private var defaultH : int = 20 ;
		private var _textfield : TextField;
		private var _text : String;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function SLabel()
		{
			super();
			init();
		}
		
		//--------------------------------------------------------------------------
		//
		//  methods
		//
		//--------------------------------------------------------------------------
		private function init() : void {
			_textfield = new TextField();
			addChild(_textfield);
			_textfield.selectable = false ;
			_textfield.mouseEnabled = false ;
			width = defaultW ;
			height = defaultH ;
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
		
		override public function setSize(w:Number,h:Number):void{
			if(width==w && height==h)
				return ;
			width = w ;
			height = h ;
			commitProperties();
		}
	}
}