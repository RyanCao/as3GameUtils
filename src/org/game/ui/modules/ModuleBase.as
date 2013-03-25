/**
 *  Copyright (c) 2009 - 2010 LOOKBACKON All rights reserved.
 */
package org.game.ui.modules
{
	//--------------------------------------------------------------------------
	//
	//  Imports
	//
	//--------------------------------------------------------------------------
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;

	/****
	 * ModuleBase.as class. Created 10:48:34 PM Sep 8, 2012
	 * <br>
	 * Description:
	 * @author ryan
	 * @langversion 3.0
	 * @playerversion Flash 10
	 ****/
	public class ModuleBase extends Sprite implements IModule
	{
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function ModuleBase()
		{
			super();
		}

		//--------------------------------------------------------------------------
		//
		//  methods
		//
		//--------------------------------------------------------------------------
		/**
		 * 
		 * @param cls
		 * @param p_param
		 * @return 
		 * 
		 */
		protected function addUI(cls:Class, p_param:*=null):Object
		{
			if (cls == null)
				return null;
			var uiInstance:Object=(p_param == null) ? new cls() : new cls(p_param);
			this.addChild(uiInstance as DisplayObject);
			return uiInstance;
		}
		
		/**
		 *
		 * @param p_name
		 * @return
		 *
		 */
		protected function getClass(p_name:String):Class
		{
			try
			{
				return ApplicationDomain.currentDomain.getDefinition(p_name) as Class;
			}
			catch (p_e:ReferenceError)
			{
				//trace("定义 " + p_name + " 不存在");
				return null;
			}
			return null;
		}
		
		/**
		 * 
		 */		
		public function dispose():void
		{
			if (this.parent != null)
				this.parent.removeChild(this);
		}
		
		/**
		 * @param p_parent
		 * @param rest
		 */
		public function show(p_parent:DisplayObjectContainer, ... rest):void
		{
			
		}
	}
}
