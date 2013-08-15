package com.zs.tools
{
	import flash.utils.getQualifiedClassName;
	
	/**
	 *@author showping.tong
	 *@link showping.tong@gmail.com
	 */
	public class ArrayUtil
	{
		//在at位置刪除
		public static function deleteAt(at:uint,inputArr:Array):Array
		{
			var resultArray:Array=new Array;
			resultArray=inputArr
			resultArray.splice(at,1);
			return resultArray;
		}
		//刪除指定元素element
		public static function deleteElement(element:Object,inputArr:Array):Array
		{
			var resultArray:Array=new Array;
			for(var i:uint=0;i<inputArr.length;i++)
			{
				if(inputArr[i]==element)
				{
					inputArr.splice(i,1);
				}
			}
			resultArray=inputArr
			return resultArray;
		}
		//在at位置添加element
		public static function insertAt(element:Object,at:uint,inputArr:Array):Array
		{
			var resultArray:Array=new Array;
			resultArray=inputArr;
			resultArray.splice(at,0,element);            
			return resultArray;
		}
		//兩個數組是否相等
		public static function isEqual(a_Arr:Array,b_Arr:Array):Boolean
		{
			if(a_Arr.length!=b_Arr.length)return false;
			for(var i:uint=0;i<a_Arr.length;i++)
			{
				if(getQualifiedClassName(a_Arr[i])!=getQualifiedClassName(b_Arr[i]))return false;
				if(a_Arr[i]!=b_Arr[i])return false;
			}
			return true;
		}
		//克隆數組
		public static function clone(inputArray:Array):Array
		{
			return inputArray.slice();
		}
		//元素是否在數組內
		public static function objectIsInList(_n : Object, list : Array) : Boolean {
			return (list.indexOf(_n) != -1);
		}
		//在指定范圍內產生一個序列
		public static function getSequence(low:Number,high:Number):Array
		{
			var result:Array = [];
			for (var i:uint=low; i<=high; i++) 
			{
				result.push(i);
			}
			return result;
		}
		//打亂數組順序
		public static function shuffle(inputArray:Array):Array
		{
			var cf:Function = function ():Number 
			{
				var r:Number = Math.random() - 0.5;
				if (r < 0) 
				{
					return -1;
				}
				else 
				{
					return 1;
				}
			}    
			var resultArray:Array = ArrayUtil.clone(inputArray);
			resultArray.sort(cf);
			
			return resultArray;
		}
	}
}