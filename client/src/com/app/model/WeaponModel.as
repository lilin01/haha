package com.app.model
{
	import com.app.config.UrlConfig;
	import com.app.model.UserInfoModel;
	import com.framework.model.BaseModel;
	import com.framework.utils.Singleton;
	import com.framework.utils.loader.HttpLoader;
	import com.vo.UserInfoVo;
	import com.vo.WeaponItemVo;
	
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	public class WeaponModel extends BaseModel
	{
		
		//private var _weaponItemVo:WeaponItemVo;
		//private var _weaponOwnedList:Array;
		private var _weaponItemList:Array;
		private var _sortedWeapons:Array;
		/**
		 *获得排好序的以获取的但未使用的武器 
		 * @return 
		 * 
		 */
		public function get sortedWeapons():Array
		{
			return _sortedWeapons;
		}

		public function set sortedWeapons(value:Array):void
		{
			_sortedWeapons = value;
		}

		
		public function get weaponItemList():Array
		{
			return _weaponItemList;
		}
		
		/*public function get weaponOwnedList():Array
		{
			return _weaponOwnedList;
		}*/
		
		/*public function buyWeapon(para:String):void
		{
			trace("buyWeapon success");
			var s:String="success";
			var o:Object=new Object;
			o.state=s;
			this.notify("buyWeapon",true,o);
		}*/
		/*public function sellWeapon(o:Object):void{
			trace("sellWeapon" + o.i);
			//_weaponOwnedList.pop();
			//请求服务器，卖出成功返回success
			var s:String="success";
			
			o.state=s;
			this.notify("sellWeapon",true,o);
			
		}*/
		public function getWeaponItemList(para:WeaponItemVo):void
		{
			//return _weaponItemList;
			trace("para==null=--------------"+ (para==null));
			trace(para.name);
			
		}
		
		public function set weaponItemList(arr:Array):void
		{
			_weaponItemList=arr;
			//this.notify("weaponItemList",true,_weaponItemList);
		}
		public function WeaponModel()
		{
			super();
			
		}
		
		
		
		public static function get instance():WeaponModel
		{
			
			return Singleton.getInstance(WeaponModel) as WeaponModel;
			
			
		}
		
		/**
		 *		 
		 * @param callback
		 * 
		 */		
		public function RefreshData(callback:Function):void{
			HttpLoader.getInstance().httpJson(UrlConfig.HTTPROOT + UrlConfig.GETWEAPONLIST,
				//HttpLoader.getInstance().httpJson("http://127.0.0.1/GetRelicList.json",
				function (result:Array):void{
					_RefreshData_CallBack(result);
					callback();
				}
				, null,null,URLRequestMethod.POST)
		}
		
		private function _RefreshData_CallBack(result:Array):void{
			if(result!=null) {
				_weaponItemList=new Array();
				//_weaponOwnedList=new Array();
				for ( var i:int= 0; i < result.length; i++)
				{
					var item:WeaponItemVo=new WeaponItemVo(result[i]);
					_weaponItemList.push(item);
									}
				/*for ( var j:int= 0; j < result['weaponOwnedList'].length; j++)
				{
					var item2:WeaponOwnedVo=new WeaponOwnedVo(result['weaponOwnedList'][j]);
					
					_weaponOwnedList.push(item2);
					
				}*/
				_weaponItemList.sortOn(["sortLevel", "karma_value", "value"], [Array.NUMERIC, Array.NUMERIC, Array.NUMERIC]);
				populatePlayerInventory();
			}
		}
		/**
		 *从用户信息中获取已有的weapon列表 
		 * 
		 */		
		public function populatePlayerInventory():void
		{
			var _loc_2:Boolean = false;
			var _loc_3:int = 0;
			sortedWeapons = [];
			var _loc_1:int = 0;
			while (_loc_1 < UserInfoModel.instance.UserInfo.weaponInventory.length)
			{
				
				if (UserInfoModel.instance.UserInfo.weaponInventory[_loc_1] == null)
				{
				}
				else
				{
					_loc_2 = false;
					_loc_3 = 0;
					while (_loc_3 < sortedWeapons.length)
					{
						
						if (UserInfoModel.instance.UserInfo.weaponInventory[_loc_1].iid == sortedWeapons[_loc_3][0].iid)
						{
							sortedWeapons[_loc_3].push(UserInfoModel.instance.UserInfo.weaponInventory[_loc_1]);
							_loc_2 = true;
							break;
						}
						_loc_3++;
					}
					if (!_loc_2)
					{
						sortedWeapons.push(new Array(UserInfoModel.instance.UserInfo.weaponInventory[_loc_1]));
					}
				}
				_loc_1++;
			}
			return;
		}
		/**
		 *通过id获取weapon信息 
		 * @return 
		 * 
		 */		
		public function getWeaponById(id:String):WeaponItemVo{
			for(var i:int=0;i<_weaponItemList.length;i++)
			{
				if(_weaponItemList[i].iid==id)
					return _weaponItemList[i];
			}
			return null;
			
		}
	}
}