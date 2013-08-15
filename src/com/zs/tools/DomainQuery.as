package com.zs.tools
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	public class DomainQuery extends EventDispatcher
	{
		private var loader:URLLoader = new URLLoader();
		private var domain:String;
		
		public function DomainQuery(_domain:String='oicq.com')
		{
			domain = _domain;
		}
		/**
		 * 查询 
		 * @param e
		 * 
		 */             
		public function start():void{
			var request:URLRequest = new URLRequest('http://panda.www.net.cn/cgi-bin/check.cgi?area_domain='+domain);
			loader.load(request);
			loader.addEventListener(IOErrorEvent.IO_ERROR,onError);
			loader.addEventListener(Event.COMPLETE,getInfo);
		}
		
		private function onError(e:IOErrorEvent):void
		{
			this.dispatchEvent(new Event('ioError'));
		}
		
		public function stop():void
		{
			loader.removeEventListener(Event.COMPLETE,getInfo);
		}
		/**
		 * 获取注册信息 
		 * @param event
		 * 
		 */             
		private function getInfo(e:Event):void
		{
			trace(loader.data);
			var data:XML = XML(loader.data);
			//可以注册了
			if(data.returncode == '200'){
				if(data.original && String(data.original).slice(0,3) == '210'){
					register();
				}else{
					start();
				}
			}
			else{
				this.dispatchEvent(new Event('donot_reg'));
			}
		}
		/**
		 * 注册 
		 * 
		 */             
		private function register():void
		{
			this.dispatchEvent(new Event('enable_reg'));
		}
	}
}