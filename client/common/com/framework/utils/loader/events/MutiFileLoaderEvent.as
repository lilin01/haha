package com.framework.utils.loader.events
{
	import flash.events.Event;
	
	/**
	 * MutiFileLoaderEvent
	 * @author 陈刚 chengang@corp.the9.com
	 * $Id: MutiFileLoaderEvent.as 247 2010-08-24 07:19:16Z rendong $
	 * @version 1.0
	 */
	public class MutiFileLoaderEvent extends Event
	{
		/**
		 * 全部文件加载完毕的事件
		 */		
		public static const COMPLETE:String = "MutiFileLoader_COMPLETE";
		
		/**
		 * 全部文件加载进度事件
		 */		
		public static const PROGRESS:String = "MutiFileLoader_PROGRESS";
		
		/**
		 * 全部文件开始加载事件
		 */		
		public static const INIT:String = "MutiFileLoader_INIT";
		
		/**
		 * 加载完毕该参数为loader对象
		 * 加载进度该参数为单文件发出事件loaderInfo对象
		 */		
		private var _mutiFileLoader:Object;
		
		public function MutiFileLoaderEvent(mutiFileLoader:Object, 
											type:String = MutiFileLoaderEvent.COMPLETE, 
											bubbles:Boolean = false, 
											cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			_mutiFileLoader = mutiFileLoader;
		}
		
		override public function clone():Event
		{
			return new MutiFileLoaderEvent(mutiFileLoader, type, bubbles, cancelable);
		}

		/**
		 * 加载完毕该参数为loader对象
		 * 加载进度/开始加载  该参数为fileArr[i]
		 * 
		 */
		public function get mutiFileLoader():Object
		{
			return _mutiFileLoader;
		}
		
		/**
		 * 获取当前正在加载的文件占总队列的进度 
		 * @return 
		 * 
		 */		
		public function get totalProgress():Number
		{
			return _mutiFileLoader['progTotalRatio'];
		}
		
		/**
		 * 获取当前正在加载的文件的进度 
		 * @return 
		 * 
		 */		
		public function get myProgress():Number
		{
			return _mutiFileLoader['progRatio'];
		}
	
		public function get url ():String
		{
			return _mutiFileLoader['url'];
		}
	}
}