package com.framework.test.model
{
	import com.framework.model.BaseModel;
	import com.framework.utils.Singleton;
	import com.framework.utils.SocketData;
	
	import flash.net.Socket;
	import flash.system.Security;
	
	
	/**
	 * TestModel
	 * @author 任冬 rendong@corp.the9.com
	 * $Id: TestModel.as 243 2010-08-23 13:20:47Z rendong $
	 * @version 1.0
	 */
	public class TestModel extends BaseModel
	{
		private static var socket:SocketData;
		
		public function TestModel()
		{
			
		}
		
		public static function getInstance():TestModel
		{
			return Singleton.getInstance(TestModel) as TestModel;
		}
		
		// socket 数据
		private static function callback(data:String):void
		{
			trace("finish");
			trace (data.length);
		}
		
			
		public function getUserInfo(param:Object):void
		{
			var data:Object = {};
			data.uid = 11;
			data.name = 'name';	
			
			this.notify("getUserInfo", true, data);
		}
		
		/**
		 * 获取用户数据 
		 * @param param
		 * 
		 */		
		public function getUserInfo2(param:Object):void
		{
			if (socket == null){
				Security.loadPolicyFile("xmlsocket://127.0.0.1:1238");
				socket = new SocketData("127.0.0.1", 4046, callback);
			}
			
			var sp1:String = String.fromCharCode(1);
			var sp2:String = String.fromCharCode(2);
			var msg:String = "action"+sp2+"test"+sp1+"msg"+sp2+"message....";
			
			for(var i:int=0; i<100; i++)
				msg += 'long msg';
			msg+="\r\n";
			
			socket.postMessage(msg);
		}
	}
}