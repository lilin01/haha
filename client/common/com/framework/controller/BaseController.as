package com.framework.controller
{
	import com.framework.view.ViewComponent;
	
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * 控制器基类
	 * 继承该类实现 xxAction方法，供view调用
	 * 参数为：xxAction(param:Object=null, callback:Function=null)
	 * 
	 * 
	 * @author 任冬 rendong@corp.the9.com
	 * $Id: BaseController.as 345 2010-09-28 07:48:51Z rendong $
	 * @version 1.0
	 */
	public class BaseController
	{
		/**
		 * 语言处理函数，由外部统一设置 
		 */		
		private static var _Function:Function;
		
		/**
		 * 存放单例类实例 
		 */		
		private static var dict:Dictionary = new Dictionary();
		
		/**
		 * 单例构造类 
		 * 
		 */		
		public function BaseController()
		{
			var ref:Class = this["constructor"] as Class;
			
			if (dict[ref])
				throw new ArgumentError(getQualifiedClassName(this)+" Not Allow Create Instance！");
			else{
				if (dict[ref] != false)
					throw new ArgumentError(getQualifiedClassName(this)+" Not Allow Create Instance！");
				
				dict[ref] = this;
			}
		}
		
		/**
		 * 设置语言处理函数
		 * @param func
		 * 
		 */		
		public static function setLanFunction(func:Function):void
		{
			_Function = func;
		}
		
		/**
		 * 获取国际化语言 
		 * @param key	语言关键字
		 * @return 
		 * 
		 */		
		public function _(key:String):String
		{
			if (_Function!=null)
				return _Function(key);
			else
				return "v?" + key+"?";// 还未找到
		}
		
		/**
		 * 获取单例类
		 * 子类自己实现具体的方法 
		 * @param ref
		 * @return 
		 * 
		 */		
		public static function getInstance(ref:Class):BaseController
		{	
			if (BaseController.dict[ref] == null){
				// 创建实例锁
				dict[ref] = false;
				
				dict[ref] = new ref();
			}
			
			return dict[ref] as BaseController;
		}
		
		/**
		 * 默认调用方法
		 * 当访问的action不存在时，调用此方法
		 * 
		 * @param methodName	调用方法名称，如：getUserListAction
		 * @param callback		方法回调函数
		 * @param params		方法参数，数组格式
		 * 
		 */		
		public function defaultAction(methodName:String,  callback:Function, params:Array):void
		{
			trace("BaseController_defaultAction method:["+methodName+"]");
			// override
		}
	}
}