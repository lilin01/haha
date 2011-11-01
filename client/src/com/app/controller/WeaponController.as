package com.app.controller
{
	import com.app.controller.LayerController;
	import com.app.model.WeaponModel;
	import com.app.view.WeaponView;
	import com.framework.controller.BaseController;
	import com.vo.WeaponItemVo;
	import com.framework.utils.loader.HttpLoader;
	import com.app.config.UrlConfig;
	import flash.net.*;
	public class WeaponController extends BaseController
	{
		
		
		
		private var _weaponview:WeaponView; 
		
		
		public function WeaponController()
		{
			this.init();
		}
		
		public static function get instance ():WeaponController
		{
			return BaseController.getInstance(WeaponController) as WeaponController;
		}		
		
		public function init():void{ 
			
			
			//_weaponview.init();
			
		}
		
		
		public function renderWeaponView():void{
			this._weaponview=null;
			this._weaponview = new WeaponView();
			_weaponview.setContainer(this);
			LayerController.instance.renderView(this._weaponview);
		}//Render
		
		public function renderHome():void{
			HomeController.instance.renderHomeView();
		}		
		
		public function weaponBuyAction(callback:Function,data:String):void{
			trace("weaponBuyAction");
			//trace(data.name);
			//WeaponModel.instance.getWeaponItemList(data);
			var variable:URLVariables= new URLVariables();
			variable.iid = data;
			HttpLoader.getInstance().httpJson(UrlConfig.PURCHASEWEAPON,callback,variable);
			//WeaponModel.instance.addDataHandler("buyWeapon",data,callback);
			//WeaponModel.instance.buyWeapon(data);
		}
		/*public function weaponBuyActionCallback(arr:Array):void{
			trace("weaponBuyActionCallback");
			WeaponModel.instance.removeDataHandler("buyWeapon",weaponBuyActionCallback);
			
		}*/
		//i为所卖出武器的iid
		public function weaponSellAction(callback:Function,i:int):void{
			trace("weaponSellAction"+i);
			
			var variable:URLVariables= new URLVariables();
			variable.iid =i;
			HttpLoader.getInstance().httpJson(UrlConfig.SELLITEM,callback,variable);
			/*var o:Object={};
			o.i=i;
			WeaponModel.instance.addDataHandler("sellWeapon",o,callback);*/
			
		}
	}
}