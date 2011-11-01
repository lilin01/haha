package com.app.view.weapon
{
	import com.app.config.UrlConfig;
	import com.framework.utils.CommonUtils;
	import com.framework.view.ViewComponent;
	import com.vo.WeaponItemVo;
	import flash.events.MouseEvent;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import com.app.config.UrlConfig;
	import res.weapons.mcWeaponItem;
	import com.app.model.UserInfoModel;
	public class WeaponItemView extends ViewComponent
	{
		
		public var _weaponItemVo:WeaponItemVo = null;
		public var _weaponItem:mcWeaponItem=null;
		public function WeaponItemView()
		{
			
			_weaponItem=new mcWeaponItem();
			addChild(_weaponItem);
		}
		
		
		
		public function setDate(weaponItemVo:WeaponItemVo ):void {
			
			this.addEventListener(MouseEvent.ROLL_OUT , function(...args):void{trace("ROLL_OUT ")});
			this.addEventListener(MouseEvent.ROLL_OVER, function(...args):void{trace("roll_over")});
			_weaponItem.chain.visible=false;
			this._weaponItemVo = weaponItemVo;
			//this._weaponItem = new mcWeaponItem();
			while(_weaponItem.mc_image.numChildren)
				_weaponItem.mc_image.removeChildAt(0);
			//_weaponItem.id = this._weaponItemVo.iid;
			_weaponItem.newStar.visible = false;
			if(_weaponItemVo.attributes.new_item != undefined && _weaponItemVo.attributes.new_item == "1")
				_weaponItem.newStar.visible = true;
			
			_weaponItem.btnClickToBuy.visible = false;
			_weaponItem.lblOwned.visible = false;
			if(parseInt(this._weaponItemVo.attributes.min_level)>parseInt(UserInfoModel.instance.UserInfo.level)){
				_weaponItem.chain.visible=true;
				_weaponItem.chain.level.text=this._weaponItemVo.attributes.min_level;
			}
			
			
			CommonUtils.getImageByUrl(UrlConfig.WEAPONIMGURL+_weaponItemVo.sprite+".png",function(mc:Sprite,url:String):void{
				mc.y=200-mc.height;
				if(_weaponItemVo!=null&&url==(UrlConfig.WEAPONIMGURL+_weaponItemVo.sprite+".png")){
					//确保不会有图片叠加在下面
					while(_weaponItem.mc_image.numChildren)
						_weaponItem.mc_image.removeChildAt(0);
					_weaponItem.mc_image.addChild(mc);
				}
				
				
			});
			
		}
	}
}