/*******************************************************************************
 * Class name:	EncodeManager.as
 * Description:	
 * Author:		ryancao
 * Create:		Mar 25, 2013 12:08:25 PM
 * Update:		Mar 25, 2013 12:08:25 PM
 ******************************************************************************/
package org.game.tools.encode
{
	//-----------------------------------------------------------------------------
	// import_declaration
	//-----------------------------------------------------------------------------
	import flash.utils.ByteArray;
	
	
	public class EncodeManager implements IEncodeManager
	{
		//-----------------------------------------------------------------------------
		// Var
		//-----------------------------------------------------------------------------
		private static var __impl:IEncodeManager;
		
		//-----------------------------------------------------------------------------
		// Constructor
		//-----------------------------------------------------------------------------
		public function EncodeManager()
		{
		}
		//-----------------------------------------------------------------------------
		// Methods
		//-----------------------------------------------------------------------------
		public static function get impl():IEncodeManager
		{
			if(!__impl)
				__impl = new EncodeManagerImpl();
			return __impl;
		}
		
		public function encode(ba:ByteArray):ByteArray
		{
			return impl.encode(ba);
		}
		
		public function decode(ba:ByteArray):ByteArray
		{
			return impl.decode(ba);
		}
	}
}