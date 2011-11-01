package com.app.controller
{
	import com.app.controller.LayerController;
	import com.app.model.RelicModel;
	import com.app.view.RelicView;
	import com.framework.controller.BaseController;
	import com.vo.RelicItemVo;
	import com.framework.utils.loader.HttpLoader;
	import com.app.config.UrlConfig;
	import flash.net.*;
	public class RelicController extends BaseController
	{
		
		
		
		public var relicview:RelicView; 
		
		
		public function RelicController()
		{
			this.init();
		}
		
		public static function get instance ():RelicController
		{
			return BaseController.getInstance(RelicController) as RelicController;
		}		
		
		public function init():void{ 
			
			
			//_relicview.init();
			
		}
		
		
		public function renderRelicView():void{
			this.relicview=null;
			this.relicview = new RelicView();
			relicview.setContainer(this);
			LayerController.instance.renderView(this.relicview);
		}//Render
		
		public function renderHome():void{
			HomeController.instance.renderHomeView();
		}		
		
		public function relicBuyAction(callback:Function,data:String):void{
			trace("relicBuyAction");
			var variable:URLVariables= new URLVariables();
			variable.iid = data;
			HttpLoader.getInstance().httpJson(UrlConfig.PURCHASERELIC,callback,variable);
		}
		/*public function relicBuyActionCallback(arr:Array):void{
			trace("relicBuyActionCallback");
			RelicModel.instance.removeDataHandler("buyRelic",relicBuyActionCallback);
			
		}*/
		//i为所卖出武器的iid
		public function relicSellAction(callback:Function,i:int):void{
			trace("relicSellAction"+i);
			
			var variable:URLVariables= new URLVariables();
			variable.iid =i;
			HttpLoader.getInstance().httpJson(UrlConfig.SELLITEM,callback,variable);
			
		}
	}
}