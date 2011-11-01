package com.app.controller
{
	import com.app.controller.LayerController;
	import com.app.view.DojoView;
	import com.framework.controller.BaseController;
	
	public class DojoController extends BaseController
	{
		private var _dojoview:DojoView;
		
		public function DojoController()
		{
			this.init();
		}

		public static function get instance ():DojoController
		{
			return BaseController.getInstance(DojoController) as DojoController;
		}			
		
		public function init():void{
			/*this._dojoview = new DojoView(); 
			this._dojoview.setContainer(this);
			this._dojoview.init();*/
			
		}
		
		public function renderDojoView():void{
			
			this._dojoview=null;
				this._dojoview = new DojoView(); 
				this._dojoview.setContainer(this);
				this._dojoview.init();
			
			LayerController.instance.renderView(this._dojoview);
			
		}//Render
		
		public function renderHome():void{
			HomeController.instance.renderHomeView();
		}		
		
	}
}