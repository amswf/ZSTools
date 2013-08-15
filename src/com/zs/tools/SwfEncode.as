package com.zs.tools
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	
	public class SwfEncode extends Sprite
	{
		private var file:FileReference = new FileReference();
		private var saver:FileReference = new FileReference();
		
		public function SwfEncode()
		{
			this.stage.addEventListener(MouseEvent.CLICK,onCLick);
			file.browse([new FileFilter('.swf','*.swf')]);
			file.addEventListener(Event.COMPLETE,onComplete);
			file.addEventListener(Event.SELECT,onSelect);
		}
		
		protected function onSelect(event:Event):void
		{
			file.load();
		}
		
		protected function onComplete(event:Event):void
		{
			trace('success!');
		}
		
		protected function onCLick(event:MouseEvent):void
		{
			file.data.compress();
			saver.save(file.data,'test.js');
		}
	}
}