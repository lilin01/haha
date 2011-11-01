package com.framework.utils.loader
{
	import com.framework.utils.loader.events.MutiFileLoaderEvent;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	/**
	 * 多个文件一起加载，顺序加载、进度相关处理
	 * @author 陈刚 chengang@corp.the9.com
	 * $Id: MutiFileLoader.as 351 2010-10-08 07:52:08Z rendong $
	 * @version 1.0
	 */
	public class MutiFileLoader extends EventDispatcher
	{
		/**
		 * 加载文件数组,数组中存放加载文件的对象名字等字典数据
		 */		
		private var _fileArr:Vector.<Object> = new Vector.<Object>();
		
		/**
		 * 当前加载文件的索引
		 */		
		private var _curFileIndex:int = 0;
		
		/**
		 * 总共需要加载的文件数量
		 */		
		private var _totalFileNum:int = 0;
		
		private var _urlRequest:URLRequest;
		
		/**
		 * 已经完成的进度 
		 */		
		private var _progLoader:Number;
		
		/**
		 * 使用load加载的扩展名，其余使用urlLoader加载
		 */		
		private static const LOAD_TYPE :Array = ["swf", "png", "gif", "jpg", "jpeg"];
		
		/**
		 * 开始加载文件
		 * addFile("test.jpg", obj{id:"test", 								//id
		 * 						   url:"/test.swf?a=1"						//url
		 * 						   domain:ApplicationDomain.currentDomain, 	//安全域    默认为系统当前域   可以直接调用对方
		 * 						   version:"1.0.0", 						//版本号
		 *                         type:"loader", 							//loader类型为loader还是urlLoader
		 * 						   dataFormat:URLLoaderDataFormat.TEXT,		//urlLoader的format
		 * 						   loaderInfo:loader.contentLoaderInfo,		//记录可以侦听单个文件的进度loaderInfo  取值为：loader: loader.contentLoaderInfo, urlLoader: URLLoader
		 * 						   ratio:0.2,								//占总共加载文件的百分比
		 * 						   progRatio:0.3,							//单文件加载进度百分比
		 * 							progTotalRatio:0.5						// 单文件占总进度的百分比
		 * 						   msg:"正加载资源文件"						//提示加载信息
		 * 						   });
		 * @param fileName
		 * @param obj
		 * 
		 */		
		public function addFile(fileUrl:String, fileId:String, obj:Object = null):void
		{
			obj = obj || {};
			obj['url'] = fileUrl;
			obj['id'] = fileId;
			//判断后缀名是LOAD_TYPE数组中内容时则type为loader
			obj['type'] = (LOAD_TYPE.indexOf(getUrlExtension(fileUrl)) != -1)?"loader":"urlLoader";
			_fileArr.push(obj);
			_totalFileNum ++;
		}
		
		/**
		 * 开始加载队列资源
		 * 
		 */		
		public function load():void
		{
			_progLoader = 0;
			
			if(!_fileArr.length)
				return;
			loadContent(_curFileIndex);
		}
		
		/**
		 * 获得指定id的loader对象,并返回loaderInfo和urlLoader的共同父类
		 * @param id
		 * @return 
		 * 
		 */		
		public function getLoader(id:String):EventDispatcher
		{
			for each(var obj:Object in _fileArr)
			{
				if(obj['id'] == id)
					return obj['loaderInfo'];
			}
			return null;
		}
		
		/**
		 * 获得指定id的内容，若为loader则是loaderinfo,若是urlloader则是urlloader.data
		 * 
		 */		
		public function getContent(id:String):Object
		{
			var loaderType:EventDispatcher = getLoader(id);
			if(loaderType is LoaderInfo)
				return loaderType as LoaderInfo
			else if(loaderType is URLLoader)
				return (loaderType as URLLoader).data;
			return null;
		}
		
		/**
		 * 加载单个资源处理函数
		 * 
		 */		
		private function loadContent(fileIndex:int):void
		{
			var obj:Object = _fileArr[fileIndex];
			_urlRequest = new URLRequest(obj['url']);
			if(obj['version'])
			{
				var variables:URLVariables = new URLVariables();
				variables.version = obj['version'];
				_urlRequest.data = variables;
			}
			//没指定加载比例则默认为平分加载
			if(!obj['ratio'])
				obj['ratio'] = 1/_totalFileNum;
			//load加载
			if(obj['type'] == "loader")
			{
				//loader加载有应用域
				if(!obj['domain'])
					obj['domain'] = ApplicationDomain.currentDomain;
				
				var loader:Loader = new Loader();
				obj['loaderInfo'] = loader.contentLoaderInfo;
				loader.contentLoaderInfo.addEventListener(Event.INIT, initHandler);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
				loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				loader.load(_urlRequest, new LoaderContext(false, obj['domain']));
			}
			//urlLoader加载
			else
			{
				if(!obj['dataFormat'])
					obj['dataFormat'] = URLLoaderDataFormat.TEXT;
				var urlLoader:URLLoader = new URLLoader();
				urlLoader.dataFormat = obj['dataFormat'];
				obj['loaderInfo'] = urlLoader;
				urlLoader.addEventListener(Event.OPEN, initHandler);
				urlLoader.addEventListener(Event.COMPLETE, completeHandler);
				urlLoader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				urlLoader.load(_urlRequest);
			}
		}
		
		/**
		 * 加载完成时处理处理函数
		 * @param event
		 * 
		 */		
		private function completeHandler(event:Event):void
		{
			_progLoader += _fileArr[_curFileIndex]['ratio'];
			_fileArr[_curFileIndex]['progTotalRatio'] = _progLoader;
			
			(event.target as EventDispatcher).removeEventListener(Event.COMPLETE, completeHandler);
			_curFileIndex++;
			//全部加载完毕
			if(_curFileIndex == _totalFileNum)
			{
				dispatchEvent(new MutiFileLoaderEvent(this, MutiFileLoaderEvent.COMPLETE));
				return;
			}
			loadContent(_curFileIndex);
		}
		
		/**
		 * 开始加载触发函数
		 * @param event
		 * 
		 */		
		private function initHandler(event:Event):void
		{
			dispatchEvent(new MutiFileLoaderEvent(_fileArr[_curFileIndex], MutiFileLoaderEvent.INIT));
		}
		
		/**
		 * 加载进度触发函数
		 * @param event
		 * 
		 */		
		private function progressHandler(event:ProgressEvent):void
		{
			_fileArr[_curFileIndex]['progRatio'] = event.bytesLoaded/event.bytesTotal;
			_fileArr[_curFileIndex]['progTotalRatio'] = _progLoader + _fileArr[_curFileIndex]['progRatio'] * _fileArr[_curFileIndex]['ratio'];
			dispatchEvent(new MutiFileLoaderEvent(_fileArr[_curFileIndex], MutiFileLoaderEvent.PROGRESS));
		}
		
		/**
		 * 加载错误处理函数
		 * @param event
		 * 
		 */		
		private function ioErrorHandler(event:IOErrorEvent):void
		{
			(event.target as EventDispatcher).removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			dispatchEvent(event);
		}
		
		/**
		 * 获得url中的后缀名
		 * @param url
		 * 
		 */		
		private function getUrlExtension(url:String):String
		{
			//去除?后面字串部分
			var firstIndex:int = url.indexOf("?");
			var firstPart:String = (firstIndex > -1)?url.slice(0, firstIndex):url;
			//去除/前面部分
			var secondPart:String = firstPart.slice(firstPart.lastIndexOf("/") + 1);
			//trace("secondPart: " + secondPart);
			//获得后缀名并转换成小写
			var extension:String = secondPart.slice(secondPart.indexOf(".") + 1).toLowerCase();
			//trace("extension: " + extension);
			return extension;
		}
	}
}