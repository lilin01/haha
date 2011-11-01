package com.framework.model
{
	
	
	/**
	 * 数据模块基础类
	 * 
	 * @author 任冬 rendong@corp.the9.com
	 * $Id: BaseModel.as 281 2010-09-05 16:33:38Z rendong $
	 * @version 1.0
	 */
	public class BaseModel
	{
		/**
		 * 通用的缓存保存变量 
		 */		
		protected var _cache:Object;
		
		/**
		 * 所有的监听事件 
		 */		
		private var _listener:Object;
		
		/**
		 * 请求序列号 
		 */		
		private var _seq:int;
		/**
		 * 处理 队列锁 
		 */		
		private var _processLock:Object;
		
		/**
		 * 调用序列 
		 */		
		private var _invokeSeq:Object;
		
		/**
		 * 添加数据处理方法 
		 * 添加后，如果有数据变化，会一直回调
		 * 
		 * @param method	方法名称
		 * @param param	    method参数
		 * @param callback	数据回调
		 * 
		 */		
		public function addDataHandler(method:String, param:Object, callback:Function):void
		{
			_seq ++;
			
			if (_listener == null)
				_listener = {};
			
			if (_listener[method] == null)
				_listener[method] = [];
			
			var temp:Object;
			
			var i:int = 0;
			var flag:Boolean = false;
			for(i=0; i<_listener[method].length; i++)
			{
				temp = _listener[method][i];
				if (temp!=null && temp.callback == callback)
				{
					temp.seq = _seq; //  已经存在了，则直接更新seq
					flag = true;
					break;
				}
			}
			
			if (!flag)
			{
				_listener[method].push({'callback':callback, 'seq':_seq});
			}
			
			if (_processLock == null)
				_processLock = {};
			
			// 一个时间只允许一个调用
			if (_processLock[method] == null || _processLock[method] == false)
			{
				_processLock[method] = true;
				
				if (_invokeSeq == null)
					_invokeSeq = {};
				
				_invokeSeq[method] = _seq;// 调用序列号
				
				// 调用方法
				flag = false;
				try{
					flag = this.hasOwnProperty(method);
				}catch(e:Error){
					flag = false;
				}
				
				if (flag)
					this[method](param);
			}
		}
		
		/**
		 * 删除数据处理方法 
		 * @param method	方法名称
		 * @param callback	数据回调
		 * 
		 */		
		public function removeDataHandler(method:String, callback:Function):void
		{
			if (_listener != null && _listener[method] != null)
			{
				var temp:Object;
				
				for(var i:int=0; i<_listener[method].length; i++)
				{
					temp = _listener[method][i];
					if (temp!=null && temp.callback == callback)
					{
						_listener[method].splice(i, 1);
						break;
					}
				}
			}
		}
		

		/**
		 * 通知函数 
		 * @param method		调用方法名称
		 * @param dataChange	数据是否有变化
		 * @param data			数据
		 * 
		 */		
		protected function notify(method:String, dataChange:Boolean, data:Object):void
		{
			// 删除调用锁
			if (_processLock != null && _processLock[method] == true)
			{
				_processLock[method] = false;
			}
			
			if (_invokeSeq == null || _listener == null)
				return;
			
			var i:int;
			var temp:Object;
			var callback:Function;
			var seq:int = _invokeSeq[method];

			// 回调数据
			var arr:Array = _listener[method];
			for(i=0; i<arr.length; i++)
			{
				temp = arr[i];
				// 如果数据无变化，则只通知新加的处理函数
				if (!dataChange && temp['seq'] < seq)
					continue;
				
				callback = temp['callback'];
				callback(data);
			}
		}
	}
}