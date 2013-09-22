package org.dll.model {
	import org.dll.loader.DllLoader;
	
	public class DllModel {
		
		private var _id:String;
		private var _src:String;
		private var _desc:String;
		private var _loader:DllLoader;
		
		public function get loader():DllLoader{
			return _loader;
		}
		public function set loader(__loader:DllLoader):void{
			_loader = __loader;
		}
		public function get desc():String{
			return _desc;
		}
		public function set desc(__desc:String):void{
			_desc = __desc;
		}
		public function get src():String{
			return _src;
		}
		public function set src(__src:String):void{
			_src = __src;
		}
		public function get id():String{
			return _id;
		}
		public function set id(__id:String):void{
			_id = __id;
		}
		
	}
}
