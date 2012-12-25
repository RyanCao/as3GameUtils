package org.rcSpark.tools
{
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class OpenWindow {
		
		private static var browserName:String = "";
		
		public static function open(url:String, window:String="_blank", features:String=""):void{
			
			var WINDOW_OPEN_FUNCTION:String = "window.open";
			var myURL:URLRequest = new URLRequest(url);		
			
			if(browserName == ""){
				browserName = getBrowserName();
			}
			
			switch(getBrowserName())
			{
				case "Firefox":
					ExternalInterface.call(WINDOW_OPEN_FUNCTION, url, window, features);
					break;
				case "IE":
					ExternalInterface.call(WINDOW_OPEN_FUNCTION, url, window, features);
					break;
				case "Safari":
					navigateToURL(myURL, window);
					break;
				case "Opera":
					navigateToURL(myURL, window); 
					break;
				case "Undefined":
					navigateToURL(myURL, window);
					break;
			}
			
			/*Alternate methodology...
			var popSuccess:Boolean = ExternalInterface.call(WINDOW_OPEN_FUNCTION, url, window, features); 
			if(popSuccess == false){
			navigateToURL(myURL, window);
			}*/
			
		}
		
		private static function getBrowserName():String{
			var browser:String;
			
			//Uses external interface to reach out to browser and grab browser useragent info.
			try
			{
				var browserAgent:String = ExternalInterface.call("function getBrowser(){return navigator.userAgent;}");
			}
			catch(e:*)
			{
				
			}
			
			//  Debug.text += "Browser Info: [" + browserAgent + "]";
			
			//Determines brand of browser using a find index. If not found indexOf returns (-1).
			if(browserAgent != null && browserAgent.indexOf("Firefox") >= 0) {
				browser = "Firefox";
			} 
			else if(browserAgent != null && browserAgent.indexOf("Safari") >= 0){
				browser = "Safari";
			}			 
			else if(browserAgent != null && browserAgent.indexOf("MSIE") >= 0){
				browser = "IE";
			}		 
			else if(browserAgent != null && browserAgent.indexOf("Opera") >= 0){
				browser = "Opera";
			}
			else {
				browser = "Undefined";
			}
			return browser;
		}
	}
}