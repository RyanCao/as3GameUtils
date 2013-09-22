package org.rcSpark.tools.data {
	import flash.utils.Dictionary;
	
	public class HashMap {
		
		private var length:int;
		private var content:Dictionary;
		
		public function HashMap(){
			this.length = 0;
			this.content = new Dictionary();
		}
		
		public function getKeyByValue(value:*):*{
			var key:*;
			for (key in this.content) {
				if (this.content[key] === value){
					return (key);
				};
			};
			return null;
		}
		
		public function size():int{
			return this.length;
		}
		public function isEmpty():Boolean{
			return this.length == 0;
		}
		public function keys():Array{
			var key:*;
			var array:Array = new Array(length);
			var count:int;
			for (key in this.content) {
				array[count] = key;
				count++;
			};
			return array;
		}
		public function eachKey(eachKeyFun:Function):void{
			var key:*;
			for (key in this.content) {
				eachKeyFun(key);
			}
		}
		public function eachValue(eachValueFun:Function):void{
			var value:*;
			for each (value in this.content) {
				eachValueFun(value);
			}
		}
		public function values():Array{
			var value:*;
			var array:Array = new Array(this.length);
			var count:int;
			for each (value in this.content) {
				array[count] = value;
				count++;
			};
			return array;
		}
		public function containsValue(value:*):Boolean{
			var _value:*;
			for each (_value in this.content) {
				if (_value === value){
					return (true);
				};
			};
			return false;
		}
		public function containsKey(key:*):Boolean{
			if (this.content[key] != undefined){
				return (true);
			};
			return false;
		}
		public function get(key:*):*{
			var _local2:* = this.content[key];
			if (_local2 !== undefined){
				return (_local2);
			};
			return null;
		}
		
		public function getValue(key:*):*{
			return this.get(key);
		}
		
		public function put(key:*, value:*):*{
			if (key == null){
				throw (new ArgumentError("cannot put a value with undefined or null key!"));
			};
			if (value == null){
				return this.remove(key);
			};
			
			var hasKey:Boolean = this.containsKey(key);
			if (!hasKey){
				this.length++;
			};
			
			var nowValue:* = this.get(key);
			this.content[key] = value;
			return nowValue;
		}
		
		public function remove(key:*):*{
			var hasKey:Boolean = this.containsKey(key);
			if (!hasKey){
				return null;
			};
			var nowValue:* = this.content[key];
			delete this.content[key];
			this.length--;
			return nowValue;
		}
		public function removeAll():void{
			var key:*;
			for (key in this.content) {
				this.remove(key);
			};
		}
		
		public function destory():void{
			this.removeAll();
			this.content = null;
			this.length = 0;
		}
		
		public function clone():HashMap{
			var key:*;
			var clone:HashMap = new HashMap();
			for (key in this.content) {
				clone.put(key, this.content[key]);
			};
			return clone;
		}
		public function toString():String{
			var keys:Array = this.keys();
			var values:Array = this.values();
			var toStrings:String = "HashMap Content:\n";
			var count:int;
			while (count < keys.length) {
				toStrings = toStrings + (keys[count] + " -> " + values[count]) + "\n";
				count++;
			};
			return toStrings;
		}
		
	}
}
