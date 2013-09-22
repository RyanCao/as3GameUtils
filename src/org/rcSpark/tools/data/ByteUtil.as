package org.rcSpark.tools.data {
	import flash.utils.ByteArray;

	/**
	 * @author ryancao
	 */
	public class ByteUtil {
		private static var _instance : ByteUtil ;

		public static function getImpl() : ByteUtil {
			if (!_instance)
				_instance = new ByteUtil();
			return _instance;
		}

		public function ByteUtil() {
			if (_instance) {
				throw new Error('ByteU is single model');
			}
		}
		
		public function randomByteArray(l:int= 6):ByteArray
		{
			var b:ByteArray = new ByteArray();
			for (var i : int = 0; i < l; i++) {
				b.writeByte(int(Math.random()*0x39)+0x40);
			}
			return b;
		}
		/**
		 * 判斷兩個二進制內容是否相同
		 */
		public function equals(ba1:ByteArray , ba2:ByteArray):Boolean
		{
			var ba1p:int = ba1.position ;
			var ba2p:int = ba2.position ;
			ba1.position= 0 ;
			ba2.position= 0 ;
			var isEqual:Boolean = false ;
			if(ba1.bytesAvailable == ba2.bytesAvailable){
				isEqual = true ;
				while(ba1.bytesAvailable)
				{
					if(ba1.readUnsignedByte()!= ba2.readUnsignedByte())
					{
						isEqual = false ;
						break;
					}
				}
			}
			ba1.position= ba1p ;
			ba2.position= ba2p ;
			return isEqual ;
		}
		
		/**
		 * 以二进制形式输出ByteArray内容
		 * 返回 二进制数据
		 */
		public function showbyte(bytes : ByteArray,  hex : int = 16) : String {
			var position : int = bytes.position ;
			bytes.position = 0;
			var lineNum : int = 0;
			var str : String = '';
			while (bytes.bytesAvailable) {
				str += int(bytes.readUnsignedByte()).toString(hex) + "	";
				lineNum++ ;
				if (lineNum > 7) {
					lineNum = 0;
					str += '\n';
				}
			}
			bytes.position = position ;
			return str ;
		}
		
		/**
		 * 以二进制形式输出String内容
		 */
		public function showbyteStr(source : String, hex : int = 16) : String {
			var lineNum : int = 0;
			var str : String = '';
			for (var i : int = 0; i < source.length; i++) {
				str += source.charCodeAt(i).toString(hex) + "	";
				lineNum++ ;
				if (lineNum > 7) {
					lineNum = 0;
					str += '\n';
				}
			}
			return str ;
		}
		/**
		 * 读取位操作
		 */
		public function readBit(p:uint,bit:int):Boolean{
			return Boolean(p&(1<<bit));
		}
		/**
		 * 写入位操作
		 */
		public function writeBit(p:uint,bit:int,bitValue:Boolean):uint{
			var bv:Boolean = readBit(p, bit);
			if(bv==bitValue)
				return p;
			else if(bitValue == false)
				p -= 1<<bit ; 
			else
				p += 1<<bit ; 
			return p;
		}
	}
}
