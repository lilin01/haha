package com.vo
{
	public class WeaponOwnedVo
	{
		private var _weaponid:String = "";
		
		
		private var _weaponNum:Number=0.0;
		
		
		
		public function WeaponOwnedVo(dt:Object)
		{
			try{
				for(var key:String in dt)
				{
					this["_" + key] = dt[key];
				}
			}
			catch(ex:Error){
				
			}
		}
		
		
		public function get weaponid():String{
			return this._weaponid;
		}
		
		
		public function get weaponNum():Number{
			return this._weaponNum;
		}
		
	}
}// ActionScript file