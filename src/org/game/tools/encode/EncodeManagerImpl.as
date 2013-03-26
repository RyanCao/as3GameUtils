/*******************************************************************************
 * Class name:	EncodeManagerImpl.as
 * Description:	
 * Author:		ryancao
 * Create:		Mar 25, 2013 12:09:01 PM
 * Update:		Mar 25, 2013 12:09:01 PM
 ******************************************************************************/
package org.game.tools.encode
{
	//-----------------------------------------------------------------------------
	// import_declaration
	//-----------------------------------------------------------------------------
	import flash.utils.ByteArray;
	
	
	public class EncodeManagerImpl implements IEncodeManager
	{
		//-----------------------------------------------------------------------------
		// Var
		//-----------------------------------------------------------------------------
		private var maxEncodeLength:uint = 400 ;
		/**
		 * 异或位
		 * */
		private var enCode:uint = 0xab ;
		/**
		 * 是否gzib压缩
		 * */
		private var gzibFlag:Boolean = true ;
		/**
		 * 文件被加密标志
		 * */
		private var enCodeFlag:uint = 0x9999;
		//-----------------------------------------------------------------------------
		// Constructor
		//-----------------------------------------------------------------------------
		public function EncodeManagerImpl()
		{
		}
		
		//-----------------------------------------------------------------------------
		// Methods
		//-----------------------------------------------------------------------------
		public function encode(ba:ByteArray):ByteArray
		{
			if(ba)
			{
				// --- 判断是否是已加密的文件
				ba.position = 0 ;
				var encodef:uint = ba.readUnsignedShort()&0x0000ffff;
				ba.position = 0 ;
				if(encodef == enCodeFlag){
					return ba ;
				}
				
				var preBytes : ByteArray = new ByteArray();
				var nextBytes : ByteArray ;
				
				if(ba.length>maxEncodeLength)
				{
					ba.position = 0 ;
					preBytes.writeBytes(ba,0,maxEncodeLength);
					preBytes.position = 0 ;
					nextBytes = new ByteArray();
					nextBytes.writeBytes(ba,maxEncodeLength,ba.length- maxEncodeLength);
					nextBytes.position = 0 ;
				}else{
					ba.position = 0 ;
					preBytes.writeBytes(ba,0,ba.length);
					preBytes.position = 0 ;
				}
				
				var len:int =preBytes.length;
				var preTmpBytes : ByteArray = new ByteArray();
				var tmpBytes : ByteArray = new ByteArray();
				for (var i : int = 0;i < len;i++) {
					preTmpBytes.writeByte(preBytes[i]^enCode)
//					if (i < 12)
//						tmpBytes.writeByte(preBytes[i]);
//					else
//						tmpBytes.writeByte(preBytes[i] + 88);
				}
				if(nextBytes)
				{
					preTmpBytes.writeBytes(nextBytes);
				}
				
				//---TODO--- 是否压缩字节流
				if(gzibFlag)
					preTmpBytes.compress();
				/**
				 * 写标志位，表明文件已被加密，也可防止被重复解码
				 * */
				tmpBytes.writeShort(enCodeFlag);
				tmpBytes.writeBytes(preTmpBytes);
				return tmpBytes;
			}
			return null;
		}
		
		public function decode(ba:ByteArray):ByteArray
		{
			if(ba)
			{
				// --- 判断是否是需要解密的文件
				ba.position = 0 ;
				var encodef:uint = ba.readUnsignedShort()&0x0000ffff;
				ba.position = 0 ;
				if(encodef != enCodeFlag){
					return ba ;
				}
				var tmpa:ByteArray = new ByteArray();
				tmpa.writeBytes(ba,2);
				ba = tmpa ;
				
				//---TODO--- 是否解压缩字节流
				if(gzibFlag)
					ba.uncompress();
				var preBytes : ByteArray = new ByteArray();
				var nextBytes : ByteArray ;
				if(ba.length>maxEncodeLength)
				{
					ba.position = 0 ;
					preBytes.writeBytes(ba,0,maxEncodeLength);
					preBytes.position = 0 ;
					nextBytes = new ByteArray();
					nextBytes.writeBytes(ba,maxEncodeLength);
					nextBytes.position = 0 ;
				}else{
					ba.position = 0 ;
					preBytes.writeBytes(ba,0,ba.length);
					preBytes.position = 0 ;
				}
				
				var len:int =preBytes.length;
				var preTmpBytes : ByteArray = new ByteArray();
				var tmpBytes : ByteArray = new ByteArray();
				for (var i : int = 0;i < len;i++) {
					preTmpBytes.writeByte(preBytes[i]^enCode);
					//					if (i < 12)
					//						tmpBytes.writeByte(preBytes[i]);
					//					else
					//						tmpBytes.writeByte(preBytes[i] - 88);
				}
				tmpBytes.writeBytes(preTmpBytes);
				if(nextBytes)
				{
					tmpBytes.writeBytes(nextBytes);
				}
				return tmpBytes;
			}
			return null;
		}
	}
}