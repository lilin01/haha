package com.app.model
{
	import com.app.config.UrlConfig;
	import com.app.model.UserInfoModel;
	import com.framework.model.BaseModel;
	import com.framework.utils.Singleton;
	import com.framework.utils.loader.HttpLoader;
	import com.vo.RelicItemVo;
	import com.vo.UserInfoVo;
	
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	public class RelicModel extends BaseModel
	{
		
		//private var _relicItemVo:RelicItemVo;
		//private var _relicOwnedList:Array;
		private var _relicItemList:Array;
		private var _sortedRelics:Array;
		/**
		 *获得排好序的以获取的但未使用的武器 
		 * @return 
		 * 
		 */
		public function get sortedRelics():Array
		{
			return _sortedRelics;
		}
		
		public function set sortedRelics(value:Array):void
		{
			_sortedRelics = value;
		}
		
		
		public function get relicItemList():Array
		{
			return _relicItemList;
		}
		
		/*public function get relicOwnedList():Array
		{
		return _relicOwnedList;
		}*/
		
		/*public function buyRelic(para:RelicItemVo):void
		{
			trace("buyRelic success");
			var s:String="success";
			var o:Object=new Object;
			o.state=s;
			this.notify("buyRelic",true,o);
		}*/
		/*public function sellRelic(o:Object):void{
			trace("sellRelic" + o.i);
			//_relicOwnedList.pop();
			//请求服务器，卖出成功返回success
			var s:String="success";
			
			o.state=s;
			this.notify("sellRelic",true,o);
			
		}*/
		public function getRelicItemList(para:RelicItemVo):void
		{
			//return _relicItemList;
			trace("para==null=--------------"+ (para==null));
			trace(para.name);
			
		}
		
		public function set relicItemList(arr:Array):void
		{
			_relicItemList=arr;
			//this.notify("relicItemList",true,_relicItemList);
		}
		public function RelicModel()
		{
			super();
			
		}
		
		
		
		public static function get instance():RelicModel
		{
			
			return Singleton.getInstance(RelicModel) as RelicModel;
			
			
		}
		
		/**
		 *		 
		 * @param callback
		 * 
		 */		
		public function RefreshData(callback:Function):void{
			HttpLoader.getInstance().httpJson(UrlConfig.HTTPROOT + UrlConfig.GETRELICLIST,
				//HttpLoader.getInstance().httpJson("http://127.0.0.1/GetRelicList.json",
				function (result:Object):void{
					_RefreshData_CallBack(result);
					callback();
				}
				, null,null,URLRequestMethod.POST)
		}
		
		private function _RefreshData_CallBack(result:Object):void{
			if(result!=null) {
				_relicItemList=new Array();
				//_relicOwnedList=new Array();
				for ( var i:int= 0; i < result.length; i++)
				{
					var item:RelicItemVo=new RelicItemVo(result[i]);
					_relicItemList.push(item);
				}
				/*for ( var j:int= 0; j < result['relicOwnedList'].length; j++)
				{
				var item2:RelicOwnedVo=new RelicOwnedVo(result['relicOwnedList'][j]);
				
				_relicOwnedList.push(item2);
				
				}*/
				_relicItemList.sortOn(["sortLevel", "karma_value", "value"], [Array.NUMERIC, Array.NUMERIC, Array.NUMERIC]);
				populatePlayerInventory();
			}
		}
		/**
		 *从用户信息中获取已有的relic列表 
		 * 
		 */		
		public function populatePlayerInventory():void
		{
			var _loc_2:Boolean = false;
			var _loc_3:int = 0;
			sortedRelics = [];
			var _loc_1:int = 0;
			while (_loc_1 < UserInfoModel.instance.UserInfo.relicInventory.length)
			{
				
				if (UserInfoModel.instance.UserInfo.relicInventory[_loc_1] == null)
				{
				}
				else
				{
					_loc_2 = false;
					_loc_3 = 0;
					while (_loc_3 < sortedRelics.length)
					{
						
						if (UserInfoModel.instance.UserInfo.relicInventory[_loc_1].iid == sortedRelics[_loc_3][0].iid)
						{
							sortedRelics[_loc_3].push(UserInfoModel.instance.UserInfo.relicInventory[_loc_1]);
							_loc_2 = true;
							break;
						}
						_loc_3++;
					}
					if (!_loc_2)
					{
						sortedRelics.push(new Array(UserInfoModel.instance.UserInfo.relicInventory[_loc_1]));
					}
				}
				_loc_1++;
			}
			return;
		}
		/**
		 *通过id获取relic信息 
		 * @return 
		 * 
		 */		
		/*public function getRelicById(id:String):RelicItemVo{
			for(var i:int=0;i<_relicItemList.length;i++)
			{
				if(_relicItemList[i].iid==id)
					return _relicItemList[i];
			}
			return null;
			
		}*/
		/**
		 *判断relic是否已经购买 
		 * @param param1
		 * @return 
		 * 
		 */		
		public function ownRelic(param1:Object):Boolean
		{
			var i:int = 0;
			while (i < sortedRelics.length)
			{
				
				if (param1.iid ==this.sortedRelics[i][0].iid)
				{
					return true;
				}
				i++;
			}
			i = 0;
			while (i < UserInfoModel.instance.UserInfo.activeRelics.length)
			{
				
				if (param1.iid ==  UserInfoModel.instance.UserInfo.activeRelics[i].iid)
				{
					return true;
				}
				i++;
			}
			return false;
		}
	}
}