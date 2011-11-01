package com.app.controller
{
	import com.app.controller.LayerController;
	import com.app.view.StagingView;
	import com.framework.controller.BaseController;
	import com.app.controller.FramebarController;
	public class StagingController extends BaseController
	{
		private var _stagingview:StagingView;
		
		public function StagingController()
		{
			this.init();
		}
		
		public static function get instance ():StagingController
		{
			return BaseController.getInstance(StagingController) as StagingController;
		}			
		
		public function init():void{
			/*this._dojoview = new DojoView(); 
			this._dojoview.setContainer(this);
			this._dojoview.init();*/
			
		}
		
		public function renderStagingView():void{
			
			this._stagingview=null;
			this._stagingview = new StagingView(); 
			this._stagingview.setContainer(this);
			this._stagingview.init();
			
			LayerController.instance.renderView(this._stagingview);
			
		}//Render
		
		public function renderHome():void{
			HomeController.instance.renderHomeView();
			FramebarController.instance.framebarview.showAllies();
		}		
		
	}
}