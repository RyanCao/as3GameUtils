/*******************************************************************************
 * Class name:	Console.as
 * Description:	
 * Author:		ryancao
 * Create:		Jul 31, 2013 2:39:22 PM
 * Update:		Jul 31, 2013 2:39:22 PM
 ******************************************************************************/
package org.rcSpark.tools.debug
{
	//-----------------------------------------------------------------------------
	// import_declaration
	//-----------------------------------------------------------------------------
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	
	
	public class Console extends EventDispatcher implements org.rcSpark.tools.debug.ILogger
	{
		//-----------------------------------------------------------------------------
		// Var
		//-----------------------------------------------------------------------------
		
		//-----------------------------------------------------------------------------
		// Constructor
		//-----------------------------------------------------------------------------
		public function Console(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function get category():String
		{
			return null;
		}
		
		public function log(level:int, message:String, ...parameters):void
		{
		}
		
		public function debug(message:String, ...parameters):void
		{
		}
		
		public function error(message:String, ...parameters):void
		{
		}
		
		public function fatal(message:String, ...parameters):void
		{
		}
		
		public function info(message:String, ...parameters):void
		{
		}
		
		public function warn(message:String, ...parameters):void
		{
		}
		
		//-----------------------------------------------------------------------------
		// Methods
		//-----------------------------------------------------------------------------
	}
}