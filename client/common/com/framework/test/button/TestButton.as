package com.framework.test.button
{
	import com.framework.utils.controls.SpButton;
	
	import test.BlueButton;
	import test.RedButton;
	
	
	/**
	 * TestButton
	 * @author 任冬 rendong@corp.the9.com
	 * $Id: TestButton.as 253 2010-08-25 09:11:34Z rendong $
	 * @version 1.0
	 */
	public class TestButton extends SpButton
	{
		public function TestButton()
		{
			this.button = new RedButton();
			
			render("textstring", 3, 7);
		}
		
		/**
		 * 渲染后调用
		 * 处理文本过长的情况 
		 * @param txtWidth
		 * 
		 */		
		protected override function afterRender(txtWidth:Number):void
		{
			if (txtWidth <=94)
			{
				setTextLength(94);
			}else if (txtWidth > 94){
				this.button = new BlueButton();
				render(null, 9, 7);
				setTextLength(150);
			}
		}
	}
}