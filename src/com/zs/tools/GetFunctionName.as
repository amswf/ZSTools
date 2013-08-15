package com.zs.tools
{
	import flash.display.Sprite;
	
	public class GetFunctionName
	{
		public function GetFunctionName()
		{
		}
		private function get(fun:Function):String{  
			try{  
				var k:Sprite = Sprite(fun);  
			}catch(err:Error){  
				var fn:String = err.message.replace(/.+::(\w+\/\w+)\(\)\}\@.+/,"$1");  
				return fn==err.message?(err.message.replace(/.+ (function\-\d+) .+/i,"$1")):fn;  
			}  
			return null;  
		}  
	}
}