/*******************************************************************************
 * Class name:	LogReferences.as
 * Description:	
 * Author:		ryancao
 * Create:		Jul 30, 2013 7:19:51 PM
 * Update:		Jul 30, 2013 7:19:51 PM
 ******************************************************************************/
package org.rcSpark.tools.debug
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;

	//-----------------------------------------------------------------------------
	// import_declaration
	//-----------------------------------------------------------------------------
	
	public class LogReferences
	{
		//-----------------------------------------------------------------------------
		// Var
		//-----------------------------------------------------------------------------
		
		//-----------------------------------------------------------------------------
		// Constructor
		//-----------------------------------------------------------------------------
		public function LogReferences()
		{
		}
		
		//-----------------------------------------------------------------------------
		// Methods
		//-----------------------------------------------------------------------------
		public function makeString(o:*, prop:* = null, html:Boolean = false, maxlen:int = -1):String{
			var txt:String;
			try{
				var v:* = prop?o[prop]:o;
			}catch(err:Error){
				return "<p0><i>"+err.toString()+"</i></p0>";
			}
			if(v is Error) {
				var err:Error = v as Error;
				// err.getStackTrace() is not supported in non-debugger players...
				var stackstr:String = err.hasOwnProperty("getStackTrace")?err.getStackTrace():err.toString();		
				if(stackstr){
					return stackstr;
				}
				return err.toString();
			}else if(v is XML || v is XMLList){
				return shortenString(EscHTML(v.toXMLString()), maxlen, o, prop);
			}else if(v is QName){
				return String(v);
			}else if(v is Array || getQualifiedClassName(v).indexOf("__AS3__.vec::Vector.") == 0){
				var str:String = "[";
				var len:int = v.length;
				var hasmaxlen:Boolean = maxlen>=0;
				for(var i:int = 0; i < len; i++){
					var strpart:String = makeString(v[i], null, false, maxlen);
					str += (i?", ":"")+strpart;
					maxlen -= strpart.length;
					if(hasmaxlen && maxlen<=0 && i<len-1){
						str += ", "+genLinkString(o, prop, "...");
						break;
					}
				}
				return str+"]";
			}else{
				if(v is ByteArray) txt = "[ByteArray position:"+ByteArray(v).position+" length:"+ByteArray(v).length+"]";
				else txt = String(v);
				if(!html){
					return shortenString(EscHTML(txt), maxlen, o, prop);
				}
			}
			return txt;
		}
		
		private function genLinkString(o:*, prop:*, str:String):String{
			if(prop && !(prop is String)) {
				o = o[prop];
				prop = null;
			}
			var ind:uint;
			if(ind){
				return "<menu><a href='event:ref_"+ind+(prop?("_"+prop):"")+"'>"+str+"</a></menu>";
			}else{
				return str;
			}
		}
		
		private function shortenString(str:String, maxlen:int, o:*, prop:* = null):String{
			if(maxlen>=0 && str.length > maxlen) {
				str = str.substring(0, maxlen);
				return str+genLinkString(o, prop, " ...");
			}
			return str;
		}
		
		public static function EscHTML(str:String):String{
			return str.replace(/</g, "&lt;").replace(/\>/g, "&gt;").replace(/\x00/g, "");
		}
		public static function ShortClassName(obj:Object, eschtml:Boolean = true):String{
			var str:String = getQualifiedClassName(obj);
			var ind:int = str.indexOf("::");
			var st:String = obj is Class?"*":"";
			str = st+str.substring(ind>=0?(ind+2):0)+st;
			if(eschtml) return EscHTML(str);
			return str;
		}
	}
}