package com.app.controller
{
	import com.framework.controller.BaseController;
	import com.framework.view.ViewComponent;
	
	import flash.display.MovieClip;
	
	public class LayerController extends BaseController
	{
		private var _stage:App;
		
		
		public function LayerController()
		{
	
			
		}
		
		
		public function init(app:App):void{
			this._stage = app;
		}
		
		public static function get instance ():LayerController
		{
			return BaseController.getInstance(LayerController) as LayerController;
		}
		
		public function renderView(view:ViewComponent):void{
			
			this._stage.addChildAt(view,this._stage.numChildren-1);
			FramebarController.instance.renderFrameBarView();
			
		}
		
		

	}
}