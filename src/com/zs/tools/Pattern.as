package com.zs.tools
{
	public class Pattern
	{
		public function Pattern()
		{
		}
		/**
		 * 检查验证email 
		 * @return 
		 * 
		 */             
		public static function get checkEmailReg():RegExp
		{
			return /([0-9a-zA-Z]+[-._+&])*[0-9a-zA-Z]+@([-0-9a-zA-Z]+[.])+[a-zA-Z]{2,6}/;
		}
	}
}