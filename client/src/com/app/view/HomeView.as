package com.app.view
{

	import com.app.controller.DojoController;
	import com.app.controller.MagicController;
	import com.app.controller.RecruitController;
	import com.app.controller.RelicController;
	import com.app.controller.StagingController;
	import com.app.controller.WeaponController;
	import com.app.model.UserInfoModel;
	import com.app.view.map.MapMain;
	import com.framework.view.ViewComponent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	
	public class HomeView extends ViewComponent
	{
		public var mapMain:MapMain=new MapMain();
		
		public function HomeView()
		{
			super();
			if(stage)
				init();
			else 
				this.addEventListener(Event.ADDED_TO_STAGE,init);
		}//HomeView
		
		
		public function init(event:Event = null):void{
			this.removeEventListener(Event.ADDED_TO_STAGE,init);	
			//mapMain= new MapMain();
			trace(mapMain);
			mapMain.y=60;
			this.addChild(mapMain);
			
			
		}//init
		
		

		
		
		//private function 

	}
}