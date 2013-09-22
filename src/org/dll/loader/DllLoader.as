package org.dll.loader{
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	import org.dll.model.DllModel;
	
	public class DllLoader extends EventDispatcher {
		
		private var _l:Loader;
		private var _d:DllModel;
		private var _baseUrl:String = "";
		
		public function DllLoader(dllmodel:DllModel, baseurl:String=""){
			_d = dllmodel;
			_baseUrl = baseurl;
		}
		
		public function get dll():DllModel{
			return _d;
		}
		
		public function get content():Object{
			return _l ? _l.content : null;
		}
		
		public function load():void{
			_l = new Loader();
			_l.contentLoaderInfo.addEventListener(Event.COMPLETE, loadedHandler);
			_l.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			_l.load(new URLRequest(_baseUrl + _d.src));
		}
		
		private function loadedHandler(evt:Event):void{
			_l.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadedHandler);
			_l.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			dispatchEvent(evt);
		}
		
		private function progressHandler(evt:ProgressEvent):void{
			dispatchEvent(evt);
		}
		
	}
}
