package org.game.tools.encode
{
	import flash.utils.ByteArray;

	public interface IEncodeManager
	{
		function encode(ba:ByteArray):ByteArray ;
		function decode(ba:ByteArray):ByteArray ;
	}
}