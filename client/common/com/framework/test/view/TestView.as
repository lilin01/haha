package com.framework.test.view
{
	import com.framework.view.ViewComponent;
	
	/**
	 * ViewTest
	 * @author 任冬 rendong@corp.the9.com
	 * $Id: TestView.as 243 2010-08-23 13:20:47Z rendong $
	 * @version 1.0
	 */
	public class TestView extends ViewComponent
	{
		public function TestView()
		{
			trace("viewtest");
		}
		
		public function testMethod():void
		{
			var lan:String = _("testKey");
			
			trace(lan);
			
			var UserId:int = 1000;
			callMethod("test", null, UserId);
			
		}
	}
}