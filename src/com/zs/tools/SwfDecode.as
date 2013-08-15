package com.zs.tools
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	public class SwfDecode extends Sprite
	{
		private var loader:URLLoader = new URLLoader();
		private var swf:Loader = new Loader();
		
		public function SwfDecode()
		{
			loader.load(new URLRequest('assets/test.js'));
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE,onLoaded);
		}
		
		protected function onLoaded(event:Event):void
		{
			var data:ByteArray = loader.data as ByteArray;
			data.uncompress();
			swf.loadBytes(data);
			this.addChild(swf);
		}
	}
}
