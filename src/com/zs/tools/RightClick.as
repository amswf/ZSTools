package com.zs.tools
{  
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	public class RightClick extends Sprite 
	{  
		public function RightClick():void 
		{  
			
		}
		
		public static function setItem(target:InteractiveObject,itemName:String,callBack:Function=null):void
		{
			var myContextMenu:ContextMenu = new ContextMenu();  
			var item:ContextMenuItem = new ContextMenuItem(itemName);  
			myContextMenu.hideBuiltInItems();  
			myContextMenu.customItems.push(item);  
			target.contextMenu = myContextMenu;  
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,function(event:ContextMenuEvent):void{callBack();}); 
		}
	}  
}  