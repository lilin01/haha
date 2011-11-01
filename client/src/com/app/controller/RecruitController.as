package com.app.controller
{
	import com.app.view.RecruitView;
	import com.framework.controller.BaseController;
	
	
	
	public class RecruitController extends BaseController
	{
		private var _stage:App;
		
		private var _rv:RecruitView; 
		
		public function RecruitController()
		{
			this.init();
		}
		
		public static function get instance ():RecruitController
		{
			return BaseController.getInstance(RecruitController) as RecruitController;
		}		
		
		public function init():void{ 
			this._stage = Application.instance.Stage;
				
			
			
			  
		}
		
		private function initEvents():void{
			
		}
		
		
		public function renderRecruitView():void{
			this._rv=null;
			this._rv = new RecruitView();
			_rv.setContainer(this);
			_rv.init();
			LayerController.instance.renderView(this._rv);
		}//Render
		
		public function renderHome():void{
			HomeController.instance.renderHomeView();
		}
		
	}
}