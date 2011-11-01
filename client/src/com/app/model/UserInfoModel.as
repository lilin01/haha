package com.app.model
{
	import com.adobe.serialization.json.JSON;
	import com.app.config.UrlConfig;
	import com.framework.model.BaseModel;
	import com.framework.utils.Singleton;
	import com.framework.utils.loader.HttpLoader;
	import com.vo.UserInfoVo;
	import com.vo.WeaponItemVo;
	
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	
	public class UserInfoModel extends BaseModel
	{
		
		private var _userInfo:UserInfoVo;
		
		public function UserInfoModel()
		{
			
		}
		
		/**
		 * 获取单例 
		 * @return 
		 * 
		 */		
		public static function get instance():UserInfoModel
		{
			return Singleton.getInstance(UserInfoModel) as UserInfoModel;
			
		}	
		public function RefreshData(callback:Function):void{
			HttpLoader.getInstance().httpJson(UrlConfig.HTTPROOT + UrlConfig.GETUSERINFO,
				//HttpLoader.getInstance().httpJson("http://127.0.0.1/GetUserInfo.json",
					function (result:Object):void{
						_RefreshData_CallBack(result);
						callback(_userInfo);
						trace("RefreshData");
					}
					, null,null,URLRequestMethod.POST)
				
				}
		private function _RefreshData_CallBack(result:Object):void{
			if(result["status"] == 1) {
				this._userInfo = new UserInfoVo(result);
				trace("_RefreshData_CallBack");
			}
		}
		
		
		
		public function get UserInfo():UserInfoVo{
			
			return this._userInfo; 
			
		}
		
		public function set UserInfo(Object:UserInfoVo):void{
			this._userInfo = Object;
		}
		
		public function adjustStats(param1:int, param2:int, param3:int = 0):void
		{
			this.UserInfo.gold=UserInfo.gold+param1;
			this.UserInfo.karma = this.UserInfo.karma + param2;
			this.UserInfo.token = this.UserInfo.token+ param3;
			this.notify("dataChange",true,this.UserInfo);
			/*this.statTest.gold.text = this.getFormattedNumber(this.gold);
			this.statTest.karma.text = this.karma;
			this.statTest.tokens.text = this.tokens;*/
			return;
		}
		
		
		
		public function removeSelectedWeapon(param1:Object):void
		{
			var i:int = 0;
			while (i < this.UserInfo.weaponInventory.length)
			{
				
				if (UserInfo.weaponInventory[i] != null && UserInfo.weaponInventory[i].iid == param1.iid)
				{
					//temp = UserInfo.weaponInventory[i];
					UserInfo.weaponInventory.splice(i, 1);
					//return temp;
					return
				}
				i++;
			}
			//return null;
		}
		
		
		public function removeSelectedRelic(param1:Object):void
		{
			var i:int = 0;
			while (i < this.UserInfo.relicInventory.length)
			{
				
				if (UserInfo.relicInventory[i] != null && UserInfo.relicInventory[i].iid == param1.iid)
				{
					//temp = UserInfo.relicInventory[i];
					UserInfo.relicInventory.splice(i, 1);
					//return temp;
					return
				}
				i++;
			}
			//return null;
		}
		public function dataChange(param:Object):void{
		}
	}
}