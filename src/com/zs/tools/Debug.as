package com.zs.tools
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
	public final class Debug
	{
		private static var debugText:TextField;
		private static var line:int = 0;
		
		public function Debug(param:ZS123Singleton)
		{
		}
		/**
		 * 本方法在程序初始化时调用 
		 * @param app
		 * @param defaultVisible：日志默认显示与否
		 * 
		 */             
		public static function init(app:DisplayObject,defaultVisible:Boolean=false,hideKey:int=Keyboard.ESCAPE):void
		{
			if(debugText == null)
			{
				debugText = new TextField();
				debugText.multiline = true;
				debugText.border = true;
				debugText.background = true;
				debugText.wordWrap = true;
				debugText.visible = defaultVisible;
				
				var addtostage:Function = function():void
				{
					app.removeEventListener(Event.ADDED_TO_STAGE,addtostage);
					debugText.width = app.stage.stageWidth;
					debugText.height = app.stage.stageHeight/2;
					app.stage.addChild(debugText);
					
					app.stage.addEventListener(KeyboardEvent.KEY_DOWN,function(event:KeyboardEvent):void{
						if(event.keyCode == hideKey)
						{
							if(debugText.visible == false)
							{
								debugText.visible = true;
								app.stage.setChildIndex(debugText,debugText.parent.numChildren-1);
							}
							else
								debugText.visible = false;
						}
						if(event.keyCode == Keyboard.DELETE)
						{
							debugText.text = '';
							line = 0;
						}
					});
				};
				app.addEventListener(Event.ADDED_TO_STAGE,addtostage);
			}
		}
		/**
		 * 要打印的文本 
		 * @param value
		 * 
		 */             
		public static function log(...rest):void
		{
			line += 1;
			if(debugText == null)
				throw new Error("请先调用init()方法完成实例化!");
			if(line % 2 == 0)
				debugText.htmlText = debugText.htmlText +"<p><font color='#999999'><b>第" + line.toString() + "条:" + rest.toString()+'</b></font>';
			else
				debugText.htmlText = debugText.htmlText +"<p><font color='#ff0000'><b>第" + line.toString() + "条:" + rest.toString()+'</b></font>';
			debugText.scrollV = debugText.bottomScrollV;
		}
	}
}
class ZS123Singleton{}