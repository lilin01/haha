package com.app.view
{
	import com.app.config.UrlConfig;
	import com.app.model.MagicModel;
	import com.app.model.UserInfoModel;
	import com.framework.utils.CommonUtils;
	import com.framework.view.ViewComponent;
	import com.vo.MagicItemVo;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	import res.magics.mcMagicItem;
	public class MagicItemView extends ViewComponent
	{
		
		public var _magicItemVo:MagicItemVo = null;
		public var _magicItem:mcMagicItem=null;
		public function MagicItemView()
		{
			
			_magicItem=new mcMagicItem();
			addChild(_magicItem);
		}
		public function setDate(magicItemVo:MagicItemVo ):void {
			_magicItem.chain.visible=false;
			this._magicItemVo = magicItemVo;
			while(_magicItem.mc_image.numChildren)
				_magicItem.mc_image.removeChildAt(0);
			_magicItem.newStar.visible = false;
			if(_magicItemVo.new_item != undefined && _magicItemVo.new_item == 1)
				_magicItem.newStar.visible = true;
			_magicItem.lblOwned.visible=MagicModel.instance.ownMagic(magicItemVo);
			_magicItem.btnClickToBuy.visible =false;
			if(this._magicItemVo.min_level>parseInt(UserInfoModel.instance.UserInfo.level)){
				_magicItem.chain.visible=true;
				_magicItem.chain.level.text=this._magicItemVo.min_level;
			}
			CommonUtils.getImageByUrl(UrlConfig.MAGICIMGURL+_magicItemVo.sprite+".png",function(mc:Sprite,url:String):void{
				mc.y=150-mc.height;
				//确保不会有图片叠加在下面
				if(_magicItemVo!=null&&url==(UrlConfig.MAGICIMGURL+_magicItemVo.sprite+".png")){
					while(_magicItem.mc_image.numChildren)
						_magicItem.mc_image.removeChildAt(0);
					_magicItem.mc_image.addChild(mc);
				}
			});
			
		}
	}
}