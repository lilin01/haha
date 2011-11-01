package com.app.view
{
	import com.app.config.UrlConfig;
	import com.app.model.RelicModel;
	import com.app.model.UserInfoModel;
	import com.framework.utils.CommonUtils;
	import com.framework.view.ViewComponent;
	import com.vo.RelicItemVo;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	import res.relics.mcRelicItem;
	public class RelicItemView extends ViewComponent
	{
		
		public var _relicItemVo:RelicItemVo = null;
		public var _relicItem:mcRelicItem=null;
		public function RelicItemView()
		{
			
			_relicItem=new mcRelicItem();
			addChild(_relicItem);
		}
		public function setDate(relicItemVo:RelicItemVo ):void {
			_relicItem.chain.visible=false;
			this._relicItemVo = relicItemVo;
			while(_relicItem.mc_image.numChildren)
				_relicItem.mc_image.removeChildAt(0);
			_relicItem.newStar.visible = false;
			if(_relicItemVo.attributes.new_item != undefined && _relicItemVo.attributes.new_item == "1")
				_relicItem.newStar.visible = true;
			_relicItem.lblOwned.visible=RelicModel.instance.ownRelic(relicItemVo);
			_relicItem.btnClickToBuy.visible =false;
			if(parseInt(this._relicItemVo.attributes.min_level)>parseInt(UserInfoModel.instance.UserInfo.level)){
				_relicItem.chain.visible=true;
				_relicItem.chain.level.text=this._relicItemVo.attributes.min_level;
			}
			CommonUtils.getImageByUrl(UrlConfig.RELICIMGURL+_relicItemVo.sprite+".png",function(mc:Sprite,url:String):void{
				mc.y=150-mc.height;
				//确保不会有图片叠加在下面
				if(_relicItemVo!=null&&url==(UrlConfig.RELICIMGURL+_relicItemVo.sprite+".png")){
					while(_relicItem.mc_image.numChildren)
					_relicItem.mc_image.removeChildAt(0);
					_relicItem.mc_image.addChild(mc);
				}
			});
			
		}
	}
}