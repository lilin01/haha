package com.framework.view
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	 * 视图基础模块，包含国际化处理
	 * 
	 * @author 任冬 rendong@corp.the9.com
	 * $Id: ViewComponent.as 243 2010-08-23 13:20:47Z rendong $
	 * @version 1.0
	 */
	public dynamic class ViewComponent extends Sprite
	{
		/**
		 * 语言处理函数，由外部统一设置 
		 */		
		private static var _Function:Function;
		
		/**
		 * 资源处理函数，由外部统一设置 
		 */		
		private static var getDisplayObjectFunction:Function;
		
		/**
		 * 关联的控制对象 
		 */		
		protected var _container:Object;
		
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
		 * 设置资源处理函数 
		 * @param func
		 * 
		 */		
		public static function setGetDisplayObjectFunction(func:Function):void
		{
			getDisplayObjectFunction = func;
		}
		
		/**
		 * 设置包含的容器，控制器or视图
		 * @param instance
		 * 
		 */		
		public function setContainer(instance:Object):void
		{
			_container = instance;
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
		 * 获取国际化资源 
		 * @param classPath	类路径q
		 * @return 
		 * 
		 */		
		public function getDisplayObject(classPath:String):DisplayObject
		{
			if (getDisplayObjectFunction != null)
				return getDisplayObjectFunction(classPath);
			else
				return null;
		}
		
		/**
		 * 调用控制器方法 
		 * @param methodName	方法名称，不包含Action部分
		 * @param param			方法参数， key=>value 方式
		 * @param callback		回调函数
		 * 
		 */				
		public function callMethodAndCallback(methodName:String, callback:Function=null, ...params):void
		{
			if (_container == null)
			{
				trace("Controller is NULL, invoke Controller_", methodName);
				return;
			}
				
			var m:String = methodName + 'Action';
			
			var flag:Boolean = false;
			try{
				flag = _container.hasOwnProperty(m);
			}catch(e:Error){
				flag = false;
			}
			
			if (flag){
				if (params != null)
					params.unshift(callback);
				
				_container[m].apply(null, params);/**///耿帅修改
				//_container[m].apply(callback, params);
			}else
				_container['defaultAction'](m, callback, params);
		}
		
		
		/**
		 * 调用控制器方法 
		 * @param methodName	方法名称，不包含Action部分
		 * @param param			方法参数， key=>value 方式
		 * @param callback		回调函数
		 * 
		 */				
		public function callMethod(methodName:String,...params):void
		{
			if (_container == null)
			{
				trace("Controller is NULL, invoke Controller_", methodName);
				return;
			}
			
			var m:String = methodName + 'Action';
			
			var flag:Boolean = false;
			try{
				flag = _container.hasOwnProperty(m);
			}catch(e:Error){
				flag = false;
			}
			
			if (flag){				
				_container[m].apply(null, params);
			
			}else
				_container['defaultAction'](m, null, params);
		}
	}
}