package com.framework.utils
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	
	
	/**
	 * 套接字处理类
	 * 这个为json格式数据处理
	 * 主要做了合并两个断包的工作
	 * 
	 * @author 任冬 rendong@corp.the9.com
	 * $Id: SocketData.as 557 2010-12-07 16:04:42Z rendong $
	 * @version 1.0
	 */
	public class SocketData
	{
		/**
		 * 是否是调试模式
		 */
		public var debug:Boolean =false;
		
		/**
		 * 套接字 
		 */		
		private var _socket:Socket;
		
		private var host:String;
		private var port:int;
		
		/**
		 * 数据回调函数 
		 */		
		private var _dataCallback:Function;
		
		/**
		 * 错误信息回调函数 
		 */		
		private var _errorCallback:Function;
		
		/**
		 * 数据 
		 */		
		private var _data:String;
		
		/**
		 * 发送数据 
		 */		
		private var _sendData:Array;
		
		/**
		 * 重连次数 
		 */		
		private var reconnectedTimes:int = 0;
		
		/**
		 * 构造函数 
		 * @param host
		 * @param port
		 * @param dataCallback	数据回调函数 callback(data:String)
		 * @param errorCallback	错误信息回调函数 callback(message:String)
		 * 
		 */		
		public function SocketData(host:String, port:int, dataCallback:Function, errorCallback:Function = null)
		{
			this.host = host;
			this.port = port;
			
			_socket = new Socket();
			
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			_socket.addEventListener(Event.CLOSE, closeHandler);
			_socket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_socket.addEventListener(ProgressEvent.SOCKET_DATA, dataHandler);
			_socket.addEventListener(Event.CONNECT, connectHandler);
			
			_socket.connect(host, port);
			_dataCallback = dataCallback;
			_errorCallback = errorCallback;
		}
		
		/**
		 * 发送数据 
		 * 结尾要加\r\n
		 * 
		 * @param message	发送消息
		 * 
		 */		
		public function postMessage(message:String):void
		{
			if (_socket.connected)
			{
				// trace("postMessage");
				if (debug)
					trace("<<<socket send>>>", message);
				_socket.writeUTFBytes(message);
				_socket.flush();
				_data = null;
			}else{
				if (_sendData == null)
					_sendData = [];
				
				_sendData.push(message);
			}
		}
		
		/**
		 * 断开连接 
		 * 
		 */		
		public function close():void
		{
			_socket.close();
		}
		
		// 连接事件
		private function connectHandler(e:Event):void
		{
			var msg:String;
			// trace ("connet");
			if (_sendData != null && _sendData.length > 0)
			{
				while(_sendData.length > 0)
				{
					msg = _sendData.shift();
					// trace("send data");
					if (debug)
						trace("<<<socket send>>>", msg);
					_socket.writeUTFBytes(msg);
					_socket.flush();
				}
			}
		}
		
		// 安全错误
		private function securityErrorHandler(e:SecurityErrorEvent):void
		{
			if(!_socket.connected)
			{
				// 遇到安全问题重试10次
				if (reconnectedTimes < 10)
				{
					reconnectedTimes++;
					
					_socket.connect(host, port);
					return;
				}
			}
			
			if (_errorCallback != null)
				_errorCallback(e);
		}
		
		// 关闭事件
		private function closeHandler(e:Event):void
		{
			if (_errorCallback != null)
				_errorCallback(e);
		}
		// io网络错误
		private function ioErrorHandler(e:IOErrorEvent):void
		{
			if (_errorCallback != null)
				_errorCallback(e);
		}
		
		// 数据事件
		private function dataHandler(e:ProgressEvent):void
		{
			var str:String = _socket.readUTFBytes(_socket.bytesAvailable);
			
			if (debug)
				trace("<<<socket recv>>>",str);
			
			if (_data == null && checkJsonFinish(str))
				jsonDataHandler(str);
			else{
				if (_data == null)
					_data = str;
				else
				{
					_data += str;
					
					if (checkJsonFinish(_data)){
						jsonDataHandler(_data);
						_data = null;
					}
				}
			}
		}
		
		/**
		 * 获取连接的套接字对象
		 */
		public function getSocket():Socket
		{
			return _socket;
		}
		

		/**
		 * 处理json数据包
		 * 主要处理粘包情况
		 * @param str	json字符串
		 * 
		 */		
		private function jsonDataHandler(jsonStr:String):void
		{
			var m1:int=0, m2:int=0, n1:int=0, n2:int=0;
			var i:int = 0,length:int;
			length= jsonStr.length;
			
			var code:Number;
			
			var start:int, end:int;
			start = 0;
			for(i=0; i<length; i++)
			{
				code = jsonStr.charCodeAt(i);
				if (code == 91)// [
					m1++;
				else if (code == 93) // ]
					m2++;
				else if (code == 123) // {
					n1++;
				else if (code == 125) // }
					n2++;
				
				if (m1 == m2 && n1 == n2 && (m1 != 0 || n1 != 0))
				{
					m1 = m2 = n1 = n2 = 0;
					end = i+1;
					_dataCallback(jsonStr.substring(start, end));
					start = end;
					end = -1;
				}
			}
		}
		
		
		/**
		 * 判断json字符串是否完整 
		 * 主要是判断中括号和大括号是否完全匹配
		 * @param jsonStr
		 * 
		 */		
		private function checkJsonFinish(jsonStr:String):Boolean
		{
			var m1:int=0, m2:int=0, n1:int=0, n2:int=0;
			var i:int = 0,length:int;
			length= jsonStr.length;
			
			var code:Number;
			
			for(i=0; i<length; i++)
			{
				code = jsonStr.charCodeAt(i);
				if (code == 91)// [
					m1++;
				else if (code == 93) // ]
					m2++;
				else if (code == 123) // {
					n1++;
				else if (code == 125) // }
					n2++;
			}
			if (m1 == m2 && n1 == n2)
				return true;
			else
				return false;
		}
	}
}