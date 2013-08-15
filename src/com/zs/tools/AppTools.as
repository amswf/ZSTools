package com.zs.tools
{
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;
	
	public class AppTools
	{
		public static var appUrl:String = "http://CJ.0569.COM";
		
		public function AppTools()
		{
		}
		/**
		 * flash取得包含该flash当前页面的地址 
		 * @return 
		 */             
		public static function getHtmlUrl():String
		{
			return ExternalInterface.call("eval", "window.location.href");   
		}
		/**
		 * flash取得自己的地址 
		 * 对于 SWF 文件的主类的实例，此 URL 与 SWF 文件自己的 URL 相同。
		 * @param loaderinfo
		 * @return 
		 */             
		public static function getSwfUrl(loaderinfo:LoaderInfo):String
		{
			return loaderinfo.loaderURL;
		}
		/**
		 * 获取swf的路径 
		 * @param loaderInfo
		 * @return 
		 */             
		public static function getSwfCatalog(loaderInfo:LoaderInfo):String
		{
			//通用代码段，获取播放器自身所在的路径 + 补全URL路径字符串以支持相对路径
			var playerrealurl:String = "";
			var playervarsstr:String = "";
			var playerrootpath:String = "";
			loaderInfo.url.indexOf("?", 0)>=0 ? playerrealurl=loaderInfo.url.slice(0, loaderInfo.url.indexOf("?", 0)) : playerrealurl=loaderInfo.url;
			loaderInfo.url.indexOf("?", 0)>=0 ? playervarsstr=loaderInfo.url.slice(loaderInfo.url.indexOf("?", 0)+1) : playervarsstr="";
			playerrealurl.lastIndexOf("/", playerrealurl.length)>=0 ? playerrootpath=playerrealurl.slice(0, playerrealurl.lastIndexOf("/", playerrealurl.length)) : playerrootpath="";
			
			return playerrootpath;
		}
		/**
		 * 无拦截窗口跳转 
		 * @param url
		 * 
		 */             
		public static function getURL(url:String):void
		{
			if (Capabilities.playerType == 'ActiveX' && supportJS) 
			{
				ExternalInterface.call("window.open", url);
			}
			else 
			{
				navigateToURL(new URLRequest(url),"_blank");
			}
		}
		/**
		 * 是否支持js 
		 * @return 
		 * 
		 */             
		public static function get supportJS():Boolean
		{
			var str:String;
			try
			{
				str = ExternalInterface.call("function(){return location.href}");
			}catch(err:Error){}
			return Boolean(str);
		}
		/**
		 * 普通的冒泡排序
		 * @param       arr
		 */
		public static function bubbleSort(arr:Array):void
		{
			var len:int = arr.length;
			for (var i:int = 0; i < len; i++)
			{
				for (var j:int = i + 1; j < len; j++)
				{
					if (arr[i] < arr[j])
					{
						var t:* = arr[i];
						arr[i] = arr[j];
						arr[j] = t;
					}
				}
			}
		}
		
		public static function getSWFId():String
		{
			var swfUID:String = "swf" + (Math.random() * 999999);
			ExternalInterface.addCallback(swfUID, function():void{});
			var location:Object = ExternalInterface.call("SWFInfo.locateSWF", swfUID);
			
			if(!location)
			{
				location = ExternalInterface.call("eval",
					"(window.SWFInfo = {"+
					"locateSWF:function(swfUID) {"+
					"var swfobjects = document.getElementsByTagName('embed');"+
					"if(!swfobjects.length) swfobjects = document.getElementsByTagName('object');"+
					"for(var i=0; i<swfobjects.length; i++) {"+
					"var name = swfobjects[i].name ? swfobjects[i].name : swfobjects[i].id;"+
					"if(document[name] && document[name][swfUID]) {"+
					"return name;"+
					"}"+
					"}"+
					"return null;"+
					"}"+
					"}).locateSWF('" + swfUID + "');");
			}
			
			var id:String = location ? String(location) : null
			return id;              
		}
		
		public static function tween(target:*,property:String,propertyTo:Number,delay:Number):void
		{
			var src:Number = target[property];
			var gap:Number = (propertyTo - src)/(delay * 30);//30是帧率
			
			target.addEventListener(Event.ENTER_FRAME,function(event:Event):void{
				gap*=0.985;
				src += gap;
				if(gap > 0 && src >= propertyTo)
				{
					src = propertyTo;
					target.removeEventListener(Event.ENTER_FRAME,arguments.callee);
				}
				else if(gap < 0 && src <= propertyTo)
				{
					src = propertyTo;
					target.removeEventListener(Event.ENTER_FRAME,arguments.callee);
				}
				target[property] = src;
			});
		}
		/**
		 * 轻量级加密解密 
		 * @param str
		 * @return 
		 * 
		 */             
		private function encode(str:String):String
		{
			var len:int = str.length;
			var baseOffset:int = 240;
			var step:int = 5;
			var currentOffset:int;
			var current:String;
			var ret:Array = [];
			var fillLeft:Array = ['Z','Y','X',''];
			
			for (var i:int = 0; i < len; i++) {
				currentOffset = i % 2 ? baseOffset + step : baseOffset - step;
				current = (str.charCodeAt(i) + currentOffset).toString(36);
				ret.push(fillLeft[current.length -1] + current)
			};
			return ret.join('');
		}
		
		private function decode(str:String):String
		{
			var baseOffset = 240;
			var step = 5;
			var currentOffset;
			var b = false;
			var ret = '';
			var offset;
			var current;
			for (var i = 0; i < str.length; i+= 5 - offset) {
				switch(str.charAt(i)){
					case 'X' :
						offset = 1;
						break;
					case 'Y' :
						offset = 2;
						break;
					case 'Z' :
						offset = 3;
						break;
					default : 
						offset = 0;
						i--;
						break;  
					
				}
				
				current = parseInt(str.substr(i + 1, 4 - offset), 36);
				
				if(b){
					currentOffset = baseOffset + step;
				}else{
					currentOffset = baseOffset - step;
				}
				b = !b;
				ret += String.fromCharCode(current - currentOffset);
			};
			return ret;
		}
		
	}
}