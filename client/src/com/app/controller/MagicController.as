package com.app.controller
{
	import com.app.controller.LayerController;
	import com.app.model.MagicModel;
	import com.app.view.MagicView;
	import com.framework.controller.BaseController;
	import com.vo.MagicItemVo;
	import com.framework.utils.loader.HttpLoader;
	import com.app.config.UrlConfig;
	import flash.net.*;
	public class MagicController extends BaseController
	{
		
		
		
		private var _magicview:MagicView; 
		
		
		public function MagicController()
		{
			this.init();
		}
		
		public static function get instance ():MagicController
		{
			return BaseController.getInstance(MagicController) as MagicController;
		}		
		
		public function init():void{ 
			
			this._magicview = new MagicView(FramebarController.instance.framebarview);
			_magicview.setContainer(this);
			//_magicview.init();
			
		}
		
		
		public function renderMagicView():void{
			LayerController.instance.renderView(this._magicview);
		}//Render
		
		public function renderHome():void{
			HomeController.instance.renderHomeView();
		}		
		
		public function magicKarmaBuyAction(callback:Function,data:int):void{
			trace("magicKarmaBuyAction");
	
			//MagicModel.instance.getMagicItemList(data);
			var variable:URLVariables= new URLVariables();
			variable.sid = data;
			variable.karma=true;
			HttpLoader.getInstance().httpJson(UrlConfig.PURCHASEMAGIC,callback,variable);
			//MagicModel.instance.addDataHandler("buyMagic",data,callback);
			//MagicModel.instance.buyMagic(data);
		}
		public function magicTokensBuyAction(callback:Function,data:int):void{
			trace("magicTokensBuyAction");

			//MagicModel.instance.getMagicItemList(data);
			var variable:URLVariables= new URLVariables();
			variable.sid = data;
			variable.karma=false;
			HttpLoader.getInstance().httpJson(UrlConfig.PURCHASEMAGIC,callback,variable);
			//MagicModel.instance.addDataHandler("buyMagic",data,callback);
			//MagicModel.instance.buyMagic(data);
		}
		/*public function magicBuyActionCallback(arr:Array):void{
			trace("magicBuyActionCallback");
			MagicModel.instance.removeDataHandler("buyMagic",magicBuyActionCallback);
			
		}*/
		//i为所卖出武器的iid
		/*public function magicSellAction(callback:Function,i:int):void{
			trace("magicSellAction"+i);
			var o:Object={};
			o.i=i;
			MagicModel.instance.addDataHandler("sellMagic",o,callback);
			
		}*/
		public function askformoreAction():void{
			trace("askformoreAction");
			
		}
	}
}