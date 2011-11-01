package com.framework.utils
{
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * 单例管理类
	 * 
	 * <pre>
	 * static public function getInstance():LocalManager
	 * {
	 * 		return Singleton.getInstance(LocalManager) as LocalManager;
	 * }
	 * </pre>
	 * 
	 * @author 任冬
	 * $Id: Singleton.as 243 2010-08-23 13:20:47Z rendong $
	 * @version 1.0
	 */
    public class Singleton
    {
		/**
		 * 保留类引用 
		 */		
		private static var dict:Dictionary = new Dictionary();
        
        public function Singleton()
        {
			var ref:Class = this["constructor"] as Class;
			if (dict[ref])
				throw new ArgumentError(getQualifiedClassName(this)+" Not Allow Create Singleton Instance！");
			else
				dict[ref] = this;
        }
		
		/**
		 * 销毁方法
		 * 
		 */		
		public function destory():void
		{
			var ref:Class = this["constructor"] as Class;
			delete dict[ref];
		}
		
        /**
         * 获取单例类，若不存在则创建
         * 
         * @param ref	继承自Singleton的类
         * @return 
         * 
         */
        public static function getInstance(ref:Class):*
        {
			if (dict[ref] == null)
				dict[ref] = new ref();
			
			return dict[ref];
        }
		
		/**
		 * 获取单例类，若不存在则返回null，可用于判断该单例类是否存在
		 * @param ref
		 * @return 
		 * 
		 */		
		public static function getInstanceExist(ref:Class):*
		{
			return dict[ref];	
		}
    }
}