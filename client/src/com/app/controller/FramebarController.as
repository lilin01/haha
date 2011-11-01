package com.app.controller
{
	import com.app.controller.HomeController;
	import com.app.controller.RecruitController;
	import com.app.view.FramebarView;
	
	import com.framework.controller.BaseController;
	public class FramebarController extends BaseController
	{
		
		
		private var _framebarview:FramebarView; 
		
		public function FramebarController()
		{
			this.init();
		}
		
		public function init():void{
	
			_framebarview = new FramebarView();
			//_framebarview.setContainer(Application.instance.Stage);
			_framebarview.setContainer(this);
			_framebarview.init();		
			
			
		}//init
		
		public static function get instance ():FramebarController
		{
			return BaseController.getInstance(FramebarController) as FramebarController;
		}
		
		 
		public function renderFrameBarView():void{ 
						
			Application.instance.Stage.addChild(_framebarview);
			
		}//render_framebarview
		
		public function askformoreAction():void{
			trace("askformoreAction");
		}

		public function get framebarview():FramebarView
		{
			return _framebarview;
		}

		public function set framebarview(value:FramebarView):void
		{
			_framebarview = value;
		}

		
	}
}