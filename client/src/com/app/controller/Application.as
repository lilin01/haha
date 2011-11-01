package com.app.controller
{
	import com.framework.controller.BaseController;
	import com.framework.utils.loader.DisplayLoader;
	import com.framework.utils.loader.MutiFileLoader;
	import com.framework.view.ViewComponent;
	
	import flash.display.Stage;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	
	
	
	
	
	public class Application extends BaseController
	{
		
		private var _app:App;
		


		
		public function Application()
		{
			super();
			this.init(this._app);
		}
		 
		public static function get instance ():Application
		{
			return BaseController.getInstance(Application) as Application;
		}
		
		public function init(app:App):void{
			this._app = app;

				
		}
		
		
		
		public function initView():void{
			
			//DisplayLoader.getCachedLoaderInfo("/res/map.swf",loaded,failcallback);
			
			//查看帧率
			//stage.addChild(new FPSStats());		
			
			
			//trace(pm.btn1.x);
			//trace(pm.btn1.y);
			
			
			//pm.addChild(pm.btn1) ;

			LayerController.instance.init(this._app);
			
			FramebarController.instance.renderFrameBarView();
			//HomeController.instance.renderHomeView();

			
			
			
		}
		
		public function get Stage():App{ 
			return _app;
		}
		
		

		

		
	}
}