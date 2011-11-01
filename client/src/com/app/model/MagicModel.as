package com.app.model
{
	import com.app.config.UrlConfig;
	import com.app.model.UserInfoModel;
	import com.framework.model.BaseModel;
	import com.framework.utils.Singleton;
	import com.framework.utils.loader.HttpLoader;
	import com.vo.MagicItemVo;
	import com.vo.UserInfoVo;
	
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	public class MagicModel extends BaseModel
	{
		
		//private var _magicItemVo:MagicItemVo;
	
		private var _magicItemList:Array;
		/*private var _sortedMagics:Array;*/
		/**
		 *获得排好序的以获取的但未使用的武器 
		 * @return 
		 * 
		 */
		/*public function get sortedMagics():Array
		{
			return _sortedMagics;
		}
		
		public function set sortedMagics(value:Array):void
		{
			_sortedMagics = value;
		}*/
		
		
		public function get magicItemList():Array
		{
			return _magicItemList;
		}
		
		/*public function get magicOwnedList():Array
		{
		return _magicOwnedList;
		}*/
		
		public function buyMagic(para:MagicItemVo):void
		{
			trace("buyMagic success");
			var s:String="success";
			var o:Object=new Object;
			o.state=s;
			this.notify("buyMagic",true,o);
		}
		
		public function getMagicItemList(para:MagicItemVo):void
		{
			//return _magicItemList;
			trace("para==null=--------------"+ (para==null));
			trace(para.name);
			
		}
		
		public function set magicItemList(arr:Array):void
		{
			_magicItemList=arr;
			//this.notify("magicItemList",true,_magicItemList);
		}
		public function MagicModel()
		{
			super();
			
		}
		
		
		
		public static function get instance():MagicModel
		{
			
			return Singleton.getInstance(MagicModel) as MagicModel;
			
			
		}
		
		/**
		 *		 
		 * @param callback
		 * 
		 */		
		public function RefreshData(callback:Function):void{
			HttpLoader.getInstance().httpJson(UrlConfig.HTTPROOT + UrlConfig.GETMAGICLIST,
				//HttpLoader.getInstance().httpJson("http://127.0.0.1/GetMagicList.json",
				function (result:Array):void{
					_RefreshData_CallBack(result);
					callback();
				}
				, null,null,URLRequestMethod.POST)
		}
		
		private function _RefreshData_CallBack(result:Array):void{
			if(result!=null) {
				_magicItemList=new Array();
				//_magicOwnedList=new Array();
				for ( var i:int= 0; i < result.length; i++)
				{
					var item:MagicItemVo=new MagicItemVo(result[i]);
					_magicItemList.push(item);
				}
				/*for ( var j:int= 0; j < result['magicOwnedList'].length; j++)
				{
				var item2:MagicOwnedVo=new MagicOwnedVo(result['magicOwnedList'][j]);
				
				_magicOwnedList.push(item2);
				
				}*/
				_magicItemList.sortOn(["min_level", "damage"], [Array.NUMERIC, Array.NUMERIC]);
				//populatePlayerInventory();
			}
		}
		/**
		 *判断是否拥有 
		 * @param item
		 * @return 
		 * 
		 */
		public function ownMagic(item:MagicItemVo):Boolean{
			if(UserInfoModel.instance.UserInfo.magic.sid==undefined||UserInfoModel.instance.UserInfo.magic.sid==0){
				return false;
			}else if(item.sid==UserInfoModel.instance.UserInfo.magic.sid){
				return true;
			}else{
				return false;
			}
		}
		
		
	}
}