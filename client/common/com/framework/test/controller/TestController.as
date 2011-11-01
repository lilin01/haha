package com.framework.test.controller
{
	import com.framework.controller.BaseController;
	import com.framework.model.BaseModel;
	import com.framework.test.model.TestModel;
	import com.framework.test.view.TestView;
	import com.framework.utils.Singleton;
	
	
	/**
	 * TestController
	 * @author 任冬 rendong@corp.the9.com
	 * $Id: TestController.as 345 2010-09-28 07:48:51Z rendong $
	 * @version 1.0
	 */
	public class TestController extends BaseController
	{

		/**
		 * 获取实例 
		 * @return 
		 * 
		 */		
		public static function get instance():TestController
		{
			return BaseController.getInstance(TestController) as TestController;
		}
		
		
		public function testAction(callback:Function, UserId:int):void
		{
			trace("invoke testAction", UserId);
			
			TestModel.getInstance().addDataHandler("getUserInfo", null, this.callback);
			//TestModel.getInstance().removeDataHandler("getUserInfo", this.callback);
			//TestModel.getInstance().addDataHandler("getUserList", null, this.callback2);
		}
		
		public function test2Action(callback:Function):void
		{
			trace("invoke test2Action");
			
			//TestModel.getInstance().removeDataHandler("getUserInfo", this.callback);
			//TestModel.getInstance().addDataHandler("getUserList", null, this.callback2);
		}
		
		/**
		 * 初始化 
		 * 
		 */		
		public function init():void
		{
			trace ("TestController init");
			
			var view:TestView = new TestView();
			view.setContainer(this);
			
			view.testMethod();
			
			var m:BaseModel = new BaseModel();
			
			//start
			m.addDataHandler("getUserList", null, callback);
		}
		
		private function callback(data:Object):void
		{
			trace("c1", data.uid);
		}
		
		private function callback2(data:Object):void
		{
			trace("c2", data.uid);
		}
	}
}