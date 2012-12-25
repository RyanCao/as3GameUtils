package org.rcSpark.tools
{
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;
	
	public class ToolSet
	{
		public function ToolSet()
		{
		}
		
		/**
		 * 从指定的应用程序域获取一个公共定义。 该定义可以是一个类、一个命名空间或一个函数的定义。 
		 * @param str
		 * @return 
		 * 
		 */		
		public static function getDefinition(str:String):Class
		{
			if(ApplicationDomain.currentDomain.hasDefinition(str))
			{
				return ApplicationDomain.currentDomain.getDefinition(str) as Class;
			}
			
			try {
				return getDefinitionByName(str) as Class;
			} catch(e:Error) {
				
			}
			return null;
		}
	}
}