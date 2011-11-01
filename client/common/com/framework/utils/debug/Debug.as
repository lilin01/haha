package com.framework.utils.debug
{
	
	/**
	 * Debug
	 * @author 任冬 rendong@corp.the9.com
	 * $Id: Debug.as 243 2010-08-23 13:20:47Z rendong $
	 * @version 1.0
	 */
	public class Debug
	{
		/**
		 * 调试函数
		 * @param	o
		 * @param	pad
		 * @param	j
		 */
		public static function dump(o:Object, pad:String = "", j:int = 0):void
		{
			if (o == null)
				trace('null object');
			else
			{
				if (j == 0)
					trace ('dump -- start ***************************');
				else
					trace(pad + "dump -- start");
				
				if (typeof o == 'object')
				{
					for (var i:String in o){
						trace (pad+i + '=' + o[i]);
						if (o[i] != null && typeof o[i] == 'object' && j < 2)
							dump(o[i], pad + "\t", j+1);
					}
				}else{
					trace(o);
				}
				if (j == 0)
					trace ('dump -- end ***************************');
				else
					trace(pad + "dump -- end");
			}
		}
	}
}