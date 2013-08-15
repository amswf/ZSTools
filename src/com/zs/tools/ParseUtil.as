package com.zs.tools
{
	public class ParseUtil
	{
		public static function parseUTF(sourceTxt:String):String
		{
			var code:String = "";
			for(var i:int = 0; i<sourceTxt.length; i++)
			{
				var charcode:Number = sourceTxt.charCodeAt(i);
				if(charcode<128)
				{
					code += sourceTxt.charAt(i);
				}
				else
				{
					code += "\\u"+fixData(charcode.toString(16));
				}
			}
			
			return code;
		}
		
		private static function fixData(data:String):String
		{
			var result:String = "";
			switch(data.length)
			{
				case 4:
					result = data;
					break;
				case 3:
					result = "0"+data;
					break;
				case 2:
					result = "00"+data;
					break;
				case 1:
					result = "000" + data;
					break;
			}
			
			return result;
		}
		
		public static function parseFile(fileData:String):String
		{
			
			var data:Array = fileData.split("\r");
			
			for(var i:int = 0; i<data.length; i++)
			{
				var obj:String = data[i];
				
				if(obj.indexOf("=") != -1)
				{
					data[i] = parseData(obj);
				}
			}
			
			//trace(data);
			return data.join("\r");
		}
		
		private static function parseData(obj:String):String
		{
			var data:Array = obj.split("=");
			
			var key:String = data[0];
			var value:String = data[1];
			
			if(value.charAt(0) == " ")
			{
				value = value.substr(1,value.length);
			}
			
			
			return key + "= " + parseUTF(value);
		}
	}
}