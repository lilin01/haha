package com.framework.utils.loader
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	/**
	 * 可视化文件加载器
	 * 做了在加载相同文件地址时，只加载一次的处理
	 * 
	 * @author 任冬 rendong@corp.the9.com
	 * $Id: DisplayLoader.as 448 2010-11-05 13:38:43Z rendong $
	 * @version 1.0
	 */
	public class DisplayLoader
	{
		/**
		 * 是否开启trace输出 
		 */		
		public static var debugTrace:Boolean = true;
		/**
		 * 重试次数 
		 */		
		public static var retryTimes:int = 3;
		
		/**
		 * 加载的资源池
		 */
		private static var currentLoaderUrl:Object = {};
		/**
		 * LoaderInfo => Url 
		 */		
		private static var loaderInfoUrl:Dictionary = new Dictionary(true);
		
		/**
		 * 等待加载的文件队列 文件地址
		 */		
		private static var urlQueue:Vector.<String> = new Vector.<String>();
		
		/**
		 *  等待加载的文件队列 值地址
		 */
		private static var valueQueue:Vector.<Object> = new Vector.<Object>();
		
		/**
		 * 图片加载队列 
		 */		
		private static var imageLoaderQueue:Vector.<Object> = new Vector.<Object>();
		
		/**
		 * 图片加载缓存 
		 */		
		private static var imageCache:Object = {};
		
		/**
		 * 获取可视化加载对象
		 *  
		 * @param url			文件地址
		 * @param callback		加载成功后的回调函数，参数为：LoaderInfo
		 * @param failCallback	加载失败后的回调函数，参数为：LoaderInfo LoaderInfo.content 为null
		 * @param progressCallback	进度加载回调函数，参数为：ProgressEvent
		 * @param lc				加载的上下文
		 * @param vars				附加的参数，一般如果考虑版本号，就加这个
		 * 
		 */		
		public static function getLoaderInfo(url:String, callback:Function, failCallback:Function=null, progressCallback:Function=null, lc:LoaderContext=null, vars:URLVariables = null):void
		{
			var param:Object = {};
			param['lc'] = lc;
			param['url'] = url;
			param['callback'] = callback;
			param['fcallback'] = failCallback;
			param['pcallback'] = progressCallback;
			param['vars'] = vars;
			
			// 如果当前文件正在加载，则放入队列
			if (currentLoaderUrl[url])
			{
				urlQueue.push(url);

				valueQueue.push(param);
			}else{
				loadFile(param);
			}
		}
		
		
		/**
		 * 获取可视化加载对象<br />
		 * 有内部缓存处理<br />
		 * 返回的为Loader类型
		 * 		 *  
		 * @param url			文件地址
		 * @param callback		加载成功后的回调函数，参数为：LoaderInfo
		 * @param failCallback	加载失败后的回调函数，参数为：LoaderInfo 为null
		 * @param progressCallback	进度加载回调函数，参数为：ProgressEvent
		 * @param lc				加载的上下文
		 * @param vars				附加的参数，一般如果考虑版本号，就加这个
		 * 
		 */
		public static function getCachedLoaderInfo(url:String, callback:Function, failCallback:Function=null, progressCallback:Function=null, lc:LoaderContext=null, vars:URLVariables = null):void
		{
			HttpLoader.getInstance().httpCachedData(url, function(__bytes:ByteArray):void{
				if (__bytes == null){
					if (failCallback != null)
						failCallback(null);
					return;
				}
				
				var bytesLoader:Loader = new Loader();
				
				// 加载成功
				bytesLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, function (completeEvent:Event):void{
					bytesLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, arguments.callee);
					
					callback(bytesLoader.contentLoaderInfo);
				});
				
				// 加载失败
				bytesLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function (e:IOErrorEvent):void{
					bytesLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, arguments.callee);
					trace("getCachedLoaderInfo", url, e);
					if (failCallback is Function)
						failCallback(null);
				});
				
				if (lc == null)
					lc = new LoaderContext(false, ApplicationDomain.currentDomain);
				
				bytesLoader.loadBytes(__bytes, lc);
				
			}, vars, progressCallback, URLRequestMethod.GET, URLLoaderDataFormat.BINARY);
		}
		
		
		/**
		 * 加载图片处理<br/>
		 * 返回的为BitmapData类型<br/>
		 * 如果要删除该bitmapdata对象，请调用deleteCachedBitmapData
		 *  
		 * @param url			文件地址
		 * @param callback		加载成功后的回调函数，参数为：BitmapData
		 * @param failCallback	加载失败后的回调函数，参数为：null
		 * @param progressCallback	进度加载回调函数，参数为：ProgressEvent
		 * @param lc				加载的上下文
		 * @param vars				附加的参数，一般如果考虑版本号，就加这个
		 * 
		 */
		public static function getCachedBitmapData(url:String, callback:Function, failCallback:Function=null, progressCallback:Function=null, lc:LoaderContext=null, vars:URLVariables = null, AddToQueue:Boolean = true):void
		{
			var param:Object = {};
			param['url'] = url;
			param['callback'] = callback;
			param['vars'] = vars;
			param['progress'] = progressCallback;
			param['failCallback'] = failCallback;
			param['lc'] = lc;
			
			// 如果正在加载，则放入队列
			if (imageLoaderQueue.length > 0 && AddToQueue)
			{				
				imageLoaderQueue.push(param);
				return;
			}else if (AddToQueue){
				imageLoaderQueue.push(param);
			}
			
			var cachedBmd:BitmapData = imageCache[url+vars];
			
			// 以下代码是检测位图有效性，如果调用位图的dispose方法释放内存，则位图失效
			try{
				if (cachedBmd != null)
					cachedBmd.width;
			}catch(error:Error){
				cachedBmd = null;
			}
			
			// 缓存判断
			if (cachedBmd != null)
			{				
				callback(imageCache[url+vars]);
				removeAndExecImageQueue(url, callback, failCallback, progressCallback, lc, vars);
			}else{
				imageCache[url+vars] = null;
				
				getCachedLoaderInfo(url, function (loaderInfo:LoaderInfo):void{
					imageCache[url+vars] = (loaderInfo.loader.content as Bitmap).bitmapData;
					(loaderInfo.loader.content as Bitmap).bitmapData = null;
					loaderInfo.loader.unload();
					
					callback(imageCache[url+vars]);
					removeAndExecImageQueue(url, callback, failCallback, progressCallback, lc, vars);
				}, function (param:LoaderInfo):void{					
					if (failCallback != null)
						failCallback();
					removeAndExecImageQueue(url, callback, failCallback, progressCallback, lc, vars);
				}, progressCallback, lc, vars);
			}
		}
		
		/**
		 * 删除缓存引用，释放内存
		 * 不调用BitmapData的dispose方法
		 * @param bmd
		 * 
		 */		
		public static function deleteCachedBitmapData(bmd:BitmapData):void
		{
			for(var key:String in imageCache)
			{
				if (imageCache[key] == bmd)
				{
					imageCache[key] = null;
					delete imageCache[key];
					break;
				}
			}
		}
		
		
		// 删除队列并继续执行队列
		private static function removeAndExecImageQueue(url:String, callback:Function, failCallback:Function=null, progressCallback:Function=null, lc:LoaderContext=null, vars:URLVariables = null):void
		{
			var param:Object;
			for(var i:int = 0; i<imageLoaderQueue.length; i++)
			{
				param = imageLoaderQueue[i];
				if (param.url == url && param.callback==callback && param.vars == vars &&
					param.progress == progressCallback && param.failCallback == failCallback && param.lc == lc)
				{
					imageLoaderQueue.splice(i, 1);
					param = null;
					break;
				}
			}
			
			// 继续执行队列
			if (imageLoaderQueue.length > 0)
			{
				param = imageLoaderQueue[0];
				getCachedBitmapData(param.url, param.callback, param.failCallback, param.progress, param.lc, param.vars, false);
			}
		}
		
		/**
		 * 加载文件 
		 * @param param
		 */		
		private static function loadFile(param:Object):void
		{
			var loader:Loader = new Loader();
			
			param['loader'] = loader;
			var url:String = param['url'];
			
			currentLoaderUrl[url] = param;
			loaderInfoUrl[loader] = url;
			
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			
			var req:URLRequest = new URLRequest(url);
			param['req'] = req;
			
			if (param['vars'] != null)
				req.data = param['vars'];
			
			loader.load(req, param['lc']);
		}

		// 进度事件
		private static function progressHandler(e:ProgressEvent):void
		{
			var loader:LoaderInfo = e.target as LoaderInfo;
			
			var url:String = loaderInfoUrl[loader.loader];
		
			// trace("progressHandler", url, e.bytesLoaded/ e.bytesTotal);			
			var param:Function = currentLoaderUrl[url]['pcallback'] as Function;
			if (param != null)
				param(e);
		}
		
		// 加载完毕
		private static function completeHandler(e:Event):void
		{
			var loader:LoaderInfo = e.target as LoaderInfo;
			var url:String = loaderInfoUrl[loader.loader];
			var param:Object = currentLoaderUrl[url];
			
			param['state'] = 'finish';
			
			var func:Function = null;
			
			if (e is IOErrorEvent)
				func = param['fcallback'];
			else
				func = param['callback'];
			
			if (func != null)
				func(loader);
			
			currentLoaderUrl[url] = null;
			loaderInfoUrl[loader.loader] = null;
			delete currentLoaderUrl[url];
			delete loaderInfoUrl[loader.loader];
			
			var index:int = urlQueue.indexOf(url);
			// 加载下个文件
			if (index != -1)
			{
				// trace(">>>>queue", url);
				urlQueue.splice(index, 1);
				param = valueQueue[index];
				valueQueue.splice(index, 1);
				
				loadFile(param);
			}
		}
		
		// 错误处理
		private static function errorHandler(e:IOErrorEvent):void
		{
			var loader:LoaderInfo = e.target as LoaderInfo;
			var url:String = loaderInfoUrl[loader.loader];
			
			var param:Object = currentLoaderUrl[url];
			// 重试3次如果还是加载失败，则返回null
			if (param['times'] >= retryTimes)
				completeHandler(e);
			else
			{
				var times:int = param['times'];
				times++;
				param['times'] = times;
				if (debugTrace)
					trace("DisplayLoader", " URL:", url, " Fail retry...", times);
				var l:Loader = param['loader'];
				l.load(param['req'], param['lc']);
			}
		}
	}
}