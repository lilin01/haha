package com.app.controller
{
	import com.app.controller.RecruitController;
	import com.app.view.FramebarView;
	import com.app.view.HomeView;
	import com.framework.controller.BaseController;
	
	public class HomeController extends BaseController
	{

		private var _homeview:HomeView; 
		

		public function HomeController()
		{
			this.init();
		}	
		public function init():void{
			
			this._homeview = new HomeView(); 
			this._homeview.setContainer(Application.instance.Stage);
			this._homeview.init();
			
			
		}//init
		
		public static function get instance ():HomeController
		{
			return BaseController.getInstance(HomeController) as HomeController;
		}
		
		
		public function renderHomeView():void{
			  
			LayerController.instance.renderView(this._homeview);
			
		}//renderHomeView
		
		
		public function renderRecruitView():void{
			RecruitController.instance.renderRecruitView();		
		}//gotoRecruitView		
	}
}