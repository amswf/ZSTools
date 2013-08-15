package com.zs.tools
{
	import flash.display.DisplayObject;
	
	public class FlashVars
	{
		private static var vars:Object;
		
		public function FlashVars(cls:ZSFlashVars)
		{
			
		}
		
		public static function init(obj:DisplayObject):void
		{
			vars = obj.loaderInfo.parameters;
		}
		
		private static function getVar(name:String):Object
		{
			return vars[name];
		}
	}
}
class ZSFlashVars{}