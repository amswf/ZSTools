package com.zs.tools
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.utils.setTimeout;
	
	public class DomainQuery2 extends EventDispatcher
	{
		private var loader:URLLoader = new URLLoader();
		private var domain:String;
		
		public function DomainQuery2(_domain:String='oicq.com')
		{
			domain = _domain;
		}
		/**
		 * 查询 
		 * @param e
		 * 
		 */             
		public function start():void{
			var request:URLRequest = new URLRequest('http://reports.internic.net/cgi/whois?type=domain&whois_nic='+domain);
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
			var data:String = String(loader.data);
			//可以注册了
			if(data.indexOf('pendingDelete')>0){
				setTimeout(start,1000);
			}
			else{
				register();
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